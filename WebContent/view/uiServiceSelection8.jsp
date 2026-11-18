<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ include file="receiveCar8.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    RequestForm8 requestForm = (RequestForm8) session.getAttribute("requestForm");
    if (session.getAttribute("currentEmployee") == null || requestForm == null) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    String msg = null;
    Service8[] serviceList = (Service8[]) session.getAttribute("serviceList");
    @SuppressWarnings("unchecked")
    Map<Integer, List<Discount8>> serviceDiscounts = (Map<Integer, List<Discount8>>) session.getAttribute("serviceDiscounts");
    if (serviceList == null || request.getParameter("btnSearch") == null && request.getParameter("btnConfirm") == null) {
        // Sequence: ServiceDAO8.getServices() roi DiscountDAO8.getServiceDiscount()
        serviceList = new ServiceDAO8().getServices();
        serviceDiscounts = new HashMap<Integer, List<Discount8>>();
        for (ServiceDiscountDetail8 sd : new DiscountDAO8().getServiceDiscount(serviceList)) {
            serviceDiscounts.computeIfAbsent(sd.getService().getId(), k -> new ArrayList<Discount8>()).add(sd.getDiscount());
        }
        session.setAttribute("serviceList", serviceList);
        session.setAttribute("serviceDiscounts", serviceDiscounts);
    }

    if (request.getParameter("btnConfirm") != null) {
        String[] sel = request.getParameterValues("selectedService");
        if (sel == null) {
            msg = "Vui lòng chọn ít nhất một dịch vụ.";
        } else {
            List<ServiceDetail8> details = new ArrayList<ServiceDetail8>(Arrays.asList(requestForm.getServiceDetails()));
            for (String id : sel) {
                for (Service8 s : serviceList) {
                    if (!String.valueOf(s.getId()).equals(id)) continue;
                    boolean exists = false;
                    for (ServiceDetail8 d : details) if (d.getService().getId() == s.getId()) exists = true;
                    if (exists) continue; // dich vu da co trong phieu
                    ServiceDetail8 d = new ServiceDetail8();
                    d.setService(s);
                    d.setQuantity(1);
                    d.calculatePrice(toArray(serviceDiscounts.get(s.getId())));
                    details.add(d);
                }
            }
            requestForm.setServiceDetails(details.toArray(new ServiceDetail8[0]));
            requestForm.calculateTotal();
            response.sendRedirect("uiRequestForm8.jsp");
            return;
        }
    }

    // Tim theo ten tren danh muc da lay
    String txtServiceName = request.getParameter("txtServiceName");
    if (txtServiceName == null) txtServiceName = "";
    List<Service8> shown = new ArrayList<Service8>();
    for (Service8 s : serviceList) {
        if (s.getServiceName().toLowerCase().contains(txtServiceName.trim().toLowerCase())) shown.add(s);
    }
    // Ngoai le 35: khong tim thay dich vu
    if (shown.isEmpty()) msg = "Không tìm thấy dịch vụ phù hợp. Xóa từ khóa để xem toàn bộ danh mục.";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Danh mục dịch vụ</title>
</head>
<body>
<h2>DANH MỤC DỊCH VỤ SỬA CHỮA / BẢO DƯỠNG</h2>
<% if (msg != null) { %><p style="color:red"><%= msg %></p><% } %>
<form action="uiServiceSelection8.jsp" method="post">
Tên dịch vụ: <input type="text" name="txtServiceName" value="<%= esc(txtServiceName) %>">
<input type="submit" name="btnSearch" value="Tìm kiếm">
<br><br>
<table name="tblServiceList" border="1" cellpadding="4">
    <tr><th>TT</th><th>Mã</th><th>Tên dịch vụ</th><th>Đơn giá (VNĐ)</th><th>Khuyến mãi / Điều kiện áp dụng</th><th>Chọn</th></tr>
<%  for (int i = 0; i < shown.size(); i++) { Service8 s = shown.get(i); %>
    <tr>
        <td><%= i + 1 %></td>
        <td><%= code("DV", s.getId()) %></td>
        <td><%= esc(s.getServiceName()) %></td>
        <td><%= money(s.getListedPrice()) %></td>
        <td><%= esc(discountText(serviceDiscounts.get(s.getId()))) %></td>
        <td><input type="checkbox" name="selectedService" value="<%= s.getId() %>"></td>
    </tr>
<%  } %>
</table>
<br>
<input type="button" name="btnBack" value="Quay lại" onclick="location.href='uiRequestForm8.jsp'">
<input type="submit" name="btnConfirm" value="Xác nhận chọn">
</form>
</body>
</html>
