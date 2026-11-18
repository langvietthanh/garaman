package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import model.Customer8;

public class CustomerDAO8 extends DAO {

    public CustomerDAO8() {
        super();
    }

    /** Tim khach hang theo ho ten (gan dung). @return mang rong neu khong tim thay */
    public Customer8[] searchCustomerByName(String name) {
        ArrayList<Customer8> list = new ArrayList<>();
        String sql = "SELECT m.id, m.username, m.fullName, m.phoneNumber, m.address "
                + "FROM tblMember8 m JOIN tblCustomer8 c ON c.id = m.id "
                + "WHERE m.fullName LIKE ? ORDER BY m.fullName";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%" + name.trim() + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Customer8 c = new Customer8();
                c.setId(rs.getInt("id"));
                c.setUsername(rs.getString("username"));
                c.setFullName(rs.getString("fullName"));
                c.setPhoneNumber(rs.getString("phoneNumber"));
                c.setAddress(rs.getString("address"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list.toArray(new Customer8[0]);
    }

    /**
     * Luu khach hang moi (tblMember8 + tblCustomer8); id sinh tu dong gan lai vao c.
     * shortcut: username = password = so dien thoai khi nhan vien tao ho so; doi khi co chuc nang dang ky.
     */
    public boolean saveCustomer(Customer8 c) {
        boolean kq = false;
        String sqlMember = "INSERT INTO tblMember8 (username, password, fullName, phoneNumber, address) VALUES (?, ?, ?, ?, ?)";
        String sqlCustomer = "INSERT INTO tblCustomer8 (id) VALUES (?)";
        try {
            con.setAutoCommit(false);
            PreparedStatement ps = con.prepareStatement(sqlMember, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, c.getUsername() != null ? c.getUsername() : c.getPhoneNumber());
            ps.setString(2, c.getPassword() != null ? c.getPassword() : c.getPhoneNumber());
            ps.setString(3, c.getFullName());
            ps.setString(4, c.getPhoneNumber());
            ps.setString(5, c.getAddress());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                c.setId(rs.getInt(1));
                PreparedStatement ps2 = con.prepareStatement(sqlCustomer);
                ps2.setInt(1, c.getId());
                ps2.executeUpdate();
                con.commit();
                kq = true;
            } else {
                con.rollback();
            }
        } catch (Exception e) {
            e.printStackTrace();
            try { con.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
        } finally {
            try { con.setAutoCommit(true); } catch (Exception ex) { ex.printStackTrace(); }
        }
        return kq;
    }
}
