package model;

import java.util.Date;

/** Giam gia. discountType: Phần trăm | Số tiền. */
public class Discount8 {
    private int id;
    private String discountName;
    private String discountType;
    private float discountValue;
    private String applicableScope;
    private float maxDiscountAmount;
    private float minApplicableAmount;
    private Date startTime;
    private Date endTime;
    private DiscountCondition8[] discountConditions;

    public Discount8() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getDiscountName() { return discountName; }
    public void setDiscountName(String discountName) { this.discountName = discountName; }
    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }
    public float getDiscountValue() { return discountValue; }
    public void setDiscountValue(float discountValue) { this.discountValue = discountValue; }
    public String getApplicableScope() { return applicableScope; }
    public void setApplicableScope(String applicableScope) { this.applicableScope = applicableScope; }
    public float getMaxDiscountAmount() { return maxDiscountAmount; }
    public void setMaxDiscountAmount(float maxDiscountAmount) { this.maxDiscountAmount = maxDiscountAmount; }
    public float getMinApplicableAmount() { return minApplicableAmount; }
    public void setMinApplicableAmount(float minApplicableAmount) { this.minApplicableAmount = minApplicableAmount; }
    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }
    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }
    public DiscountCondition8[] getDiscountConditions() { return discountConditions; }
    public void setDiscountConditions(DiscountCondition8[] discountConditions) { this.discountConditions = discountConditions; }

    /**
     * So tien giam cho mot dong (don gia x so luong); 0 neu khong dat muc toi thieu hoac dieu kien.
     * Dieu kien ho tro: "Số lượng" so voi quantity, "Tổng tiền" so voi thanh tien dong; loai khac coi nhu khong dat.
     */
    public float calculateDiscount(float unitPrice, int quantity) {
        float line = unitPrice * quantity;
        if (line < minApplicableAmount) return 0;
        if (discountConditions != null) {
            for (DiscountCondition8 c : discountConditions) {
                float v;
                if ("Số lượng".equals(c.getConditionType())) v = quantity;
                else if ("Tổng tiền".equals(c.getConditionType())) v = line;
                else return 0;
                String op = c.getOperator();
                boolean ok = ">=".equals(op) ? v >= c.getTargetValue()
                        : ">".equals(op) ? v > c.getTargetValue()
                        : "<=".equals(op) ? v <= c.getTargetValue()
                        : "<".equals(op) ? v < c.getTargetValue()
                        : "=".equals(op) && v == c.getTargetValue();
                if (!ok) return 0;
            }
        }
        float amt = "Phần trăm".equals(discountType) ? line * discountValue / 100 : discountValue;
        if (maxDiscountAmount > 0 && amt > maxDiscountAmount) amt = maxDiscountAmount;
        return Math.min(amt, line);
    }
}
