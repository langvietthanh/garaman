<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ include file="receiveCar8.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");
    if (currentEmployee == null) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    String msg = null;
    String txtCustomerName = request.getParameter("txtCustomerName");
    Customer8[] customerList = (Customer8[]) session.getAttribute("customerList");

    if (request.getParameter("btnSearch") != null) {
        // Ngoai le 6: ho ten khong hop le (rong hoac co chu so/ky tu dac biet)
        if (txtCustomerName == null || !txtCustomerName.trim().matches("[\\p{L} ]+")) {
            msg = "Họ tên không hợp lệ, vui lòng nhập đúng định dạng họ tên.";
            customerList = null;
        } else {
            // Sequence: uiCustomerSearch8 -> CustomerDAO8.searchCustomerByName()
            customerList = new CustomerDAO8().searchCustomerByName(txtCustomerName);
            if (customerList.length == 0) msg = "Không tìm thấy khách hàng. Có thể thêm khách hàng mới.";
        }
        session.setAttribute("customerList", customerList);
    } else if (request.getParameter("btnConfirmSelect") != null) {
        String sel = request.getParameter("selectedCustomer");
        Customer8 selectedCustomer = null;
        if (sel != null && customerList != null) {
            for (Customer8 c : customerList) if (String.valueOf(c.getId()).equals(sel)) selectedCustomer = c;
        }
        if (selectedCustomer == null) {
            msg = "Vui lòng chọn một khách hàng.";
        } else {
            session.setAttribute("selectedCustomer", selectedCustomer);
            response.sendRedirect("uiCarSelection8.jsp");
            return;
        }
    }
    if (txtCustomerName == null) txtCustomerName = "";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tìm kiếm khách hàng</title>
</head>
<body>
<h2>TÌM KIẾM THÔNG TIN KHÁCH HÀNG</h2>
<% if (msg != null) { %><p style="color:red"><%= msg %></p><% } %>
<form action="uiCustomerSearch8.jsp" method="post">
Họ tên KH: <input type="text" name="txtCustomerName" value="<%= esc(txtCustomerName) %>">
<input type="submit" name="btnSearch" value="Tìm kiếm">
<input type="button" name="btnAddNew" value="+ Thêm KH mới" onclick="location.href='uiAddNewCustomer8.jsp'">
<br><br>
<% if (customerList != null && customerList.length > 0) { %>
<table name="tblCustomerList" border="1" cellpadding="4">
    <tr><th>TT</th><th>Họ và tên</th><th>Số điện thoại</th><th>Địa chỉ</th><th>Chọn</th></tr>
<%  for (int i = 0; i < customerList.length; i++) { Customer8 c = customerList[i]; %>
    <tr>
        <td><%= i + 1 %></td>
        <td><%= esc(c.getFullName()) %></td>
        <td><%= esc(c.getPhoneNumber()) %></td>
        <td><%= esc(c.getAddress()) %></td>
        <td><input type="radio" name="selectedCustomer" value="<%= c.getId() %>"></td>
    </tr>
<%  } %>
</table>
<br>
<% } %>
<input type="button" name="btnBack" value="Quay lại" onclick="location.href='uiMainSales8.jsp'">
<% if (customerList != null && customerList.length > 0) { %>
<input type="submit" name="btnConfirmSelect" value="Xác nhận chọn">
<% } %>
</form>
</body>
</html>
