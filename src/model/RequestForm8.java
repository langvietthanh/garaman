package model;

import java.util.Date;

/** Phieu yeu cau. processingStatus: Nháp | Đang xử lý. employee: bo sung cho FK tblEmployee8id (can them vao class diagram). */
public class RequestForm8 {
    private int id;
    private String processingStatus;
    private float estimatedTotal;
    private Date createdAt;
    private String notes;
    private float totalDiscount;
    private float totalListedAmount;
    private ServiceDetail8[] serviceDetails;
    private PartDetail8[] partDetails;
    private AssignmentDetail8[] assignmentDetails;
    private Invoice8 invoice;
    private Employee8 employee;

    public RequestForm8() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getProcessingStatus() { return processingStatus; }
    public void setProcessingStatus(String processingStatus) { this.processingStatus = processingStatus; }
    public float getEstimatedTotal() { return estimatedTotal; }
    public void setEstimatedTotal(float estimatedTotal) { this.estimatedTotal = estimatedTotal; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public float getTotalDiscount() { return totalDiscount; }
    public void setTotalDiscount(float totalDiscount) { this.totalDiscount = totalDiscount; }
    public float getTotalListedAmount() { return totalListedAmount; }
    public void setTotalListedAmount(float totalListedAmount) { this.totalListedAmount = totalListedAmount; }
    public ServiceDetail8[] getServiceDetails() { return serviceDetails; }
    public void setServiceDetails(ServiceDetail8[] serviceDetails) { this.serviceDetails = serviceDetails; }
    public PartDetail8[] getPartDetails() { return partDetails; }
    public void setPartDetails(PartDetail8[] partDetails) { this.partDetails = partDetails; }
    public AssignmentDetail8[] getAssignmentDetails() { return assignmentDetails; }
    public void setAssignmentDetails(AssignmentDetail8[] assignmentDetails) { this.assignmentDetails = assignmentDetails; }
    public Invoice8 getInvoice() { return invoice; }
    public void setInvoice(Invoice8 invoice) { this.invoice = invoice; }
    public Employee8 getEmployee() { return employee; }
    public void setEmployee(Employee8 employee) { this.employee = employee; }

    /** Tinh lai tong niem yet, tong giam gia va tong tam tinh tu cac dong chi tiet. */
    public void calculateTotal() {
        float listed = 0, disc = 0;
        if (serviceDetails != null) {
            for (ServiceDetail8 d : serviceDetails) { listed += d.getTotalPrice(); disc += d.getDiscountAmount(); }
        }
        if (partDetails != null) {
            for (PartDetail8 d : partDetails) { listed += d.getTotalPrice(); disc += d.getDiscountAmount(); }
        }
        totalListedAmount = listed;
        totalDiscount = disc;
        estimatedTotal = listed - disc;
    }
}
