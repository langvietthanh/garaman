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
</head>
<body>
<h2>PHIẾU YÊU CẦU TIẾP NHẬN SỬA CHỮA</h2>
<p>Mã phiếu: <span name="lblRequestFormCode">PYC-TEMP</span>
 | Ngày lập: <span name="lblCreatedAt"><%= new SimpleDateFormat("dd/MM/yyyy").format(requestForm.getCreatedAt()) %></span></p>
<p>Khách hàng: <span name="lblCustomerName"><%= esc(selectedCustomer.getFullName()) %></span>
 | SĐT: <span name="lblCustomerPhoneNumber"><%= esc(selectedCustomer.getPhoneNumber()) %></span>
 | Địa chỉ: <span name="lblCustomerAddress"><%= esc(selectedCustomer.getAddress()) %></span></p>
<p>Xe tiếp nhận: <span name="lblLicensePlate"><%= esc(car.getLicensePlate()) %></span>
 (<span name="lblCarBrand"><%= esc(car.getBrand()) %></span> <span name="lblCarModel"><%= esc(car.getVehicleType()) %></span>
 | Màu: <span name="lblCarColor"><%= esc(car.getColor()) %></span>
 | Năm SX: <span name="lblManufacturingYear"><%= car.getManufacturingYear() %></span>)</p>
<% if (msg != null) { %><p style="color:red"><%= msg %></p><% } %>

<form action="uiRequestForm8.jsp" method="post">
<h3>1. Danh sách Dịch vụ yêu cầu: <input type="submit" name="btnAddService" value="+ Thêm dịch vụ"></h3>
<table name="tblServiceList" border="1" cellpadding="4">
    <tr><th>TT</th><th>Mã</th><th>Tên dịch vụ</th><th>Đơn giá (VNĐ)</th><th>Giảm giá</th><th>Thành tiền</th><th>Ghi chú khuyến mãi</th><th>Thao tác</th></tr>
<%  ServiceDetail8[] sds = requestForm.getServiceDetails();
    for (int i = 0; i < sds.length; i++) { ServiceDetail8 d = sds[i]; %>
    <tr>
        <td><%= i + 1 %></td>
        <td><%= code("DV", d.getService().getId()) %></td>
        <td><%= esc(d.getService().getServiceName()) %></td>
        <td><%= money(d.getService().getListedPrice()) %></td>
        <td><%= money(d.getDiscountAmount()) %></td>
        <td><%= money(d.getFinalPrice()) %></td>
        <td><%= d.getDiscountNote() == null ? "" : esc(d.getDiscountNote()) %></td>
        <td><a href="uiRequestForm8.jsp?delService=<%= i %>">Xóa</a></td>
    </tr>
<%  } %>
</table>

<h3>2. Danh sách Phụ tùng yêu cầu: <input type="submit" name="btnAddPart" value="+ Thêm phụ tùng"></h3>
<table name="tblPartList" border="1" cellpadding="4">
    <tr><th>TT</th><th>Mã</th><th>Tên phụ tùng</th><th>ĐVT</th><th>SL</th><th>Đơn giá</th><th>Giảm giá</th><th>Thành tiền</th><th>Ghi chú KM</th><th>Thao tác</th></tr>
<%  PartDetail8[] pds = requestForm.getPartDetails();
    for (int i = 0; i < pds.length; i++) { PartDetail8 d = pds[i]; PartVariant8 v = d.getPartVariant(); %>
    <tr>
        <td><%= i + 1 %></td>
        <td><%= code("PT", v.getId()) %></td>
        <td><%= esc(v.getSparePart().getPartName()) %> - <%= esc(v.getBrand()) %></td>
        <td><%= esc(v.getSparePart().getUnit()) %></td>
        <td><%= d.getQuantity() %></td>
        <td><%= money(v.getListedPrice()) %></td>
        <td><%= money(d.getDiscountAmount()) %></td>
        <td><%= money(d.getFinalPrice()) %></td>
        <td><%= d.getDiscountNote() == null ? "" : esc(d.getDiscountNote()) %></td>
        <td><a href="uiPartSelection8.jsp">Sửa</a> | <a href="uiRequestForm8.jsp?delPart=<%= i %>">Xóa</a></td>
    </tr>
<%  } %>
</table>

<h3>3. Nhân viên kỹ thuật phụ trách: <input type="submit" name="btnAssignTechnician" value="Phân công kỹ thuật" <%= hasItem ? "" : "disabled" %>></h3>
<table name="tblTechnicianInfo" border="1" cellpadding="4">
    <tr><th>TT</th><th>Mã NV</th><th>Họ và tên</th><th>Chuyên môn phụ trách</th><th>Thao tác</th></tr>
<%  AssignmentDetail8[] ads = requestForm.getAssignmentDetails();
    for (int i = 0; i < ads.length; i++) { Technician8 t = ads[i].getTechnician(); %>
    <tr>
        <td><%= i + 1 %></td>
        <td><%= code("KT", t.getId()) %></td>
        <td><%= esc(t.getFullName()) %></td>
        <td><%= esc(t.getSpecialty()) %></td>
        <td><a href="uiRequestForm8.jsp?delTechnician=<%= i %>">Xóa</a></td>
    </tr>
<%  } %>
</table>

<h3>Tình trạng xe bàn giao &amp; Ghi chú khách hàng:</h3>
<textarea name="txtNotes" rows="3" cols="80"><%= esc(carReceipt.getNotes()) %></textarea>

<p><span name="lblTotalListedAmount">Tổng niêm yết: <%= money(requestForm.getTotalListedAmount()) %> đ</span>
 | <span name="lblTotalDiscount">Tổng giảm giá: <%= money(requestForm.getTotalDiscount()) %> đ</span>
 | <b name="lblEstimatedTotal">TỔNG TẠM TÍNH: <%= money(requestForm.getEstimatedTotal()) %> đ</b></p>
<input type="button" name="btnCancel" value="Hủy bỏ" onclick="if (confirm('Hủy phiếu yêu cầu đang lập?')) location.href='uiMainSales8.jsp'">
<input type="submit" name="btnConfirm" value="Xác nhận" formaction="doSaveRequestForm8.jsp" <%= canConfirm ? "" : "disabled" %>>
<% if (!canConfirm) { %><small>(Cần ít nhất 1 dịch vụ/phụ tùng và 1 kỹ thuật viên)</small><% } %>
</form>
</body>
</html>
