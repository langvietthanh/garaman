<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ include file="receiveCar8.jspf" %>
<%-- ===== THUỘC TÍNH ẨN (khớp design-class-diagram-2: uiAddNewCustomer8.jsp) ===== --%>
<%
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");   // nhân viên đăng nhập (auth/doLogin8.jsp)
    Customer8 newCustomer = null;                                                      // tạo khi click "Lưu khách hàng"
%>
<%-- ===== XỬ LÝ ===== --%>
<%
    request.setCharacterEncoding("UTF-8");
    if (currentEmployee == null) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    String msg = null;
    String txtFullName = request.getParameter("txtFullName");
    String txtPhoneNumber = request.getParameter("txtPhoneNumber");
    String txtAddress = request.getParameter("txtAddress");

    if (request.getParameter("btnSaveCustomer") != null) {
        if (txtFullName == null || !txtFullName.trim().matches("[\\p{L} ]+")) {
            msg = "Họ tên không hợp lệ.";
        } else if (txtPhoneNumber == null || !txtPhoneNumber.trim().matches("0\\d{9}")) {
            msg = "Số điện thoại phải gồm 10 chữ số, bắt đầu bằng 0.";
        } else {
            newCustomer = new Customer8();
            newCustomer.setFullName(txtFullName.trim());
            newCustomer.setPhoneNumber(txtPhoneNumber.trim());
            newCustomer.setAddress(txtAddress == null ? null : txtAddress.trim());
            // Ngoai le 7: luu khach hang moi -> CustomerDAO8.saveCustomer(), sang chon xe
            if (new CustomerDAO8().saveCustomer(newCustomer)) {
                session.setAttribute("selectedCustomer", newCustomer);
                response.sendRedirect("uiCarSelection8.jsp");
                return;
            }
            msg = "Không lưu được khách hàng (số điện thoại có thể đã được dùng).";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thêm khách hàng mới</title>
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page">
<h2>THÊM KHÁCH HÀNG MỚI</h2>
<% if (msg != null) { %><p class="msg-error"><%= msg %></p><% } %>
<form action="uiAddNewCustomer8.jsp" method="post">
<table class="form">
    <tr><td>Họ và tên <span class="required">*</span>:</td><td><input type="text" name="txtFullName" value="<%= esc(txtFullName) %>"></td></tr>
    <tr><td>Số điện thoại <span class="required">*</span>:</td><td><input type="text" name="txtPhoneNumber" value="<%= esc(txtPhoneNumber) %>"></td></tr>
    <tr><td>Địa chỉ:</td><td><input type="text" name="txtAddress" value="<%= esc(txtAddress) %>"></td></tr>
</table>
<div class="actions">
<input type="button" name="btnCancel" value="Hủy bỏ" class="btn left" onclick="location.href='uiCustomerSearch8.jsp'">
<input type="submit" name="btnSaveCustomer" value="Lưu khách hàng" class="btn right">
</div>
</form>
</div>
</body>
</html>
