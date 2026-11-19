<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="receiveCar8.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");
    RequestForm8 requestForm = (RequestForm8) session.getAttribute("requestForm");
    CarReceipt8 carReceipt = (CarReceipt8) session.getAttribute("carReceipt");
    Customer8 selectedCustomer = (Customer8) session.getAttribute("selectedCustomer");
    CustomerCar8 selectedCustomerCar = (CustomerCar8) session.getAttribute("selectedCustomerCar");
    if (currentEmployee == null || requestForm == null || carReceipt == null || selectedCustomer == null || selectedCustomerCar == null) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    String msg = null;
    if ("stock".equals(request.getParameter("err"))) msg = "Tồn kho phụ tùng không đủ, vui lòng điều chỉnh số lượng.";
    else if ("save".equals(request.getParameter("err"))) msg = "Không lưu được phiếu yêu cầu, vui lòng thử lại.";

    // Thao tac "Xóa" tren tung dong cua 3 bang
    try {
        String del = request.getParameter("delService");
        if (del != null) {
            List<ServiceDetail8> l = new ArrayList<ServiceDetail8>(Arrays.asList(requestForm.getServiceDetails()));
            l.remove(Integer.parseInt(del));
            requestForm.setServiceDetails(l.toArray(new ServiceDetail8[0]));
            requestForm.calculateTotal();
        }
        del = request.getParameter("delPart");
        if (del != null) {
            List<PartDetail8> l = new ArrayList<PartDetail8>(Arrays.asList(requestForm.getPartDetails()));
            l.remove(Integer.parseInt(del));
            requestForm.setPartDetails(l.toArray(new PartDetail8[0]));
            requestForm.calculateTotal();
        }
        del = request.getParameter("delTechnician");
        if (del != null) {
            List<AssignmentDetail8> l = new ArrayList<AssignmentDetail8>(Arrays.asList(requestForm.getAssignmentDetails()));
            l.remove(Integer.parseInt(del));
            requestForm.setAssignmentDetails(l.toArray(new AssignmentDetail8[0]));
        }
    } catch (Exception e) {
        // chi so khong hop le (F5 sau khi xoa) -> bo qua
    }

    if (request.getParameter("txtNotes") != null) {
        carReceipt.setNotes(request.getParameter("txtNotes").trim());
    }
    boolean hasItem = requestForm.getServiceDetails().length + requestForm.getPartDetails().length > 0;
    String go = null;
    if (request.getParameter("btnAddService") != null) go = "uiServiceSelection8.jsp";
    else if (request.getParameter("btnAddPart") != null) go = "uiPartSelection8.jsp";
    else if (request.getParameter("btnAssignTechnician") != null && hasItem) go = "uiTechnicianAssignment8.jsp";
    if (go != null) {
        response.sendRedirect(go);
        return;
    }

    boolean canConfirm = hasItem && requestForm.getAssignmentDetails().length > 0;
    Car8 car = selectedCustomerCar.getCar();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Phiếu yêu cầu</title>
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page">
<h2>PHIẾU YÊU CẦU TIẾP NHẬN SỬA CHỮA</h2>
<div class="info-box">
<b>Mã phiếu: <span name="lblRequestFormCode">PYC-TEMP</span>
 &nbsp;&nbsp; Ngày lập: <span name="lblCreatedAt"><%= new SimpleDateFormat("dd/MM/yyyy").format(requestForm.getCreatedAt()) %></span></b><br>
Khách hàng: <span name="lblCustomerName"><%= esc(selectedCustomer.getFullName()) %></span>
 &nbsp;|&nbsp; SĐT: <span name="lblCustomerPhoneNumber"><%= esc(selectedCustomer.getPhoneNumber()) %></span>
 &nbsp;|&nbsp; Địa chỉ: <span name="lblCustomerAddress"><%= esc(selectedCustomer.getAddress()) %></span><br>
Xe tiếp nhận: <span name="lblLicensePlate"><%= esc(car.getLicensePlate()) %></span>
 (<span name="lblCarBrand"><%= esc(car.getBrand()) %></span> <span name="lblCarModel"><%= esc(car.getVehicleType()) %></span>
 | Màu: <span name="lblCarColor"><%= esc(car.getColor()) %></span>
 | Năm SX: <span name="lblManufacturingYear"><%= car.getManufacturingYear() %></span>)
</div>
<% if (msg != null) { %><p class="msg-error"><%= msg %></p><% } %>

<form action="uiRequestForm8.jsp" method="post">
<h3>1. Dịch vụ yêu cầu:
<input type="submit" name="btnAddService" value="+ Thêm dịch vụ" class="btn right"></h3>
<table name="tblServiceList" class="data">
    <tr><th class="center">TT</th><th class="center">Mã</th><th>Tên dịch vụ</th><th class="money">Đơn giá</th><th class="money">Giảm giá</th><th class="money">Thành tiền</th><th class="center">Thao tác</th></tr>
