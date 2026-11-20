<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ include file="receiveCar8.jspf" %>
<%-- ===== THUỘC TÍNH ẨN (khớp design-class-diagram-2: uiPartSelection8.jsp) ===== --%>
<%
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");                                       // nhân viên đăng nhập (auth/doLogin8.jsp)
    RequestForm8 requestForm = (RequestForm8) session.getAttribute("requestForm");                                         // phiếu yêu cầu (tạo ở uiCarSelection8.jsp)
    PartVariant8[] partList = (PartVariant8[]) session.getAttribute("partList");                                           // kết quả PartVariantDAO8.getParts()
    @SuppressWarnings("unchecked")
    Map<Integer, List<Discount8>> partDiscounts = (Map<Integer, List<Discount8>>) session.getAttribute("partDiscounts");   // khuyến mãi theo mã phụ tùng, gom từ DiscountDAO8.getPartDiscount()
%>
<%-- ===== XỬ LÝ ===== --%>
<%
    request.setCharacterEncoding("UTF-8");
    if (currentEmployee == null || requestForm == null) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    String msg = null;
    if (partList == null || request.getParameter("btnSearch") == null && request.getParameter("btnConfirmAdd") == null) {
        // Sequence: PartVariantDAO8.getParts() roi DiscountDAO8.getPartDiscount()
        partList = new PartVariantDAO8().getParts();
        partDiscounts = new HashMap<Integer, List<Discount8>>();
        for (PartDiscountDetail8 pd : new DiscountDAO8().getPartDiscount(partList)) {
            partDiscounts.computeIfAbsent(pd.getPartVariant().getId(), k -> new ArrayList<Discount8>()).add(pd.getDiscount());
        }
        session.setAttribute("partList", partList);
        session.setAttribute("partDiscounts", partDiscounts);
    }
    // So luong dang co tren phieu (de hien san o o SL va cho phep "Sửa")
    Map<Integer, Integer> inForm = new HashMap<Integer, Integer>();
    for (PartDetail8 d : requestForm.getPartDetails()) inForm.put(d.getPartVariant().getId(), d.getQuantity());

    if (request.getParameter("btnConfirmAdd") != null) {
        String[] sel = request.getParameterValues("selectedPart");
        if (sel == null) {
            msg = "Vui lòng chọn ít nhất một phụ tùng.";
        } else {
            List<PartDetail8> details = new ArrayList<PartDetail8>(Arrays.asList(requestForm.getPartDetails()));
            for (String id : sel) {
                PartVariant8 v = null;
                for (PartVariant8 p : partList) if (String.valueOf(p.getId()).equals(id)) v = p;
                if (v == null) continue;
                int qty = 0;
                try { qty = Integer.parseInt(request.getParameter("txtQuantity_" + id).trim()); } catch (Exception e) { }
                String name = v.getSparePart().getPartName() + " - " + v.getBrand();
                if (v.getStockQuantity() <= 0) { // Ngoai le 52a
                    msg = name + " đã hết hàng.";
                    break;
                }
                if (qty <= 0) {
                    msg = "Số lượng của " + name + " phải lớn hơn 0.";
                    break;
                }
                if (qty > v.getStockQuantity()) { // Ngoai le 52b
                    msg = "Số lượng tồn kho không đủ (" + name + " chỉ còn " + v.getStockQuantity() + " sản phẩm).";
                    break;
                }
                for (Iterator<PartDetail8> it = details.iterator(); it.hasNext();) {
                    if (it.next().getPartVariant().getId() == v.getId()) it.remove(); // chon lai = sua so luong
                }
                PartDetail8 d = new PartDetail8();
                d.setPartVariant(v);
                d.setQuantity(qty);
                d.calculatePrice(toArray(partDiscounts.get(v.getId())));
                details.add(d);
            }
            if (msg == null) {
                requestForm.setPartDetails(details.toArray(new PartDetail8[0]));
                requestForm.calculateTotal();
                response.sendRedirect("uiRequestForm8.jsp");
                return;
            }
        }
    }

    String txtPartName = request.getParameter("txtPartName");
    if (txtPartName == null) txtPartName = "";
    List<PartVariant8> shown = new ArrayList<PartVariant8>();
    for (PartVariant8 v : partList) {
        String name = (v.getSparePart().getPartName() + " " + v.getBrand()).toLowerCase();
        if (name.contains(txtPartName.trim().toLowerCase())) shown.add(v);
    }
    // Bo loc: chi hien phu tung da co trong phieu; sap xep theo don gia
    boolean chkSelectedOnly = request.getParameter("chkSelectedOnly") != null;
    String cboSort = request.getParameter("cboSort");
    if (cboSort == null) cboSort = "";
    if (chkSelectedOnly) shown.removeIf(v -> !inForm.containsKey(v.getId()));
    if ("asc".equals(cboSort)) shown.sort(Comparator.comparing(PartVariant8::getListedPrice));
    else if ("desc".equals(cboSort)) shown.sort(Comparator.comparing(PartVariant8::getListedPrice).reversed());
    if (shown.isEmpty() && msg == null && !chkSelectedOnly) msg = "Không tìm thấy phụ tùng phù hợp.";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Danh mục phụ tùng</title>
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page">
<h2>DANH MỤC PHỤ TÙNG THAY THẾ</h2>
<% if (msg != null) { %><p class="msg-error"><%= msg %></p><% } %>
<form action="uiPartSelection8.jsp" method="post">
<div class="search-row">
Tên phụ tùng: <input type="text" name="txtPartName" value="<%= esc(txtPartName) %>">
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
<table name="tblPartList" class="data">
    <tr><th class="center">TT</th><th class="center">Mã</th><th>Tên phụ tùng</th><th class="center">Tồn</th><th class="center">ĐVT</th><th class="money">Đơn giá (VNĐ)</th><th>Khuyến mãi</th><th>Mức giảm</th><th>Điều kiện áp dụng</th><th class="center">SL <span class="required">*</span></th><th class="center">Chọn</th></tr>
