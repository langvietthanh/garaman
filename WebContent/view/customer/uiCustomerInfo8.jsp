<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    if (session.getAttribute("selectedDate") == null || session.getAttribute("selectedTimeSlot") == null) {
        response.sendRedirect("uiAppointmentSelection8.jsp");
        return;
    }
    String fullName = request.getParameter("txtFullName");
    String phoneNumber = request.getParameter("txtPhoneNumber");
    String msg = null;

    // V3 buoc 21-22: nhan du lieu form, chuyen sang uiBookingConfirmation8.jsp kem fullName, phoneNumber
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
<title>Thông tin người đặt lịch</title>
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page">
<div class="steps" id="lblStepBar"><span class="done">1. Chọn thời gian</span><span class="on">2. Thông tin</span><span>3. Xác nhận</span></div>
<h2 id="lblTitle">THÔNG TIN NGƯỜI ĐẶT LỊCH</h2>
<% if (msg != null) { %><p class="msg-error" id="lblErrorMessage"><%= msg %></p><% } %>
<form name="customerInfo" action="uiCustomerInfo8.jsp" method="post">
<table class="form">
    <tr><td>Họ tên <span class="required">*</span>:</td><td><input type="text" name="txtFullName" maxlength="50" placeholder="VD: Nguyễn Văn A" autocomplete="name" value="<%= fullName.replace("\"", "&quot;") %>"></td></tr>
    <tr><td>Số điện thoại <span class="required">*</span>:</td><td><input type="text" name="txtPhoneNumber" maxlength="10" placeholder="VD: 0912345678" inputmode="numeric" autocomplete="tel" value="<%= phoneNumber.replace("\"", "&quot;") %>"></td></tr>
</table>
<p class="hint" id="lblRequiredNote">Các trường có dấu <span class="required">*</span> là bắt buộc.</p>
<div class="actions">
<input type="button" name="btnBack" value="Quay lại" class="btn left" onclick="location.href='uiAppointmentSelection8.jsp'">
<input type="submit" name="btnContinue" value="Tiếp tục" class="btn right">
</div>
</form>
</div>
</body>
</html>
