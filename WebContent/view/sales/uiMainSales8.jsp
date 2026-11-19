<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*" %>
<%
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");
    // Nhan vien do doLogin8.jsp dua vao session; chua dang nhap hoac khong phai ban hang -> ve trang dang nhap
    if (currentEmployee == null || !"Bán hàng".equals(currentEmployee.getPosition())) {
        response.sendRedirect("../auth/uiLogin8.jsp");
        return;
    }
    // Ve trang chu: xoa du lieu cua lan nhan xe truoc
    for (String k : new String[] {"customerList", "selectedCustomer", "customerCarList", "selectedCustomerCar",
            "requestForm", "carReceipt", "serviceList", "serviceDiscounts", "partList", "partDiscounts", "technicianList"}) {
        session.removeAttribute(k);
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trang chủ nhân viên bán hàng</title>
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page">
<h2>GARAMAN - HỆ THỐNG QUẢN LÝ GARA Ô TÔ</h2>
<p style="text-align:center">Nhân viên: <b><%= currentEmployee.getFullName() %></b></p>
<%-- V3: btnReceiveCar goi trang uiCustomerSearch8.jsp --%>
<form action="uiCustomerSearch8.jsp" method="get" style="text-align:center; margin:30px 0">
<input type="submit" name="btnReceiveCar" value="Nhận xe vào sửa" class="btn btn-big">
</form>
</div>
</body>
</html>
