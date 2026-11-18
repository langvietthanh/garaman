package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import model.BookingContact8;

public class BookingContactDAO8 extends DAO {

    public BookingContactDAO8() {
        super();
    }

    /**
     * Luu nguoi lien he dat lich; id sinh tu dong duoc gan lai vao bc (QD-20).
     * @return true neu luu thanh cong
     */
    public boolean saveBookingContact(BookingContact8 bc) {
        boolean kq = false;
        String sql = "INSERT INTO tblBookingContact8 (fullName, phoneNumber) VALUES (?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, bc.getFullName());
            ps.setString(2, bc.getPhoneNumber());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                bc.setId(rs.getInt(1));
                kq = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = false;
        }
        return kq;
    }
}
