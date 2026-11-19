<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, model.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    Appointment8 appointment = (Appointment8) session.getAttribute("appointment");
    String fullName = request.getParameter("txtFullName");

    if (fullName != null) {
        // V3 buoc 24-29: duoc chuyen tu uiCustomerInfo8.jsp -> khoi tao BookingContact8, Appointment8
        Date selectedDate = (Date) session.getAttribute("selectedDate");
        String selectedTimeSlot = (String) session.getAttribute("selectedTimeSlot");
        if (selectedDate == null || selectedTimeSlot == null) {
            response.sendRedirect("uiDateSelection8.jsp");
            return;
        }
        BookingContact8 bookingContact = new BookingContact8(fullName.trim(),
                request.getParameter("txtPhoneNumber").trim());
        Date appointmentTime = new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(
                new SimpleDateFormat("yyyy-MM-dd").format(selectedDate) + " " + selectedTimeSlot);
        appointment = new Appointment8(appointmentTime, "Chờ xác nhận", bookingContact);
        session.setAttribute("appointment", appointment);
    }
    if (appointment == null) {
        response.sendRedirect("uiMainMenu8.jsp");
        return;
    }
    boolean saved = "1".equals(request.getParameter("saved"));
    Date at = appointment.getAppointmentTime();
    String start = new SimpleDateFormat("HH:mm").format(at);
    String end = new SimpleDateFormat("HH:mm").format(new Date(at.getTime() + 30 * 60 * 1000L));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Xác nhận đặt lịch</title>
</head>
<body>
<h2>Xác nhận đặt lịch</h2>
<table>
    <tr><td>Ngày hẹn:</td><td><label name="lblSelectedDate"><%= new SimpleDateFormat("dd/MM/yyyy").format(at) %></label></td></tr>
    <tr><td>Khung giờ:</td><td><label name="lblSelectedTime"><%= start %> – <%= end %></label></td></tr>
    <tr><td>Họ tên:</td><td><label name="lblFullName"><%= appointment.getBookingContact().getFullName().replace("<", "&lt;") %></label></td></tr>
    <tr><td>Số điện thoại:</td><td><label name="lblPhoneNumber"><%= appointment.getBookingContact().getPhoneNumber() %></label></td></tr>
</table>
<br>
<% if (saved) {
       // V3 buoc 40: hien thi thong bao thanh cong; ket thuc phien dat lich
       session.removeAttribute("appointment");
       session.removeAttribute("selectedDate");
       session.removeAttribute("selectedTimeSlot");
       session.removeAttribute("timeSlots");
%>
<div style="border:1px solid #999; padding:6px">
    <b>Thông báo:</b><br>
    <label name="lblSuccessMessage">Đặt lịch thành công, nhân viên sẽ liên hệ xác nhận trong thời gian sớm nhất</label>
</div>
<br>
<a href="uiMainMenu8.jsp">Về trang chủ</a>
<% } else { %>
<% if ("fail".equals(request.getParameter("err"))) { %><p style="color:red">Lưu lịch hẹn không thành công, vui lòng thử lại.</p><% } %>
<%-- V3 buoc 31-32: submit sang trang xu li doSaveBooking8.jsp --%>
<form name="bookingConfirmation" action="doSaveBooking8.jsp" method="post">
    <a href="uiCustomerInfo8.jsp">Quay lại</a>
    <input type="submit" name="btnConfirmBooking" value="Xác nhận đặt lịch">
</form>
<% } %>
</body>
</html>
