package model;

/** Phu tung. */
public class SparePart8 {
    private int id;
    private String partName;
    private String description;
    private String unit;
    private float discount;
    private PartVariant8[] partVariants;

    public SparePart8() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getPartName() { return partName; }
    public void setPartName(String partName) { this.partName = partName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public float getDiscount() { return discount; }
    public void setDiscount(float discount) { this.discount = discount; }
    public PartVariant8[] getPartVariants() { return partVariants; }
    public void setPartVariants(PartVariant8[] partVariants) { this.partVariants = partVariants; }
}
