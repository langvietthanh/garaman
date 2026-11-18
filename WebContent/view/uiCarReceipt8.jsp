<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="receiveCar8.jspf" %>
<%
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");
    CarReceipt8 carReceipt = (CarReceipt8) session.getAttribute("carReceipt");
    Customer8 selectedCustomer = (Customer8) session.getAttribute("selectedCustomer");
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
</head>
<body>
<h2>GARAMAN - BIÊN BẢN TIẾP NHẬN XE VÀ BÀN GIAO TÀI SẢN</h2>
<p name="lblSuccessMessage" style="color:green"><b>[✓] Tiếp nhận xe và lưu phiếu yêu cầu thành công!</b></p>
<p>Mã biên bản: <span name="lblReceiptCode"><%= receiptCode %></span>
 | Thời gian: <span name="lblReceiptTime"><%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(carReceipt.getActualReceiptTime()) %></span>
 | Mã phiếu YC: <span name="lblRequestFormCode">PYC-<%= String.format("%03d", requestForm.getId()) %></span></p>
<p>Khách hàng: <span name="lblCustomerName"><%= esc(selectedCustomer.getFullName()) %></span>
 | SĐT: <span name="lblCustomerPhoneNumber"><%= esc(selectedCustomer.getPhoneNumber()) %></span>
 | Địa chỉ: <span name="lblCustomerAddress"><%= esc(selectedCustomer.getAddress()) %></span></p>
<p>Xe tiếp nhận: <span name="lblLicensePlate"><%= esc(car.getLicensePlate()) %></span>
 (Hãng xe: <span name="lblCarBrand"><%= esc(car.getBrand()) %></span>
 | Model: <span name="lblCarModel"><%= esc(car.getVehicleType()) %></span>
 | Màu sắc: <span name="lblCarColor"><%= esc(car.getColor()) %></span>)</p>
<p><b>Tình trạng xe bàn giao &amp; Ghi chú khách hàng:</b><br>
<span name="lblNotes"><%= carReceipt.getNotes() == null || carReceipt.getNotes().isEmpty() ? "(Không có)" : esc(carReceipt.getNotes()).replace("\n", "<br>") %></span></p>
<input type="button" name="btnHome" value="Về trang chủ" onclick="location.href='uiMainSales8.jsp'">
</body>
</html>
