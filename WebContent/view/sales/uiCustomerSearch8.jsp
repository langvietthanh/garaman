<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ include file="receiveCar8.jspf" %>
<%-- ===== THUỘC TÍNH ẨN (khớp design-class-diagram-2: uiCustomerSearch8.jsp) ===== --%>
<%
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");   // nhân viên đăng nhập (auth/doLogin8.jsp)
    Customer8[] customerList = (Customer8[]) session.getAttribute("customerList");     // kết quả CustomerDAO8.searchCustomerByName()
    Customer8 selectedCustomer = null;                                                 // gán khi click "Xác nhận chọn"
%>
<%-- ===== XỬ LÝ ===== --%>
<%
    request.setCharacterEncoding("UTF-8");
    if (currentEmployee == null) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    String msg = null;
    String txtCustomerName = request.getParameter("txtCustomerName");

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
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page">
<h2>TÌM KIẾM THÔNG TIN KHÁCH HÀNG</h2>
<% if (msg != null) { %><p class="msg-error"><%= msg %></p><% } %>
<form action="uiCustomerSearch8.jsp" method="post">
<div class="search-row">
Họ tên KH <span class="required">*</span>: <input type="text" name="txtCustomerName" value="<%= esc(txtCustomerName) %>">
<input type="submit" name="btnSearch" value="Tìm kiếm" class="btn">
<input type="button" name="btnAddNew" value="+ Thêm KH mới" class="btn" onclick="location.href='uiAddNewCustomer8.jsp'">
</div>
<% if (customerList != null && customerList.length > 0) { %>
<table name="tblCustomerList" class="data">
    <tr><th class="center">TT</th><th>Họ và tên</th><th class="center">Số điện thoại</th><th>Địa chỉ</th><th class="center">Chọn</th></tr>
<%  for (int i = 0; i < customerList.length; i++) { Customer8 c = customerList[i]; %>
    <tr>
        <td class="center"><%= i + 1 %></td>
        <td><%= esc(c.getFullName()) %></td>
        <td class="center"><%= esc(c.getPhoneNumber()) %></td>
        <td><%= esc(c.getAddress()) %></td>
        <td class="center"><input type="radio" name="selectedCustomer" value="<%= c.getId() %>"></td>
    </tr>
<%  } %>
</table>
<% } %>
<div class="actions">
<input type="button" name="btnBack" value="Quay lại" class="btn left" onclick="location.href='uiMainSales8.jsp'">
<% if (customerList != null && customerList.length > 0) { %>
<input type="submit" name="btnConfirmSelect" value="Xác nhận chọn" class="btn right">
<% } %>
</div>
</form>
</div>
</body>
</html>
