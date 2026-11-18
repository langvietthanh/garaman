<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*, model.*" %>
<%
    Appointment8 appointment = (Appointment8) session.getAttribute("appointment");
    if (appointment == null || !"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("uiMainMenu8.jsp");
        return;
    }
    BookingContactDAO8 bookingContactDAO = new BookingContactDAO8();
    AppointmentDAO8 appointmentDAO = new AppointmentDAO8();

    // QD-20: luu nguoi lien he truoc (V3 buoc 33-35), lich hen sau (V3 buoc 36-38).
    // Hai lan luu trong cung mot giao tac: lich hen khong luu duoc thi khong de lai nguoi lien he thua.
    boolean ok = false;
    try {
        DAO.con.setAutoCommit(false);
        ok = bookingContactDAO.saveBookingContact(appointment.getBookingContact())
                && appointmentDAO.saveAppointment(appointment);
        if (ok) DAO.con.commit(); else DAO.con.rollback();
    } catch (Exception e) {
        e.printStackTrace();
        try { DAO.con.rollback(); } catch (Exception ex) { }
        ok = false;
    } finally {
        try { DAO.con.setAutoCommit(true); } catch (Exception ex) { }
    }

    if (ok) {
        // V3 buoc 39: tro ve uiBookingConfirmation8.jsp de hien thong bao thanh cong
        response.sendRedirect("uiBookingConfirmation8.jsp?saved=1");
    } else {
        appointment.getBookingContact().setId(0);
        // Ngoai le 10 (v.1): khung gio vua bi dat -> quay lai chon khung gio
        response.sendRedirect("uiTimeSlotSelection8.jsp?err=taken");
    }
%>
