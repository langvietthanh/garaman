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
    PartVariant8[] partList = (PartVariant8[]) session.getAttribute("partList");
    @SuppressWarnings("unchecked")
    Map<Integer, List<Discount8>> partDiscounts = (Map<Integer, List<Discount8>>) session.getAttribute("partDiscounts");
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
    if (shown.isEmpty() && msg == null) msg = "Không tìm thấy phụ tùng phù hợp.";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Danh mục phụ tùng</title>
</head>
<body>
<h2>DANH MỤC PHỤ TÙNG THAY THẾ</h2>
<% if (msg != null) { %><p style="color:red"><%= msg %></p><% } %>
<form action="uiPartSelection8.jsp" method="post">
Tên phụ tùng: <input type="text" name="txtPartName" value="<%= esc(txtPartName) %>">
<input type="submit" name="btnSearch" value="Tìm kiếm">
<br><br>
<table name="tblPartList" border="1" cellpadding="4">
    <tr><th>TT</th><th>Mã</th><th>Tên phụ tùng</th><th>Tồn</th><th>ĐVT</th><th>Đơn giá</th><th>Khuyến mãi áp dụng</th><th>SL</th><th>Chọn</th></tr>
<%  for (int i = 0; i < shown.size(); i++) {
        PartVariant8 v = shown.get(i);
        boolean soldOut = v.getStockQuantity() <= 0;
        Integer q = inForm.get(v.getId()); %>
    <tr>
        <td><%= i + 1 %></td>
        <td><%= code("PT", v.getId()) %></td>
        <td><%= esc(v.getSparePart().getPartName()) %> - <%= esc(v.getBrand()) %></td>
        <td><%= soldOut ? "Hết hàng" : String.valueOf(v.getStockQuantity()) %></td>
        <td><%= esc(v.getSparePart().getUnit()) %></td>
        <td><%= money(v.getListedPrice()) %></td>
        <td><%= esc(discountText(partDiscounts.get(v.getId()))) %></td>
        <td><input type="number" name="txtQuantity_<%= v.getId() %>" min="1" max="<%= v.getStockQuantity() %>" style="width:60px"
             value="<%= q == null ? "" : q %>" <%= soldOut ? "disabled" : "" %>></td>
        <td><input type="checkbox" name="selectedPart" value="<%= v.getId() %>" <%= soldOut ? "disabled" : "" %> <%= q != null ? "checked" : "" %>></td>
    </tr>
<%  } %>
</table>
<br>
<input type="button" name="btnBack" value="Quay lại" onclick="location.href='uiRequestForm8.jsp'">
<input type="submit" name="btnConfirmAdd" value="Xác nhận thêm">
</form>
</body>
</html>