<%  ServiceDetail8[] sds = requestForm.getServiceDetails();
    for (int i = 0; i < sds.length; i++) { ServiceDetail8 d = sds[i]; %>
    <tr>
        <td class="center"><%= i + 1 %></td>
        <td class="center"><%= code("DV", d.getService().getId()) %></td>
        <td><%= esc(d.getService().getServiceName()) %></td>
        <td class="money"><%= money(d.getService().getListedPrice()) %></td>
        <td class="money"><%= money(d.getDiscountAmount()) %></td>
        <td class="money"><%= money(d.getFinalPrice()) %></td>
        <td class="center"><a href="uiRequestForm8.jsp?delService=<%= i %>" class="btn-small">Xóa</a></td>
    </tr>
<%  } %>
</table>

<h3>2. Phụ tùng yêu cầu:
<input type="submit" name="btnAddPart" value="+ Thêm phụ tùng" class="btn right"></h3>
<table name="tblPartList" class="data">
    <tr><th class="center">TT</th><th class="center">Mã</th><th>Tên phụ tùng</th><th class="center">ĐVT</th><th class="center">SL</th><th class="money">Đơn giá</th><th class="money">Giảm giá</th><th class="money">Thành tiền</th><th class="center">Thao tác</th></tr>
<%  PartDetail8[] pds = requestForm.getPartDetails();
    for (int i = 0; i < pds.length; i++) { PartDetail8 d = pds[i]; PartVariant8 v = d.getPartVariant(); %>
    <tr>
        <td class="center"><%= i + 1 %></td>
        <td class="center"><%= code("PT", v.getId()) %></td>
        <td><%= esc(v.getSparePart().getPartName()) %> - <%= esc(v.getBrand()) %></td>
        <td class="center"><%= esc(v.getSparePart().getUnit()) %></td>
        <td class="center"><%= d.getQuantity() %></td>
        <td class="money"><%= money(v.getListedPrice()) %></td>
        <td class="money"><%= money(d.getDiscountAmount()) %></td>
        <td class="money"><%= money(d.getFinalPrice()) %></td>
        <td class="center"><a href="uiPartSelection8.jsp" class="btn-small edit">Sửa</a> <a href="uiRequestForm8.jsp?delPart=<%= i %>" class="btn-small">Xóa</a></td>
    </tr>
<%  } %>
</table>

<h3>3. Nhân viên kỹ thuật phụ trách:
<input type="submit" name="btnAssignTechnician" value="Phân công kỹ thuật" class="btn right" <%= hasItem ? "" : "disabled" %>></h3>
<table name="tblTechnicianInfo" class="data">
    <tr><th class="center">TT</th><th class="center">Mã NV</th><th>Họ và tên</th><th>Chuyên môn phụ trách</th><th class="center">Thao tác</th></tr>
<%  AssignmentDetail8[] ads = requestForm.getAssignmentDetails();
    for (int i = 0; i < ads.length; i++) { Technician8 t = ads[i].getTechnician(); %>
    <tr>
        <td class="center"><%= i + 1 %></td>
        <td class="center"><%= code("KT", t.getId()) %></td>
        <td><%= esc(t.getFullName()) %></td>
        <td><%= esc(t.getSpecialty()) %></td>
        <td class="center"><a href="uiRequestForm8.jsp?delTechnician=<%= i %>" class="btn-small">Xóa</a></td>
    </tr>
<%  } %>
</table>

<h3>Tình trạng xe bàn giao &amp; Ghi chú khách hàng:</h3>
<textarea name="txtNotes"><%= esc(carReceipt.getNotes()) %></textarea>

<div class="total-box">
<span name="lblTotalListedAmount">Tổng niêm yết: <%= money(requestForm.getTotalListedAmount()) %></span>
 &nbsp;|&nbsp; <span name="lblTotalDiscount">Tổng giảm giá: <%= money(requestForm.getTotalDiscount()) %></span>
 &nbsp;|&nbsp; <span name="lblEstimatedTotal">TỔNG TẠM TÍNH: <%= money(requestForm.getEstimatedTotal()) %></span>
</div>
<div class="actions">
<input type="button" name="btnCancel" value="Hủy bỏ" class="btn left" onclick="if (confirm('Hủy phiếu yêu cầu đang lập?')) location.href='uiMainSales8.jsp'">
<input type="submit" name="btnConfirm" value="Xác nhận" class="btn right" formaction="doSaveRequestForm8.jsp" <%= canConfirm ? "" : "disabled" %>>
</div>
<% if (!canConfirm) { %><p class="hint" style="text-align:right">(Cần ít nhất 1 dịch vụ/phụ tùng và 1 kỹ thuật viên)</p><% } %>
</form>
</div>
</body>
</html>
