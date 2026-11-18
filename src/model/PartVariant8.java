package model;

/** Bien the phu tung. sparePart, listedPrice: bo sung de hien thi ten/don gia (can them vao class diagram). */
public class PartVariant8 {
    private int id;
    private String brand;
    private float markupRate;
    private float discount;
    private int stockQuantity;
    private SparePart8 sparePart;
    private float listedPrice;

    public PartVariant8() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    public float getMarkupRate() { return markupRate; }
    public void setMarkupRate(float markupRate) { this.markupRate = markupRate; }
    public float getDiscount() { return discount; }
    public void setDiscount(float discount) { this.discount = discount; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
    public SparePart8 getSparePart() { return sparePart; }
    public void setSparePart(SparePart8 sparePart) { this.sparePart = sparePart; }
    public float getListedPrice() { return listedPrice; }
    public void setListedPrice(float listedPrice) { this.listedPrice = listedPrice; }
}
