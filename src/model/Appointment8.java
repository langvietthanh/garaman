package model;

import java.util.Date;

/** Lich hen. status chi gom "Chờ xác nhận", "Đã tiếp nhận" (QD-02). */
public class Appointment8 {
    private int id;
    private Date appointmentTime;
    private String status;
    private BookingContact8 bookingContact;
    private WorkSchedule8 workSchedule8;

    public Appointment8() {
    }

    public Appointment8(Date appointmentTime, String status, BookingContact8 bookingContact) {
        this.appointmentTime = appointmentTime;
        this.status = status;
        this.bookingContact = bookingContact;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Date getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(Date appointmentTime) { this.appointmentTime = appointmentTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public BookingContact8 getBookingContact() { return bookingContact; }
    public void setBookingContact(BookingContact8 bookingContact) { this.bookingContact = bookingContact; }
    public WorkSchedule8 getWorkSchedule8() { return workSchedule8; }
    public void setWorkSchedule8(WorkSchedule8 workSchedule8) { this.workSchedule8 = workSchedule8; }
}
