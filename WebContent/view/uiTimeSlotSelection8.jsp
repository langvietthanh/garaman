<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, dao.*" %>
<%
    request.setCharacterEncoding("UTF-8");
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

    // V3 buoc 19-20: nhan khung gio da chon, chuyen sang uiCustomerInfo8.jsp
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String slot = request.getParameter("selectedTimeSlot");
        String[] timeSlots = (String[]) session.getAttribute("timeSlots");
        if (slot == null || timeSlots == null || !Arrays.asList(timeSlots).contains(slot)) {
            msg = "Vui lòng chọn một khung giờ còn trống.";
        } else {
            session.setAttribute("selectedTimeSlot", slot);
            response.sendRedirect("uiCustomerInfo8.jsp");
            return;
        }
    }

    // V3 buoc 12-17: lay cac khung gio con trong
    String[] timeSlots = new AppointmentDAO8().getAvailableTimeSlots(selectedDate);
    if (timeSlots == null) {
        msg = "Không lấy được khung giờ, vui lòng thử lại sau.";
        timeSlots = new String[0];
    }
    session.setAttribute("timeSlots", timeSlots);

    // QD-03: JSP tu sinh day khung 30 phut tu khung trong dau tien den khung trong cuoi cung;
    // khung khong co trong timeSlots = da co khach dat (khong cho chon)
    List<String> all = new ArrayList<String>();
    if (timeSlots.length > 0) {
        String first = timeSlots[0], last = timeSlots[timeSlots.length - 1];
        int t = Integer.parseInt(first.substring(0, 2)) * 60 + Integer.parseInt(first.substring(3));
        int tLast = Integer.parseInt(last.substring(0, 2)) * 60 + Integer.parseInt(last.substring(3));
        for (; t <= tLast; t += 30) all.add(String.format("%02d:%02d", t / 60, t % 60));
    }
    List<String> free = Arrays.asList(timeSlots);
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
<% if (all.isEmpty()) { %>
<p>Ngày đã chọn không còn khung giờ trống.</p>
<% } else { %>
<form name="timeSlotSelection" action="uiTimeSlotSelection8.jsp" method="post">
<table name="tblTimeSlotList" border="1" cellpadding="4">
    <tr><th>TT</th><th>Khung giờ</th><th>Trạng thái</th><th>Chọn</th></tr>
<%
    for (int i = 0; i < all.size(); i++) {
        String s = all.get(i);
        int t = Integer.parseInt(s.substring(0, 2)) * 60 + Integer.parseInt(s.substring(3)) + 30;
        String end = String.format("%02d:%02d", t / 60, t % 60);
        boolean isFree = free.contains(s);
%>
    <tr>
        <td><%= i + 1 %></td>
        <td><%= s %> – <%= end %></td>
        <td><%= isFree ? "Còn trống" : "Đã có khách đặt" %></td>
        <td><% if (isFree) { %><input type="radio" name="selectedTimeSlot" value="<%= s %>"><% } else { %>—<% } %></td>
    </tr>
<%  } %>
</table>
<br>
<a href="uiDateSelection8.jsp">Quay lại</a>
<input type="submit" name="btnContinue" value="Tiếp tục">
</form>
<% } %>
<% if (all.isEmpty()) { %><a href="uiDateSelection8.jsp">Quay lại</a><% } %>
</body>
</html>
