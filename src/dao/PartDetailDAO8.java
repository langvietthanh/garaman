package dao;

import java.sql.PreparedStatement;
import model.PartDetail8;

public class PartDetailDAO8 extends DAO {

    public PartDetailDAO8() {
        super();
    }

    /**
     * Luu cac yeu cau phu tung cua phieu yeu cau co id = rfId.
     * Khong tu commit/rollback: chay trong giao dich cua doSaveRequestForm8.jsp.
     */
    public boolean savePartsDetail(int rfId, PartDetail8[] pd) {
        String sql = "INSERT INTO tblPartDetail8 (quantity, discountAmount, finalPrice, totalPrice, discountNote, "
                + "tblRequestForm8id, tblPartVariant8id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            for (PartDetail8 d : pd) {
                ps.setInt(1, d.getQuantity());
                ps.setFloat(2, d.getDiscountAmount());
                ps.setFloat(3, d.getFinalPrice());
                ps.setFloat(4, d.getTotalPrice());
                ps.setString(5, d.getDiscountNote());
                ps.setInt(6, rfId);
                ps.setInt(7, d.getPartVariant().getId());
                ps.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
