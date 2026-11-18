package dao;

import java.sql.PreparedStatement;
import model.AssignmentDetail8;

public class AssignmentDetailDAO8 extends DAO {

    public AssignmentDetailDAO8() {
        super();
    }

    /**
     * Luu phan cong ky thuat vien cua phieu yeu cau co id = rfId.
     * Khong tu commit/rollback: chay trong giao dich cua doSaveRequestForm8.jsp.
     */
    public boolean saveAssignmentDetail(int rfId, AssignmentDetail8[] ad) {
        String sql = "INSERT INTO tblAssignmentDetail8 (tblRequestForm8id, tblTechnician8id) VALUES (?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            for (AssignmentDetail8 a : ad) {
                ps.setInt(1, rfId);
                ps.setInt(2, a.getTechnician().getId());
                ps.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
