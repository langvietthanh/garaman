package model;

/** Khach hang, ke thua Member8. */
public class Customer8 extends Member8 {
    private CustomerCar8[] customerCars;
    private Invoice8[] invoices;
    private Appointment8[] appointments;

    public Customer8() {
    }

    public CustomerCar8[] getCustomerCars() { return customerCars; }
    public void setCustomerCars(CustomerCar8[] customerCars) { this.customerCars = customerCars; }
    public Invoice8[] getInvoices() { return invoices; }
    public void setInvoices(Invoice8[] invoices) { this.invoices = invoices; }
    public Appointment8[] getAppointments() { return appointments; }
    public void setAppointments(Appointment8[] appointments) { this.appointments = appointments; }
}
