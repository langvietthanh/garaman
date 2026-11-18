package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import model.WorkSchedule8;

public class WorkScheduleDAO8 extends DAO {

    public WorkScheduleDAO8() {
        super();
    }

    /**
     * Lay cac ngay gara hoat dong (ngay co ban ghi lich lam viec), tu ngay mai tro di (QD-03, QD-10).
     * @return mang ngay hoat dong; null neu loi CSDL
     */
    public Date[] getAvailableDates() {
        Date[] kq = null;
        String sql = "SELECT id, workDate, openTime, closeTime FROM tblWorkSchedule8"
                + " WHERE workDate > CURDATE() ORDER BY workDate";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            ArrayList<WorkSchedule8> list = new ArrayList<WorkSchedule8>();
            while (rs.next()) {
                WorkSchedule8 ws = new WorkSchedule8(rs.getInt("id"),
                        new Date(rs.getDate("workDate").getTime()),
                        rs.getString("openTime").substring(0, 5),
                        rs.getString("closeTime").substring(0, 5));
                // QD-19: gio mo/dong phai dung dinh dang HH:mm
                if (ws.getOpenTime().matches("\\d{2}:\\d{2}") && ws.getCloseTime().matches("\\d{2}:\\d{2}")) {
                    list.add(ws);
                }
            }
            kq = new Date[list.size()];
            for (int i = 0; i < list.size(); i++) {
                kq[i] = list.get(i).getWorkDate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }
}
