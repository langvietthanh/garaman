package dao;

import java.sql.PreparedStatement;
import model.ServiceDetail8;

public class ServiceDetailDAO8 extends DAO {

    public ServiceDetailDAO8() {
        super();
    }

    /**
     * Luu cac yeu cau dich vu cua phieu yeu cau co id = rfId.
     * Khong tu commit/rollback: chay trong giao dich cua doSaveRequestForm8.jsp.
     */
    public boolean saveServicesDetail(int rfId, ServiceDetail8[] sd) {
        String sql = "INSERT INTO tblServiceDetail8 (quantity, discountAmount, finalPrice, totalPrice, discountNote, "
                + "tblRequestForm8id, tblService8id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            for (ServiceDetail8 d : sd) {
                ps.setInt(1, d.getQuantity());
                ps.setFloat(2, d.getDiscountAmount());
                ps.setFloat(3, d.getFinalPrice());
                ps.setFloat(4, d.getTotalPrice());
                ps.setString(5, d.getDiscountNote());
                ps.setInt(6, rfId);
                ps.setInt(7, d.getService().getId());
                ps.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