<%  for (int i = 0; i < shown.size(); i++) {
        PartVariant8 v = shown.get(i);
        boolean soldOut = v.getStockQuantity() <= 0;
        Integer q = inForm.get(v.getId());
        List<Discount8> ds = partDiscounts.get(v.getId());
        int n = (ds == null || ds.isEmpty()) ? 1 : ds.size();   // moi khuyen mai 1 hang con; o cua phu tung gop doc (rowspan) %>
    <tr>
        <td class="center" rowspan="<%= n %>"><%= i + 1 %></td>
        <td class="center" rowspan="<%= n %>"><%= code("PT", v.getId()) %></td>
        <td rowspan="<%= n %>"><%= esc(v.getSparePart().getPartName()) %> - <%= esc(v.getBrand()) %></td>
        <td class="center" rowspan="<%= n %>"><% if (soldOut) { %><span class="text-red">Hết hàng</span><% } else { %><%= v.getStockQuantity() %><% } %></td>
        <td class="center" rowspan="<%= n %>"><%= esc(v.getSparePart().getUnit()) %></td>
        <td class="money" rowspan="<%= n %>"><%= money(v.getListedPrice()) %></td>
        <%= discountCells(ds == null || ds.isEmpty() ? null : ds.get(0)) %>
        <td class="center" rowspan="<%= n %>"><input type="number" name="txtQuantity_<%= v.getId() %>" min="1" max="<%= v.getStockQuantity() %>"
             value="<%= q == null ? "" : q %>" <%= soldOut ? "disabled" : "" %>></td>
        <td class="center" rowspan="<%= n %>"><input type="checkbox" name="selectedPart" value="<%= v.getId() %>" <%= soldOut ? "disabled" : "" %> <%= q != null ? "checked" : "" %>></td>
    </tr>
<%      for (int k = 1; k < n; k++) { %>
    <tr><%= discountCells(ds.get(k)) %></tr>
<%      } %>
<%  } %>
</table>
<div class="actions">
<input type="button" name="btnBack" value="Quay lại" class="btn left" onclick="location.href='uiRequestForm8.jsp'">
<input type="submit" name="btnConfirmAdd" value="Xác nhận thêm" class="btn right">
</div>
</form>
</div>
</body>
</html>
