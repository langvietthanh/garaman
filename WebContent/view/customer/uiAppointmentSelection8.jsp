<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, dao.*, model.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    SimpleDateFormat ymd = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat hm = new SimpleDateFormat("HH:mm");
    String msg = null;
    // Ngoai le 10 (v.1): khung gio vua co khach khac dat truoc khi xac nhan
    if ("taken".equals(request.getParameter("err"))) {
        msg = "Khung giờ này đã có khách đặt, vui lòng chọn khung giờ khác";
    }

    // V3 buoc 3-8: lay cac ngay hoat dong
    Date[] availableDates = new WorkScheduleDAO8().getAvailableDates();
    if (availableDates == null) {
        msg = "Không lấy được lịch làm việc, vui lòng thử lại sau.";
        availableDates = new Date[0];
    }
    Set<String> active = new HashSet<String>();
    for (Date d : availableDates) active.add(ymd.format(d));

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String d = request.getParameter("selectedDate");
        String slot = request.getParameter("selectedTimeSlot");
        if (d != null) {
            // V3 buoc 10-11: chon ngay -> nap lai chinh trang nay de hien khung gio cua ngay do
            if (!active.contains(d)) {
                msg = "Vui lòng chọn một ngày gara hoạt động.";
            } else {
                session.setAttribute("selectedDate", ymd.parse(d));
                session.removeAttribute("selectedTimeSlot");
                response.sendRedirect("uiAppointmentSelection8.jsp");
                return;
            }
        } else if (slot != null) {
            // V3 buoc 18-19: chon khung gio con trong -> chuyen sang uiCustomerInfo8.jsp
            Appointment8[] timeSlots = (Appointment8[]) session.getAttribute("timeSlots");
            boolean isFree = false;
            if (timeSlots != null) {
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
    }

    // V3 buoc 11-17: da chon ngay thi lay khung gio cua ngay do; khung da co lich hen co id > 0
    Date selectedDate = (Date) session.getAttribute("selectedDate");
    if (selectedDate != null && !active.contains(ymd.format(selectedDate))) selectedDate = null; // ngay cu da qua
    Appointment8[] timeSlots = null;
    if (selectedDate != null) {
        timeSlots = new AppointmentDAO8().getAvailableTimeSlots(selectedDate);
        if (timeSlots == null) {
            msg = "Không lấy được khung giờ, vui lòng thử lại sau.";
            timeSlots = new Appointment8[0];
        }
        session.setAttribute("timeSlots", timeSlots);
        if (timeSlots.length == 0 && msg == null) msg = "Ngày đã chọn không có khung giờ làm việc.";
    }

    // QD-03: hien 7 ngay tu ngay mai; ngay khong co lich lam viec = Nghi
    String[] thu = {"", "Chủ nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy"};
    SimpleDateFormat dm = new SimpleDateFormat("dd/MM");
    Calendar c = Calendar.getInstance();
    String sel = selectedDate == null ? "" : ymd.format(selectedDate);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chọn ngày giờ hẹn</title>
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page">
<%-- moi thanh phan hien thi mang dung ten thuoc tinh cua uiAppointmentSelection8.jsp o Hinh 4.5 --%>
<div class="steps" id="lblStepBar"><span class="on">1. Chọn thời gian</span><span>2. Thông tin</span><span>3. Xác nhận</span></div>
<h2 id="lblTitle">CHỌN NGÀY GIỜ HẸN</h2>
<% if (msg != null) { %><p class="msg-error" id="lblErrorMessage"><%= msg %></p><% } %>
<form name="appointmentSelection" action="uiAppointmentSelection8.jsp" method="post">
<h3 id="lblDateHeading">Chọn ngày</h3>
<div id="dateList" class="chips days">
<%
    for (int i = 1; i <= 7; i++) {
        c.add(Calendar.DATE, 1);
        Date d = c.getTime();
        String v = ymd.format(d);
        boolean isActive = active.contains(v);
%>
    <button type="submit" name="selectedDate" value="<%= v %>" class="chip<%= v.equals(sel) ? " selected" : "" %>"<%= isActive ? "" : " disabled" %>>
        <small><%= thu[c.get(Calendar.DAY_OF_WEEK)] %></small><b><%= dm.format(d) %></b><small><%= isActive ? "Hoạt động" : "Nghỉ" %></small>
    </button>
<%  } %>
</div>
<% if (selectedDate == null) { %>
<p class="hint" id="lblTimeSlotNote">Chọn một ngày để xem các khung giờ.</p>
<% } else { %>
<%     Calendar cs = Calendar.getInstance(); cs.setTime(selectedDate); %>
<h3 id="lblTimeSlotHeading">Chọn khung giờ – <%= thu[cs.get(Calendar.DAY_OF_WEEK)] %>, <%= new SimpleDateFormat("dd/MM/yyyy").format(selectedDate) %></h3>
<%     if (timeSlots.length > 0) { %>
<div id="timeSlotList" class="chips slots">
<%
        for (Appointment8 a : timeSlots) {
            Date at = a.getAppointmentTime();
            boolean isFree = a.getId() == 0;
%>
    <button type="submit" name="selectedTimeSlot" value="<%= hm.format(at) %>" class="chip"<%= isFree ? "" : " disabled" %>>
        <b><%= hm.format(at) %></b><small><%= isFree ? "đến " + hm.format(new Date(at.getTime() + 60 * 60 * 1000L)) : "Đã đặt" %></small>
    </button>
<%      } %>
</div>
<p class="hint" id="lblTimeSlotNote">Khung giờ hiển thị mờ là khung đã có khách đặt.</p>
<%     } %>
<% } %>
<div class="actions">
<input type="button" name="btnHome" value="Về trang chủ" class="btn left" onclick="location.href='uiMainMenu8.jsp'">
</div>
</form>
</div>
</body>
</html>
