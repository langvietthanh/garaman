package model;

import java.util.Date;

/** Mot ngay lam viec cua gara. openTime, closeTime dang "HH:mm" (QD-19). Khong co status (QD-10). */
public class WorkSchedule8 {
    private int id;
    private Date workDate;
    private String openTime;
    private String closeTime;

    public WorkSchedule8() {
    }

    public WorkSchedule8(int id, Date workDate, String openTime, String closeTime) {
        this.id = id;
        this.workDate = workDate;
        this.openTime = openTime;
        this.closeTime = closeTime;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Date getWorkDate() { return workDate; }
    public void setWorkDate(Date workDate) { this.workDate = workDate; }
    public String getOpenTime() { return openTime; }
    public void setOpenTime(String openTime) { this.openTime = openTime; }
    public String getCloseTime() { return closeTime; }
    public void setCloseTime(String closeTime) { this.closeTime = closeTime; }
}
