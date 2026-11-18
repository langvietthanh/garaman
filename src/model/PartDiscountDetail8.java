package model;

/** Chi tiet giam gia phu tung - trung gian Discount8 n-n PartVariant8. */
public class PartDiscountDetail8 {
    private int id;
    private PartVariant8 partVariant;
    private Discount8 discount;

    public PartDiscountDetail8() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public PartVariant8 getPartVariant() { return partVariant; }
    public void setPartVariant(PartVariant8 partVariant) { this.partVariant = partVariant; }
    public Discount8 getDiscount() { return discount; }
    public void setDiscount(Discount8 discount) { this.discount = discount; }
}
