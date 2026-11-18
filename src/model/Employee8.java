package model;

/** Nhan vien, ke thua Member8. position: Quản lý | Bán hàng | Kho | Kỹ thuật. */
public class Employee8 extends Member8 {
    private String position;
    private String workStatus;
    private RequestForm8[] requestForms;

    public Employee8() {
    }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
    public String getWorkStatus() { return workStatus; }
    public void setWorkStatus(String workStatus) { this.workStatus = workStatus; }
    public RequestForm8[] getRequestForms() { return requestForms; }
    public void setRequestForms(RequestForm8[] requestForms) { this.requestForms = requestForms; }
}
