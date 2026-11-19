package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Employee8;

public class EmployeeDAO8 extends DAO {

    public EmployeeDAO8() {
        super();
    }

    /**
     * Kiem tra dang nhap cua nhan vien (tblMember8 + tblEmployee8).
     * shortcut: mat khau luu dang ro trong CSDL (du lieu mau do an); bam mat khau khi trien khai that.
     * @return Employee8 neu dung ten dang nhap va mat khau, null neu sai hoac khong phai nhan vien
     */
    public Employee8 checkLogin(String username, String password) {
        String sql = "SELECT m.id, m.username, m.fullName, m.phoneNumber, m.address, e.position, e.workStatus "
                + "FROM tblMember8 m JOIN tblEmployee8 e ON e.id = m.id "
                + "WHERE m.username = ? AND m.password = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Employee8 e = new Employee8();
                e.setId(rs.getInt("id"));
                e.setUsername(rs.getString("username"));
                e.setFullName(rs.getString("fullName"));
                e.setPhoneNumber(rs.getString("phoneNumber"));
                e.setAddress(rs.getString("address"));
                e.setPosition(rs.getString("position"));
                e.setWorkStatus(rs.getString("workStatus"));
                return e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
