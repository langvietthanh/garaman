<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, dao.*, model.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    SimpleDateFormat hm = new SimpleDateFormat("HH:mm");
    Date selectedDate = (Date) session.getAttribute("selectedDate");
    if (selectedDate == null) {
        response.sendRedirect("uiDateSelection8.jsp");
        return;
    }
    String msg = null;
    // Ngoai le 10 (v.1): khung gio vua co khach khac dat truoc khi xac nhan
    if ("taken".equals(request.getParameter("err"))) {
        msg = "Khung giờ này đã có khách đặt, vui lòng chọn khung giờ khác";
    }

    // V3 buoc 19-20: nut "Chon" o dong nao thi gui khung gio cua dong do, chuyen sang uiCustomerInfo8.jsp
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String slot = request.getParameter("selectedTimeSlot");
        Appointment8[] timeSlots = (Appointment8[]) session.getAttribute("timeSlots");
        boolean isFree = false;
        if (slot != null && timeSlots != null) {
            for (Appointment8 a : timeSlots) {
                if (a.getId() == 0 && hm.format(a.getAppointmentTime()).equals(slot)) isFree = true;
            }
        }
        if (!isFree) {
            msg = "Vui lòng chọn một khung giờ còn trống.";
        } else {
            session.setAttribute("selectedTimeSlot", slot);
            response.sendRedirect("uiCustomerInfo8.jsp");
            return;
        }
    }

    // V3 buoc 12-17: lay cac khung gio con trong
    // khung da co lich hen co id > 0: hien thi nhung khong cho chon
    Appointment8[] timeSlots = new AppointmentDAO8().getAvailableTimeSlots(selectedDate);
    if (timeSlots == null) {
        msg = "Không lấy được khung giờ, vui lòng thử lại sau.";
        timeSlots = new Appointment8[0];
    }
    session.setAttribute("timeSlots", timeSlots);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chọn khung giờ hẹn</title>
</head>
<body>
<h2>Chọn khung giờ hẹn</h2>
<p>Ngày hẹn: <%= new SimpleDateFormat("dd/MM/yyyy").format(selectedDate) %></p>
<% if (msg != null) { %><p style="color:red"><%= msg %></p><% } %>
<% if (timeSlots.length == 0) { %>
<p>Ngày đã chọn không có khung giờ làm việc.</p>
<% } else { %>
<form name="timeSlotSelection" action="uiTimeSlotSelection8.jsp" method="post">
<table name="tblTimeSlotList" border="1" cellpadding="4">
    <tr><th>TT</th><th>Khung giờ</th><th>Trạng thái</th><th>Chọn</th></tr>
<%
    for (int i = 0; i < timeSlots.length; i++) {
        Date at = timeSlots[i].getAppointmentTime();
        String s = hm.format(at);
        String end = hm.format(new Date(at.getTime() + 30 * 60 * 1000L));
        boolean isFree = timeSlots[i].getId() == 0;
%>
    <tr>
        <td><%= i + 1 %></td>
        <td><%= s %> – <%= end %></td>
        <td><%= isFree ? "Còn trống" : "Đã có khách đặt" %></td>
        <td><% if (isFree) { %><button type="submit" name="selectedTimeSlot" value="<%= s %>">Chọn</button><% } else { %>—<% } %></td>
    </tr>
<%  } %>
</table>
<br>
<a href="uiDateSelection8.jsp">Quay lại</a>
</form>
<% } %>
<% if (timeSlots.length == 0) { %><a href="uiDateSelection8.jsp">Quay lại</a><% } %>
</body>
</html>
