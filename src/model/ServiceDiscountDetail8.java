package model;

/** Chi tiet giam gia dich vu - trung gian Discount8 n-n Service8. */
public class ServiceDiscountDetail8 {
    private int id;
    private Service8 service;
    private Discount8 discount;

    public ServiceDiscountDetail8() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Service8 getService() { return service; }
    public void setService(Service8 service) { this.service = service; }
    public Discount8 getDiscount() { return discount; }
    public void setDiscount(Discount8 discount) { this.discount = discount; }
}
