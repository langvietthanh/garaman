<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ include file="receiveCar8.jspf" %>
<%-- ===== THUỘC TÍNH ẨN (khớp design-class-diagram-2: uiAddNewCar8.jsp) ===== --%>
<%
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");     // nhân viên đăng nhập (auth/doLogin8.jsp)
    Customer8 selectedCustomer = (Customer8) session.getAttribute("selectedCustomer");   // khách đã chọn (uiCustomerSearch8 / uiAddNewCustomer8)
    Car8 newCar = null;                                                                  // tạo khi click "Lưu xe mới"
    CustomerCar8 newCustomerCar = null;                                                  // tạo khi click "Lưu xe mới"
%>
<%-- ===== XỬ LÝ ===== --%>
<%
    request.setCharacterEncoding("UTF-8");
    if (currentEmployee == null || selectedCustomer == null) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    String msg = null;
    String txtLicensePlate = request.getParameter("txtLicensePlate");
    String txtBrand = request.getParameter("txtBrand");
    String txtVehicleType = request.getParameter("txtVehicleType");
    String txtColor = request.getParameter("txtColor");
    String txtManufacturingYear = request.getParameter("txtManufacturingYear");

    if (request.getParameter("btnSaveCar") != null) {
        int year = 0;
        try { year = Integer.parseInt(txtManufacturingYear.trim()); } catch (Exception e) { }
        int thisYear = Calendar.getInstance().get(Calendar.YEAR);
        if (txtLicensePlate == null || txtLicensePlate.trim().isEmpty() || txtBrand == null || txtBrand.trim().isEmpty()) {
            msg = "Vui lòng nhập biển số xe và hãng xe.";
        } else if (year < 1950 || year > thisYear) {
            msg = "Năm sản xuất không hợp lệ.";
        } else {
            newCar = new Car8();
            newCar.setLicensePlate(txtLicensePlate.trim().toUpperCase());
            newCar.setBrand(txtBrand.trim());
            newCar.setVehicleType(txtVehicleType == null ? null : txtVehicleType.trim());
            newCar.setColor(txtColor == null ? null : txtColor.trim());
            newCar.setManufacturingYear(year);
            newCustomerCar = new CustomerCar8();
            newCustomerCar.setCar(newCar);
            newCustomerCar.setRegistrationDate(new Date());
            CustomerCarDAO8 customerCarDAO = new CustomerCarDAO8();
            // Ngoai le 14: luu xe (saveCar) roi lien ket voi khach (saveCustomerCar) trong cung giao tac
            boolean ok = false;
            try {
                DAO.con.setAutoCommit(false);
                ok = customerCarDAO.saveCar(newCar) && customerCarDAO.saveCustomerCar(newCustomerCar, selectedCustomer);
                if (ok) DAO.con.commit(); else DAO.con.rollback();
            } catch (Exception e) {
                e.printStackTrace();
                try { DAO.con.rollback(); } catch (Exception ex) { }
            } finally {
                try { DAO.con.setAutoCommit(true); } catch (Exception ex) { }
            }
            if (ok) {
                response.sendRedirect("uiCarSelection8.jsp");
                return;
            }
            msg = "Không lưu được xe (biển số có thể đã tồn tại).";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thêm xe mới</title>
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page">
<h2>THÊM XE MỚI CHO KHÁCH HÀNG</h2>
<p><b>Khách hàng: <span name="lblCustomerName"><%= esc(selectedCustomer.getFullName()) %></span>
 &nbsp;|&nbsp; SĐT: <span name="lblCustomerPhoneNumber"><%= esc(selectedCustomer.getPhoneNumber()) %></span></b></p>
<% if (msg != null) { %><p class="msg-error"><%= msg %></p><% } %>
<form action="uiAddNewCar8.jsp" method="post">
<table class="form">
    <tr><td>Biển số xe <span class="required">*</span>:</td><td><input type="text" name="txtLicensePlate" value="<%= esc(txtLicensePlate) %>"></td></tr>
    <tr><td>Hãng xe <span class="required">*</span>:</td><td><input type="text" name="txtBrand" value="<%= esc(txtBrand) %>"></td></tr>
    <tr><td>Loại xe/Model:</td><td><input type="text" name="txtVehicleType" value="<%= esc(txtVehicleType) %>"></td></tr>
    <tr><td>Màu sắc:</td><td><input type="text" name="txtColor" value="<%= esc(txtColor) %>"></td></tr>
    <tr><td>Năm sản xuất <span class="required">*</span>:</td><td><input type="text" name="txtManufacturingYear" value="<%= esc(txtManufacturingYear) %>"></td></tr>
</table>
<div class="actions">
<input type="button" name="btnCancel" value="Hủy bỏ" class="btn left" onclick="location.href='uiCarSelection8.jsp'">
<input type="submit" name="btnSaveCar" value="Lưu xe mới" class="btn right">
</div>
</form>
</div>
</body>
</html>
