package model;

import java.util.Date;

/** Xe khach hang - lop trung gian Customer8 n-n Car8. */
public class CustomerCar8 {
    private int id;
    private Date registrationDate;
    private Car8 car;
    private CarReceipt8[] carReceipts;

    public CustomerCar8() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Date getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Date registrationDate) { this.registrationDate = registrationDate; }
    public Car8 getCar() { return car; }
    public void setCar(Car8 car) { this.car = car; }
    public CarReceipt8[] getCarReceipts() { return carReceipts; }
    public void setCarReceipts(CarReceipt8[] carReceipts) { this.carReceipts = carReceipts; }
}
