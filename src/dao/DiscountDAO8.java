package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Discount8;
import model.DiscountCondition8;
import model.PartDiscountDetail8;
import model.PartVariant8;
import model.Service8;
import model.ServiceDiscountDetail8;

public class DiscountDAO8 extends DAO {

    public DiscountDAO8() {
        super();
    }

    /** Lay cac giam gia dang hieu luc (startTime <= hom nay <= endTime) ap cho danh sach dich vu s. */
    public ServiceDiscountDetail8[] getServiceDiscount(Service8[] s) {
        ArrayList<ServiceDiscountDetail8> list = new ArrayList<>();
        String sql = "SELECT d.id AS detailId, " + DISCOUNT_COLS
                + "FROM tblServiceDiscountDetail8 d JOIN tblDiscount8 k ON k.id = d.tblDiscount8id "
                + "WHERE d.tblService8id = ? AND CURDATE() BETWEEN k.startTime AND k.endTime";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            for (Service8 sv : s) {
                ps.setInt(1, sv.getId());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    ServiceDiscountDetail8 sd = new ServiceDiscountDetail8();
                    sd.setId(rs.getInt("detailId"));
                    sd.setService(sv);
                    sd.setDiscount(readDiscount(rs));
                    list.add(sd);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list.toArray(new ServiceDiscountDetail8[0]);
    }

    /** Lay cac giam gia dang hieu luc ap cho danh sach bien the phu tung pv. */
    public PartDiscountDetail8[] getPartDiscount(PartVariant8[] pv) {
        ArrayList<PartDiscountDetail8> list = new ArrayList<>();
        String sql = "SELECT d.id AS detailId, " + DISCOUNT_COLS
                + "FROM tblPartDiscountDetail8 d JOIN tblDiscount8 k ON k.id = d.tblDiscount8id "
                + "WHERE d.tblPartVariant8id = ? AND CURDATE() BETWEEN k.startTime AND k.endTime";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            for (PartVariant8 v : pv) {
                ps.setInt(1, v.getId());
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    PartDiscountDetail8 pd = new PartDiscountDetail8();
                    pd.setId(rs.getInt("detailId"));
                    pd.setPartVariant(v);
                    pd.setDiscount(readDiscount(rs));
                    list.add(pd);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list.toArray(new PartDiscountDetail8[0]);
    }

    private static final String DISCOUNT_COLS = "k.id, k.discountName, k.discountType, k.discountValue, k.applicableScope, "
            + "k.maxDiscountAmount, k.minApplicableAmount, k.startTime, k.endTime ";

    /** Doc Discount8 tu dong hien tai kem cac dieu kien giam gia. */
    private Discount8 readDiscount(ResultSet rs) throws Exception {
        Discount8 k = new Discount8();
        k.setId(rs.getInt("id"));
        k.setDiscountName(rs.getString("discountName"));
        k.setDiscountType(rs.getString("discountType"));
        k.setDiscountValue(rs.getFloat("discountValue"));
        k.setApplicableScope(rs.getString("applicableScope"));
        k.setMaxDiscountAmount(rs.getFloat("maxDiscountAmount"));
        k.setMinApplicableAmount(rs.getFloat("minApplicableAmount"));
        k.setStartTime(rs.getDate("startTime"));
        k.setEndTime(rs.getDate("endTime"));
        ArrayList<DiscountCondition8> conds = new ArrayList<>();
        PreparedStatement ps = con.prepareStatement(
                "SELECT id, description, conditionType, operator, targetValue FROM tblDiscountCondition8 WHERE tblDiscount8id = ?");
        ps.setInt(1, k.getId());
        ResultSet r = ps.executeQuery();
        while (r.next()) {
            DiscountCondition8 c = new DiscountCondition8();
            c.setId(r.getInt("id"));
            c.setDescription(r.getString("description"));
            c.setConditionType(r.getString("conditionType"));
            c.setOperator(r.getString("operator"));
            c.setTargetValue(r.getFloat("targetValue"));
            conds.add(c);
        }
        k.setDiscountConditions(conds.toArray(new DiscountCondition8[0]));
        return k;
    }
}
