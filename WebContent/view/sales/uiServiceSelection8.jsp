<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ include file="receiveCar8.jspf" %>
<%-- ===== THUỘC TÍNH ẨN (khớp design-class-diagram-2: uiServiceSelection8.jsp) ===== --%>
<%
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");                                             // nhân viên đăng nhập (auth/doLogin8.jsp)
    RequestForm8 requestForm = (RequestForm8) session.getAttribute("requestForm");                                               // phiếu yêu cầu (tạo ở uiCarSelection8.jsp)
    Service8[] serviceList = (Service8[]) session.getAttribute("serviceList");                                                   // kết quả ServiceDAO8.getServices()
    @SuppressWarnings("unchecked")
    Map<Integer, List<Discount8>> serviceDiscounts = (Map<Integer, List<Discount8>>) session.getAttribute("serviceDiscounts");   // khuyến mãi theo mã dịch vụ, gom từ DiscountDAO8.getServiceDiscount()
%>
<%-- ===== XỬ LÝ ===== --%>
<%
    request.setCharacterEncoding("UTF-8");
    if (currentEmployee == null || requestForm == null) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    String msg = null;
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
    // Bo loc: chi hien dich vu da co trong phieu; sap xep theo don gia
    Set<Integer> inForm = new HashSet<Integer>();
    for (ServiceDetail8 d : requestForm.getServiceDetails()) inForm.add(d.getService().getId());
    boolean chkSelectedOnly = request.getParameter("chkSelectedOnly") != null;
    String cboSort = request.getParameter("cboSort");
    if (cboSort == null) cboSort = "";
    if (chkSelectedOnly) shown.removeIf(s -> !inForm.contains(s.getId()));
    if ("asc".equals(cboSort)) shown.sort(Comparator.comparing(Service8::getListedPrice));
    else if ("desc".equals(cboSort)) shown.sort(Comparator.comparing(Service8::getListedPrice).reversed());
    // Ngoai le 35: khong tim thay dich vu
    if (shown.isEmpty() && msg == null && !chkSelectedOnly) msg = "Không tìm thấy dịch vụ phù hợp. Xóa từ khóa để xem toàn bộ danh mục.";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Danh mục dịch vụ</title>
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page">
<h2>DANH MỤC DỊCH VỤ SỬA CHỮA / BẢO DƯỠNG</h2>
<% if (msg != null) { %><p class="msg-error"><%= msg %></p><% } %>
<form action="uiServiceSelection8.jsp" method="post">
<div class="search-row">
Tên dịch vụ: <input type="text" name="txtServiceName" value="<%= esc(txtServiceName) %>">
<input type="submit" name="btnSearch" value="Tìm kiếm" class="btn">
</div>
<div class="search-row">
<label><input type="checkbox" name="chkSelectedOnly" onchange="this.form.submit()" <%= chkSelectedOnly ? "checked" : "" %>> Chỉ hiện đã chọn</label>
&nbsp;&nbsp; Sắp xếp theo đơn giá:
<select name="cboSort" onchange="this.form.submit()">
    <option value="" <%= cboSort.isEmpty() ? "selected" : "" %>>Mặc định</option>
    <option value="asc" <%= "asc".equals(cboSort) ? "selected" : "" %>>Tăng dần</option>
    <option value="desc" <%= "desc".equals(cboSort) ? "selected" : "" %>>Giảm dần</option>
</select>
</div>
<table name="tblServiceList" class="data">
    <tr><th class="center">TT</th><th class="center">Mã</th><th>Tên dịch vụ</th><th class="money">Đơn giá (VNĐ)</th><th>Khuyến mãi</th><th>Mức giảm</th><th>Điều kiện áp dụng</th><th class="center">Chọn</th></tr>
<%  for (int i = 0; i < shown.size(); i++) {
        Service8 s = shown.get(i);
        List<Discount8> ds = serviceDiscounts.get(s.getId());
        int n = (ds == null || ds.isEmpty()) ? 1 : ds.size();   // moi khuyen mai 1 hang con; o cua dich vu gop doc (rowspan) %>
    <tr>
        <td class="center" rowspan="<%= n %>"><%= i + 1 %></td>
        <td class="center" rowspan="<%= n %>"><%= code("DV", s.getId()) %></td>
        <td rowspan="<%= n %>"><%= esc(s.getServiceName()) %></td>
        <td class="money" rowspan="<%= n %>"><%= money(s.getListedPrice()) %></td>
        <%= discountCells(ds == null || ds.isEmpty() ? null : ds.get(0)) %>
        <td class="center" rowspan="<%= n %>"><input type="checkbox" name="selectedService" value="<%= s.getId() %>" <%= inForm.contains(s.getId()) ? "checked" : "" %>></td>
    </tr>
<%      for (int k = 1; k < n; k++) { %>
    <tr><%= discountCells(ds.get(k)) %></tr>
<%      } %>
<%  } %>
</table>
<div class="actions">
<input type="button" name="btnBack" value="Quay lại" class="btn left" onclick="location.href='uiRequestForm8.jsp'">
<input type="submit" name="btnConfirm" value="Xác nhận chọn" class="btn right">
</div>
</form>
</div>
</body>
</html>
