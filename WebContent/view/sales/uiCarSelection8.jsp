<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ include file="receiveCar8.jspf" %>
<%-- ===== THUỘC TÍNH ẨN (khớp design-class-diagram-2: uiCarSelection8.jsp) ===== --%>
<%
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");     // nhân viên đăng nhập (auth/doLogin8.jsp)
    Customer8 selectedCustomer = (Customer8) session.getAttribute("selectedCustomer");   // khách đã chọn (uiCustomerSearch8 / uiAddNewCustomer8)
    CustomerCar8[] customerCarList = null;                                               // kết quả CustomerCarDAO8.getLinkedCarList()
    CustomerCar8 selectedCustomerCar = null;                                             // gán khi click "Xác nhận chọn"
    RequestForm8 requestForm = null;                                                     // tạo khi click "Xác nhận chọn"
    CarReceipt8 carReceipt = null;                                                       // tạo khi click "Xác nhận chọn"
%>
<%-- ===== XỬ LÝ ===== --%>
<%
    request.setCharacterEncoding("UTF-8");
    if (currentEmployee == null || selectedCustomer == null) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    String msg = null;
    // Sequence: uiCarSelection8 -> CustomerCarDAO8.getLinkedCarList()
    customerCarList = new CustomerCarDAO8().getLinkedCarList(selectedCustomer);
    session.setAttribute("customerCarList", customerCarList);

    if (request.getParameter("btnConfirmSelect") != null) {
        String sel = request.getParameter("selectedCustomerCar");
        if (sel != null) {
            for (CustomerCar8 cc : customerCarList) if (String.valueOf(cc.getId()).equals(sel)) selectedCustomerCar = cc;
        }
        if (selectedCustomerCar == null) {
            msg = "Vui lòng chọn một xe.";
        } else {
            session.setAttribute("selectedCustomerCar", selectedCustomerCar);
            // Khoi tao phieu yeu cau nhap + phieu nhan xe cho uiRequestForm8
            requestForm = new RequestForm8();
            requestForm.setProcessingStatus("Nháp");
            requestForm.setCreatedAt(new Date());
            requestForm.setEmployee(currentEmployee);
            requestForm.setServiceDetails(new ServiceDetail8[0]);
            requestForm.setPartDetails(new PartDetail8[0]);
            requestForm.setAssignmentDetails(new AssignmentDetail8[0]);
            carReceipt = new CarReceipt8();
            carReceipt.setCustomerCar(selectedCustomerCar);
            carReceipt.setRequestForm(requestForm);
            session.setAttribute("requestForm", requestForm);
            session.setAttribute("carReceipt", carReceipt);
            response.sendRedirect("uiRequestForm8.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chọn xe tiếp nhận</title>
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page">
<h2>CHỌN XE TIẾP NHẬN CỦA KHÁCH HÀNG</h2>
<div class="info-box">
Khách hàng: <b><span name="lblCustomerName"><%= esc(selectedCustomer.getFullName()) %></span></b>
 &nbsp;|&nbsp; SĐT: <span name="lblCustomerPhoneNumber"><%= esc(selectedCustomer.getPhoneNumber()) %></span>
 &nbsp;|&nbsp; Địa chỉ: <span name="lblCustomerAddress"><%= esc(selectedCustomer.getAddress()) %></span>
</div>
<% if (msg != null) { %><p class="msg-error"><%= msg %></p><% } %>
<form action="uiCarSelection8.jsp" method="post">
<h3>Danh sách xe đã liên kết:
<input type="button" name="btnAddNewCar" value="+ Thêm xe mới" class="btn right" onclick="location.href='uiAddNewCar8.jsp'"></h3>
<% if (customerCarList.length == 0) { %>
<p class="hint">Khách hàng chưa có xe liên kết. Vui lòng thêm xe mới.</p>
<% } else { %>
<table name="tblLinkedCarList" class="data">
    <tr><th class="center">TT</th><th>Biển số xe</th><th>Hãng xe</th><th>Loại xe</th><th>Màu sắc</th><th class="center">Năm SX</th><th class="center">Chọn</th></tr>
<%  for (int i = 0; i < customerCarList.length; i++) { Car8 car = customerCarList[i].getCar(); %>
    <tr>
        <td class="center"><%= i + 1 %></td>
        <td><%= esc(car.getLicensePlate()) %></td>
        <td><%= esc(car.getBrand()) %></td>
        <td><%= esc(car.getVehicleType()) %></td>
        <td><%= esc(car.getColor()) %></td>
        <td class="center"><%= car.getManufacturingYear() %></td>
        <td class="center"><input type="radio" name="selectedCustomerCar" value="<%= customerCarList[i].getId() %>"></td>
    </tr>
<%  } %>
</table>
<% } %>
<div class="actions">
<input type="button" name="btnBack" value="Quay lại" class="btn left" onclick="location.href='uiCustomerSearch8.jsp'">
<% if (customerCarList.length > 0) { %>
<input type="submit" name="btnConfirmSelect" value="Xác nhận chọn" class="btn right">
<% } %>
</div>
</form>
</div>
</body>
</html>
