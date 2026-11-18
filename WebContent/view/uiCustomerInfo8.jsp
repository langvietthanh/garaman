<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    if (session.getAttribute("selectedDate") == null || session.getAttribute("selectedTimeSlot") == null) {
        response.sendRedirect("uiDateSelection8.jsp");
        return;
    }
    String fullName = request.getParameter("txtFullName");
    String phoneNumber = request.getParameter("txtPhoneNumber");
    String msg = null;

    // V3 buoc 22-23: nhan du lieu form, chuyen sang uiBookingConfirmation8.jsp kem fullName, phoneNumber
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        fullName = fullName == null ? "" : fullName.trim();
        phoneNumber = phoneNumber == null ? "" : phoneNumber.trim();
        // Ngoai le 8 (v.1): ho ten / so dien thoai trong hoac sai dinh dang
        if (fullName.isEmpty() || fullName.length() > 50) {
            msg = "Họ tên không được để trống và không quá 50 ký tự, vui lòng nhập lại.";
        } else if (!phoneNumber.matches("0\\d{9}")) {
            msg = "Số điện thoại phải gồm 10 chữ số và bắt đầu bằng 0, vui lòng nhập lại.";
        } else {
            request.getRequestDispatcher("uiBookingConfirmation8.jsp").forward(request, response);
            return;
        }
    }
    if (fullName == null) fullName = "";
    if (phoneNumber == null) phoneNumber = "";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thông tin khách hàng</title>
</head>
<body>
<h2>Thông tin khách hàng</h2>
<% if (msg != null) { %><p style="color:red"><%= msg %></p><% } %>
<form name="customerInfo" action="uiCustomerInfo8.jsp" method="post">
<table>
    <tr><td>Họ tên:</td><td><input type="text" name="txtFullName" maxlength="50" value="<%= fullName.replace("\"", "&quot;") %>"></td></tr>
    <tr><td>Số điện thoại:</td><td><input type="text" name="txtPhoneNumber" maxlength="10" value="<%= phoneNumber.replace("\"", "&quot;") %>"></td></tr>
</table>
<br>
<a href="uiTimeSlotSelection8.jsp">Quay lại</a>
<input type="submit" name="btnContinue" value="Tiếp tục">
</form>
</body>
</html>
