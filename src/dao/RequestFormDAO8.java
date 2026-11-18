package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import model.RequestForm8;

public class RequestFormDAO8 extends DAO {

    public RequestFormDAO8() {
        super();
    }

    /**
     * Luu phieu yeu cau (chua gom chi tiet); id sinh tu dong gan lai vao rf.
     * Khong tu commit/rollback: chay trong giao dich cua doSaveRequestForm8.jsp.
     */
    public boolean saveRequestForm(RequestForm8 rf) {
        boolean kq = false;
        String sql = "INSERT INTO tblRequestForm8 (processingStatus, estimatedTotal, createdAt, notes, totalDiscount, "
                + "totalListedAmount, tblEmployee8id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, rf.getProcessingStatus());
            ps.setFloat(2, rf.getEstimatedTotal());
            ps.setTimestamp(3, new Timestamp(rf.getCreatedAt().getTime()));
            ps.setString(4, rf.getNotes());
            ps.setFloat(5, rf.getTotalDiscount());
            ps.setFloat(6, rf.getTotalListedAmount());
            ps.setInt(7, rf.getEmployee().getId());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                rf.setId(rs.getInt(1));
                kq = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return kq;
    }
}
