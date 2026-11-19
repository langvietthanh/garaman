package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import model.Appointment8;
import model.WorkSchedule8;

public class AppointmentDAO8 extends DAO {

    public AppointmentDAO8() {
        super();
    }

    /**
     * Lay tat ca khung gio 30 phut cua ngay da chon, sinh tu openTime - closeTime (QD-03, QD-19).
     * Moi khung la mot Appointment8 co appointmentTime = gio bat dau khung;
     * khung da co lich hen mang id cua lich hen do (id > 0), khung con trong co id = 0.
     * @return mang khung gio; mang rong neu ngay nghi; null neu loi CSDL
     */
    public Appointment8[] getAvailableTimeSlots(Date date) {
        Appointment8[] kq = null;
        String sqlWs = "SELECT openTime, closeTime FROM tblWorkSchedule8 WHERE workDate = ?";
        String sqlAp = "SELECT id, appointmentTime, status FROM tblAppointment8 WHERE DATE(appointmentTime) = ?";
        SimpleDateFormat hm = new SimpleDateFormat("HH:mm");
        try {
            PreparedStatement ps = con.prepareStatement(sqlWs);
            ps.setDate(1, new java.sql.Date(date.getTime()));
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return new Appointment8[0]; // ngay nghi
            }
            String open = rs.getString("openTime").substring(0, 5);
            String close = rs.getString("closeTime").substring(0, 5);
            if (!open.matches("\\d{2}:\\d{2}") || !close.matches("\\d{2}:\\d{2}")) {
                return null;
            }

            // cac lich hen da co trong ngay
            ps = con.prepareStatement(sqlAp);
            ps.setDate(1, new java.sql.Date(date.getTime()));
            rs = ps.executeQuery();
            ArrayList<Appointment8> booked = new ArrayList<Appointment8>();
            while (rs.next()) {
                Appointment8 a = new Appointment8(new Date(rs.getTimestamp("appointmentTime").getTime()),
                        rs.getString("status"), null);
                a.setId(rs.getInt("id"));
                booked.add(a);
            }

            ArrayList<Appointment8> slots = new ArrayList<Appointment8>();
            SimpleDateFormat ymdhm = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            String day = new SimpleDateFormat("yyyy-MM-dd").format(date);
            int start = Integer.parseInt(open.substring(0, 2)) * 60 + Integer.parseInt(open.substring(3));
            int end = Integer.parseInt(close.substring(0, 2)) * 60 + Integer.parseInt(close.substring(3));
            for (int t = start; t + 30 <= end; t += 30) {
                String slot = String.format("%02d:%02d", t / 60, t % 60);
                Appointment8 found = null;
                for (Appointment8 a : booked) {
                    if (hm.format(a.getAppointmentTime()).equals(slot)) {
                        found = a;
                        break;
                    }
                }
                slots.add(found != null ? found : new Appointment8(ymdhm.parse(day + " " + slot), null, null));
            }
            kq = slots.toArray(new Appointment8[0]);
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }

    /**
     * Luu lich hen trang thai "Chờ xác nhận" (QD-20, bang trang thai §2a).
     * Kiem tra: ngay hen thuoc lich lam viec, gio hen nam trong gio mo cua, khung gio chua co lich hen khac,
     * nguoi lien he da duoc luu (a.bookingContact.id > 0).
     * Tu tra tblWorkSchedule8id theo ngay hen va gan lai vao a.workSchedule8; tblCustomer8id = NULL (QD-01).
     * @return true neu luu thanh cong; false neu vi pham kiem tra hoac loi CSDL
     */
    public boolean saveAppointment(Appointment8 a) {
        boolean kq = false;
        if (a == null || a.getAppointmentTime() == null || a.getBookingContact() == null
                || a.getBookingContact().getId() <= 0) {
            return false;
        }
        String sqlWs = "SELECT id, workDate, openTime, closeTime FROM tblWorkSchedule8 WHERE workDate = DATE(?)";
        String sqlCheck = "SELECT COUNT(*) FROM tblAppointment8 WHERE appointmentTime = ?";
        String sqlIns = "INSERT INTO tblAppointment8 (appointmentTime, status, tblCustomer8id,"
                + " tblWorkSchedule8id, tblBookingContact8id) VALUES (?, ?, NULL, ?, ?)";
        Timestamp time = new Timestamp(a.getAppointmentTime().getTime());
        try {
            // 1. ngay hen thuoc lich lam viec
            PreparedStatement ps = con.prepareStatement(sqlWs);
            ps.setTimestamp(1, time);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return false;
            }
            WorkSchedule8 ws = new WorkSchedule8(rs.getInt("id"), new Date(rs.getDate("workDate").getTime()),
                    rs.getString("openTime").substring(0, 5), rs.getString("closeTime").substring(0, 5));

            // 2. khung 30 phut nam tron trong gio mo cua - dong cua
            String hhmm = new SimpleDateFormat("HH:mm").format(a.getAppointmentTime());
            int t = Integer.parseInt(hhmm.substring(0, 2)) * 60 + Integer.parseInt(hhmm.substring(3));
            int open = Integer.parseInt(ws.getOpenTime().substring(0, 2)) * 60
                    + Integer.parseInt(ws.getOpenTime().substring(3));
            int close = Integer.parseInt(ws.getCloseTime().substring(0, 2)) * 60
                    + Integer.parseInt(ws.getCloseTime().substring(3));
            if (t < open || t + 30 > close) {
                return false;
            }

            // 3. khung gio chua co lich hen khac
            ps = con.prepareStatement(sqlCheck);
            ps.setTimestamp(1, time);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false;
            }

            // 4. luu
            a.setStatus("Chờ xác nhận");
            a.setWorkSchedule8(ws);
            ps = con.prepareStatement(sqlIns, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setTimestamp(1, time);
            ps.setString(2, a.getStatus());
            ps.setInt(3, ws.getId());
            ps.setInt(4, a.getBookingContact().getId());
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                a.setId(rs.getInt(1));
            }
            kq = true;
        } catch (Exception e) {
            e.printStackTrace();
            kq = false;
        }
        return kq;
    }
}
