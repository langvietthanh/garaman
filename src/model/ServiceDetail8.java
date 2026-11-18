package model;

/** Yeu cau dich vu - trung gian RequestForm8 n-n Service8. */
public class ServiceDetail8 {
    private int id;
    private float discountAmount;
    private int quantity;
    private float finalPrice;
    private float totalPrice;
    private String discountNote;
    private Service8 service;

    public ServiceDetail8() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public float getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(float discountAmount) { this.discountAmount = discountAmount; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public float getFinalPrice() { return finalPrice; }
    public void setFinalPrice(float finalPrice) { this.finalPrice = finalPrice; }
    public float getTotalPrice() { return totalPrice; }
    public void setTotalPrice(float totalPrice) { this.totalPrice = totalPrice; }
    public String getDiscountNote() { return discountNote; }
    public void setDiscountNote(String discountNote) { this.discountNote = discountNote; }
    public Service8 getService() { return service; }
    public void setService(Service8 service) { this.service = service; }

    /** Tinh thanh tien dong va ap giam gia tot nhat trong discounts (chi 1 giam gia/dong). */
    public void calculatePrice(Discount8[] discounts) {
        float unitPrice = service.getListedPrice();
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
