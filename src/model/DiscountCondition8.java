package model;

/** Dieu kien giam gia. */
public class DiscountCondition8 {
    private int id;
    private String description;
    private String conditionType;
    private String operator;
    private float targetValue;

    public DiscountCondition8() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getConditionType() { return conditionType; }
    public void setConditionType(String conditionType) { this.conditionType = conditionType; }
    public String getOperator() { return operator; }
    public void setOperator(String operator) { this.operator = operator; }
    public float getTargetValue() { return targetValue; }
    public void setTargetValue(float targetValue) { this.targetValue = targetValue; }
}
