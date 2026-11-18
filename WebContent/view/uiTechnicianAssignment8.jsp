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
    // Sequence: TechnicianDAO8.getTechnicianList() - ky thuat vien dang ranh
    Technician8[] technicianList = new TechnicianDAO8().getTechnicianList();
    session.setAttribute("technicianList", technicianList);
    Set<Integer> assigned = new HashSet<Integer>();
    for (AssignmentDetail8 a : requestForm.getAssignmentDetails()) assigned.add(a.getTechnician().getId());

    if (request.getParameter("btnConfirmAssignment") != null) {
        String[] sel = request.getParameterValues("selectedTechnician");
        if (sel == null) {
            msg = "Vui lòng chọn ít nhất một kỹ thuật viên.";
        } else {
            List<String> ids = Arrays.asList(sel);
            List<AssignmentDetail8> details = new ArrayList<AssignmentDetail8>();
            for (Technician8 t : technicianList) {
                if (!ids.contains(String.valueOf(t.getId()))) continue;
                AssignmentDetail8 a = new AssignmentDetail8();
                a.setTechnician(t);
                details.add(a);
            }
            requestForm.setAssignmentDetails(details.toArray(new AssignmentDetail8[0]));
            response.sendRedirect("uiRequestForm8.jsp");
            return;
        }
    }
    // Ngoai le 63: khong co ky thuat vien ranh
    if (technicianList.length == 0) msg = "Hiện không có kỹ thuật viên rảnh.";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Phân công kỹ thuật viên</title>
</head>
<body>
<h2>PHÂN CÔNG KỸ THUẬT VIÊN</h2>
<% if (msg != null) { %><p style="color:red"><%= msg %></p><% } %>
<form action="uiTechnicianAssignment8.jsp" method="post">
<% if (technicianList.length > 0) { %>
<table name="tblTechnicianList" border="1" cellpadding="4">
    <tr><th>TT</th><th>Mã NV</th><th>Họ và tên</th><th>Chuyên môn phụ trách</th><th>Chọn</th></tr>
<%  for (int i = 0; i < technicianList.length; i++) { Technician8 t = technicianList[i]; %>
    <tr>
        <td><%= i + 1 %></td>
        <td><%= code("KT", t.getId()) %></td>
        <td><%= esc(t.getFullName()) %></td>
        <td><%= esc(t.getSpecialty()) %></td>
        <td><input type="checkbox" name="selectedTechnician" value="<%= t.getId() %>" <%= assigned.contains(t.getId()) ? "checked" : "" %>></td>
    </tr>
<%  } %>
</table>
<br>
<% } %>
<input type="button" name="btnBack" value="Quay lại" onclick="location.href='uiRequestForm8.jsp'">
<% if (technicianList.length > 0) { %>
<input type="submit" name="btnConfirmAssignment" value="Xác nhận phân công">
<% } %>
</form>
</body>
</html>
