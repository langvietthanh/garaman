package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.PartDetail8;
import model.PartVariant8;
import model.SparePart8;

public class PartVariantDAO8 extends DAO {

    public PartVariantDAO8() {
        super();
    }

    /**
     * Lay toan bo bien the phu tung kem phu tung cha.
     * Don gia niem yet = gia nhap gan nhat * (1 + markupRate); chua nhap lan nao thi = 0.
     */
    public PartVariant8[] getParts() {
        ArrayList<PartVariant8> list = new ArrayList<>();
        String sql = "SELECT v.id, v.brand, v.markupRate, v.discount, v.stockQuantity, "
                + "p.id AS partId, p.partName, p.description, p.unit, p.discount AS partDiscount, "
                + "COALESCE((SELECT i.importPrice FROM tblImportedPart8 i JOIN tblImportInvoice8 ii ON ii.id = i.tblImportInvoice8id "
                + "  WHERE i.tblPartVariant8id = v.id ORDER BY ii.importDate DESC, i.id DESC LIMIT 1), 0) AS importPrice "
                + "FROM tblPartVariant8 v JOIN tblSparePart8 p ON p.id = v.tblSparePart8id ORDER BY p.partName, v.brand";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SparePart8 p = new SparePart8();
                p.setId(rs.getInt("partId"));
                p.setPartName(rs.getString("partName"));
                p.setDescription(rs.getString("description"));
                p.setUnit(rs.getString("unit"));
                p.setDiscount(rs.getFloat("partDiscount"));
                PartVariant8 v = new PartVariant8();
                v.setId(rs.getInt("id"));
                v.setBrand(rs.getString("brand"));
                v.setMarkupRate(rs.getFloat("markupRate"));
                v.setDiscount(rs.getFloat("discount"));
                v.setStockQuantity(rs.getInt("stockQuantity"));
                v.setSparePart(p);
                v.setListedPrice(Math.round(rs.getFloat("importPrice") * (1 + v.getMarkupRate())));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list.toArray(new PartVariant8[0]);
    }

    /**
     * Tru ton kho theo cac chi tiet phu tung. Chi tru khi con du hang (tranh am kho khi 2 nhan vien cung lap phieu).
     * Khong tu commit/rollback: chay trong giao dich cua doSaveRequestForm8.jsp.
     * @return false neu co bien the khong du ton kho
     */
    public boolean updateStockQuantity(PartDetail8[] pd) {
        String sql = "UPDATE tblPartVariant8 SET stockQuantity = stockQuantity - ? WHERE id = ? AND stockQuantity >= ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            for (PartDetail8 d : pd) {
                ps.setInt(1, d.getQuantity());
                ps.setInt(2, d.getPartVariant().getId());
                ps.setInt(3, d.getQuantity());
                if (ps.executeUpdate() != 1) {
                    return false;
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
