<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*, model.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("txtUsername");
    String password = request.getParameter("txtPassword");
    if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
        response.sendRedirect("uiLogin8.jsp?err=empty");
        return;
    }
    Employee8 employee = new EmployeeDAO8().checkLogin(username.trim(), password);
    if (employee == null) {
        response.sendRedirect("uiLogin8.jsp?err=wrong");
        return;
    }
    // Hien chi co module Nhan xe vao sua cho nhan vien ban hang
    if (!"Bán hàng".equals(employee.getPosition())) {
        response.sendRedirect("uiLogin8.jsp?err=role");
        return;
    }
    request.changeSessionId(); // doi ma phien sau khi dang nhap (chong session fixation)
    session.setAttribute("currentEmployee", employee);
    response.sendRedirect("../sales/uiMainSales8.jsp");
%>
