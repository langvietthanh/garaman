package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import model.CarReceipt8;

public class CarReceiptDAO8 extends DAO {

    public CarReceiptDAO8() {
        super();
    }

    /**
     * Luu phieu nhan xe gan voi cr.requestForm (da co id) va cr.customerCar; id sinh tu dong gan lai vao cr.
     * Khong tu commit/rollback: chay trong giao dich cua doSaveRequestForm8.jsp.
     */
    public boolean saveCarReceipt(CarReceipt8 cr) {
        boolean kq = false;
        String sql = "INSERT INTO tblCarReceipt8 (actualCreationTime, actualReceiptTime, notes, tblCustomerCar8id, tblRequestForm8id) "
                + "VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setTimestamp(1, new Timestamp(cr.getActualCreationTime().getTime()));
            ps.setTimestamp(2, new Timestamp(cr.getActualReceiptTime().getTime()));
            ps.setString(3, cr.getNotes());
            ps.setInt(4, cr.getCustomerCar().getId());
            ps.setInt(5, cr.getRequestForm().getId());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                cr.setId(rs.getInt(1));
                kq = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return kq;
    }
}
