package model;

import java.util.Date;

/** Phieu nhan xe. customerCar: bo sung cho FK tblCustomerCar8id (can them vao class diagram). */
public class CarReceipt8 {
    private int id;
    private Date actualCreationTime;
    private Date actualReceiptTime;
    private String notes;
    private RequestForm8 requestForm;
    private CustomerCar8 customerCar;

    public CarReceipt8() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Date getActualCreationTime() { return actualCreationTime; }
    public void setActualCreationTime(Date actualCreationTime) { this.actualCreationTime = actualCreationTime; }
    public Date getActualReceiptTime() { return actualReceiptTime; }
    public void setActualReceiptTime(Date actualReceiptTime) { this.actualReceiptTime = actualReceiptTime; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public RequestForm8 getRequestForm() { return requestForm; }
    public void setRequestForm(RequestForm8 requestForm) { this.requestForm = requestForm; }
    public CustomerCar8 getCustomerCar() { return customerCar; }
    public void setCustomerCar(CustomerCar8 customerCar) { this.customerCar = customerCar; }
}
