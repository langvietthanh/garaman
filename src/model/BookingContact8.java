package model;

/** Nguoi lien he dat lich. */
public class BookingContact8 {
    private int id;
    private String fullName;
    private String phoneNumber;

    public BookingContact8() {
    }

    public BookingContact8(String fullName, String phoneNumber) {
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
}
