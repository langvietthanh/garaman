<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, dao.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    SimpleDateFormat ymd = new SimpleDateFormat("yyyy-MM-dd");
    String msg = null;

    // V3 buoc 10-11: nut "Chon" o dong nao thi gui ngay cua dong do, chuyen sang uiTimeSlotSelection8.jsp
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String d = request.getParameter("selectedDate");
        if (d == null || d.isEmpty()) {
            msg = "Vui lòng chọn một ngày hẹn.";
        } else {
            Date selectedDate = ymd.parse(d);
            session.setAttribute("selectedDate", selectedDate);
            response.sendRedirect("uiTimeSlotSelection8.jsp");
            return;
        }
    }

    // V3 buoc 3-8: lay cac ngay hoat dong
    Date[] availableDates = new WorkScheduleDAO8().getAvailableDates();
    if (availableDates == null) {
        msg = "Không lấy được lịch làm việc, vui lòng thử lại sau.";
        availableDates = new Date[0];
    }
    Set<String> active = new HashSet<String>();
    for (Date d : availableDates) active.add(ymd.format(d));

    // QD-03: JSP tu sinh 7 ngay tu ngay mai, ngay khong co trong danh sach = Nghi
    String[] thu = {"", "Chủ nhật", "Hai", "Ba", "Tư", "Năm", "Sáu", "Bảy"};
    SimpleDateFormat dmy = new SimpleDateFormat("dd/MM/yyyy");
    Calendar c = Calendar.getInstance();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chọn ngày hẹn</title>
</head>
<body>
<h2>Chọn ngày hẹn</h2>
<% if (msg != null) { %><p style="color:red"><%= msg %></p><% } %>
<form name="dateSelection" action="uiDateSelection8.jsp" method="post">
<table name="tblDateList" border="1" cellpadding="4">
    <tr><th>TT</th><th>Ngày</th><th>Thứ</th><th>Trạng thái</th><th>Chọn</th></tr>
<%
    for (int i = 1; i <= 7; i++) {
        c.add(Calendar.DATE, 1);
        Date d = c.getTime();
        boolean isActive = active.contains(ymd.format(d));
%>
    <tr>
        <td><%= i %></td>
        <td><%= dmy.format(d) %></td>
        <td><%= thu[c.get(Calendar.DAY_OF_WEEK)] %></td>
        <td><%= isActive ? "Hoạt động" : "Nghỉ" %></td>
        <td><% if (isActive) { %><button type="submit" name="selectedDate" value="<%= ymd.format(d) %>">Chọn</button><% } else { %>—<% } %></td>
    </tr>
<%  } %>
</table>
<br>
<a href="uiMainMenu8.jsp">Về trang chủ</a>
</form>
</body>
</html>
