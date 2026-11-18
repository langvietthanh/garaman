<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ include file="receiveCar8.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");
    Customer8 selectedCustomer = (Customer8) session.getAttribute("selectedCustomer");
    if (currentEmployee == null || selectedCustomer == null) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    String msg = null;
    // Sequence: uiCarSelection8 -> CustomerCarDAO8.getLinkedCarList()
    CustomerCar8[] customerCarList = new CustomerCarDAO8().getLinkedCarList(selectedCustomer);
    session.setAttribute("customerCarList", customerCarList);

    if (request.getParameter("btnConfirmSelect") != null) {
        String sel = request.getParameter("selectedCustomerCar");
        CustomerCar8 selectedCustomerCar = null;
        if (sel != null) {
            for (CustomerCar8 cc : customerCarList) if (String.valueOf(cc.getId()).equals(sel)) selectedCustomerCar = cc;
        }
        if (selectedCustomerCar == null) {
            msg = "Vui lòng chọn một xe.";
        } else {
            session.setAttribute("selectedCustomerCar", selectedCustomerCar);
            // Khoi tao phieu yeu cau nhap + phieu nhan xe cho uiRequestForm8
            RequestForm8 requestForm = new RequestForm8();
            requestForm.setProcessingStatus("Nháp");
            requestForm.setCreatedAt(new Date());
            requestForm.setEmployee(currentEmployee);
            requestForm.setServiceDetails(new ServiceDetail8[0]);
            requestForm.setPartDetails(new PartDetail8[0]);
            requestForm.setAssignmentDetails(new AssignmentDetail8[0]);
            CarReceipt8 carReceipt = new CarReceipt8();
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
</head>
<body>
<h2>CHỌN XE TIẾP NHẬN CỦA KHÁCH HÀNG</h2>
<p>Khách hàng: <span name="lblCustomerName"><%= esc(selectedCustomer.getFullName()) %></span>
 | SĐT: <span name="lblCustomerPhoneNumber"><%= esc(selectedCustomer.getPhoneNumber()) %></span>
 | Địa chỉ: <span name="lblCustomerAddress"><%= esc(selectedCustomer.getAddress()) %></span></p>
<% if (msg != null) { %><p style="color:red"><%= msg %></p><% } %>
<form action="uiCarSelection8.jsp" method="post">
<% if (customerCarList.length == 0) { %>
<p>Khách hàng chưa có xe liên kết. Vui lòng thêm xe mới.</p>
<% } else { %>
<table name="tblLinkedCarList" border="1" cellpadding="4">
    <tr><th>TT</th><th>Biển số xe</th><th>Hãng xe</th><th>Loại xe</th><th>Màu sắc</th><th>Năm SX</th><th>Chọn</th></tr>
<%  for (int i = 0; i < customerCarList.length; i++) { Car8 car = customerCarList[i].getCar(); %>
    <tr>
        <td><%= i + 1 %></td>
        <td><%= esc(car.getLicensePlate()) %></td>
        <td><%= esc(car.getBrand()) %></td>
        <td><%= esc(car.getVehicleType()) %></td>
        <td><%= esc(car.getColor()) %></td>
        <td><%= car.getManufacturingYear() %></td>
        <td><input type="radio" name="selectedCustomerCar" value="<%= customerCarList[i].getId() %>"></td>
    </tr>
<%  } %>
</table>
<% } %>
<br>
<input type="button" name="btnBack" value="Quay lại" onclick="location.href='uiCustomerSearch8.jsp'">
<input type="button" name="btnAddNewCar" value="+ Thêm xe mới" onclick="location.href='uiAddNewCar8.jsp'">
<% if (customerCarList.length > 0) { %>
<input type="submit" name="btnConfirmSelect" value="Xác nhận chọn">
<% } %>
</form>
</body>
</html>
