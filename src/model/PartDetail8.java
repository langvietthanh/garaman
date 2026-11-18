package model;

/** Yeu cau phu tung - trung gian RequestForm8 n-n PartVariant8. */
public class PartDetail8 {
    private int id;
    private int quantity;
    private float discountAmount;
    private float finalPrice;
    private float totalPrice;
    private String discountNote;
    private PartVariant8 partVariant;

    public PartDetail8() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public float getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(float discountAmount) { this.discountAmount = discountAmount; }
    public float getFinalPrice() { return finalPrice; }
    public void setFinalPrice(float finalPrice) { this.finalPrice = finalPrice; }
    public float getTotalPrice() { return totalPrice; }
    public void setTotalPrice(float totalPrice) { this.totalPrice = totalPrice; }
    public String getDiscountNote() { return discountNote; }
    public void setDiscountNote(String discountNote) { this.discountNote = discountNote; }
    public PartVariant8 getPartVariant() { return partVariant; }
    public void setPartVariant(PartVariant8 partVariant) { this.partVariant = partVariant; }

    /** Tinh thanh tien dong va ap giam gia tot nhat trong discounts (chi 1 giam gia/dong). */
    public void calculatePrice(Discount8[] discounts) {
        float unitPrice = partVariant.getListedPrice();
        totalPrice = unitPrice * quantity;
        discountAmount = 0;
        discountNote = null;
        if (discounts != null) {
            for (Discount8 k : discounts) {
                float a = k.calculateDiscount(unitPrice, quantity);
                if (a > discountAmount) {
                    discountAmount = a;
                    discountNote = k.getDiscountName();
                }
            }
        }
        finalPrice = totalPrice - discountAmount;
    }
}
