<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="receiveCar8.jspf" %>
<%-- ===== THUỘC TÍNH ẨN (khớp design-class-diagram-2: uiCarReceipt8.jsp) ===== --%>
<%
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");     // nhân viên đăng nhập (auth/doLogin8.jsp)
    Customer8 selectedCustomer = (Customer8) session.getAttribute("selectedCustomer");   // khách đã chọn (uiCustomerSearch8 / uiAddNewCustomer8)
    CarReceipt8 carReceipt = (CarReceipt8) session.getAttribute("carReceipt");           // biên bản nhận xe (tạo ở uiCarSelection8.jsp)
%>
<%-- ===== XỬ LÝ ===== --%>
<%
    if (currentEmployee == null || carReceipt == null || carReceipt.getId() == 0 || selectedCustomer == null) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    RequestForm8 requestForm = carReceipt.getRequestForm();
    Car8 car = carReceipt.getCustomerCar().getCar();
    String receiptCode = "BNX-" + new SimpleDateFormat("yyyyMMdd").format(carReceipt.getActualCreationTime())
            + "-" + String.format("%03d", carReceipt.getId());
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Phiếu nhận xe</title>
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page">
<h2>GARAMAN - BIÊN BẢN TIẾP NHẬN XE</h2>
<div name="lblSuccessMessage" class="success-box">[✓] Tiếp nhận xe và lưu phiếu yêu cầu thành công!</div>
<div class="info-box">
<b>Mã biên bản: <span name="lblReceiptCode"><%= receiptCode %></span>
 &nbsp;&nbsp; Thời gian: <span name="lblReceiptTime"><%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(carReceipt.getActualReceiptTime()) %></span>
 &nbsp;&nbsp; Mã phiếu YC: <span name="lblRequestFormCode">PYC-<%= String.format("%03d", requestForm.getId()) %></span></b><br>
Khách hàng: <span name="lblCustomerName"><%= esc(selectedCustomer.getFullName()) %></span>
 &nbsp;|&nbsp; SĐT: <span name="lblCustomerPhoneNumber"><%= esc(selectedCustomer.getPhoneNumber()) %></span>
 &nbsp;|&nbsp; Địa chỉ: <span name="lblCustomerAddress"><%= esc(selectedCustomer.getAddress()) %></span><br>
Xe tiếp nhận: <span name="lblLicensePlate"><%= esc(car.getLicensePlate()) %></span>
 (Hãng xe: <span name="lblCarBrand"><%= esc(car.getBrand()) %></span>
 | Model: <span name="lblCarModel"><%= esc(car.getVehicleType()) %></span>
 | Màu sắc: <span name="lblCarColor"><%= esc(car.getColor()) %></span>)
</div>
<h3>Tình trạng xe bàn giao &amp; Ghi chú khách hàng:</h3>
<div class="info-box" style="background-color:white">
<span name="lblNotes"><%= carReceipt.getNotes() == null || carReceipt.getNotes().isEmpty() ? "(Không có)" : esc(carReceipt.getNotes()).replace("\n", "<br>") %></span>
</div>
<div class="actions">
<input type="button" name="btnHome" value="Về trang chủ" class="btn left" onclick="location.href='uiMainSales8.jsp'">
</div>
</div>
</body>
</html>
