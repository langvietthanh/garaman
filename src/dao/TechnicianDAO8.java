package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Technician8;

public class TechnicianDAO8 extends DAO {

    public TechnicianDAO8() {
        super();
    }

    /** Lay ky thuat vien ranh: khong phu trach phieu yeu cau nao dang o trang thai "Đang xử lý". */
    public Technician8[] getTechnicianList() {
        ArrayList<Technician8> list = new ArrayList<>();
        String sql = "SELECT m.id, m.fullName, m.phoneNumber, e.position, e.workStatus, t.specialty "
                + "FROM tblTechnician8 t JOIN tblEmployee8 e ON e.id = t.id JOIN tblMember8 m ON m.id = t.id "
                + "WHERE NOT EXISTS (SELECT 1 FROM tblAssignmentDetail8 a JOIN tblRequestForm8 r ON r.id = a.tblRequestForm8id "
                + "  WHERE a.tblTechnician8id = t.id AND r.processingStatus = 'Đang xử lý') ORDER BY m.id";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Technician8 t = new Technician8();
                t.setId(rs.getInt("id"));
                t.setFullName(rs.getString("fullName"));
                t.setPhoneNumber(rs.getString("phoneNumber"));
                t.setPosition(rs.getString("position"));
                t.setWorkStatus(rs.getString("workStatus"));
                t.setSpecialty(rs.getString("specialty"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list.toArray(new Technician8[0]);
    }
}
