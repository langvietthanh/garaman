<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Thong bao loi do doLogin8.jsp tra ve qua tham so err
    String err = request.getParameter("err");
    String msg = null;
    if ("empty".equals(err)) msg = "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.";
    else if ("wrong".equals(err)) msg = "Tên đăng nhập hoặc mật khẩu không đúng.";
    else if ("role".equals(err)) msg = "Tài khoản này không có quyền dùng chức năng bán hàng.";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng nhập nhân viên</title>
<link rel="stylesheet" href="../../css/garaman8.css">
</head>
<body>
<div class="page" style="width:460px; margin-top:80px">
<h2>GARAMAN - ĐĂNG NHẬP</h2>
<% if (msg != null) { %><p class="msg-error"><%= msg %></p><% } %>
<form action="doLogin8.jsp" method="post">
<table class="form">
    <tr><td>Tên đăng nhập <span class="required">*</span>:</td><td><input type="text" name="txtUsername" style="width:240px"></td></tr>
    <tr><td>Mật khẩu <span class="required">*</span>:</td><td><input type="password" name="txtPassword" style="width:240px"></td></tr>
</table>
<div class="actions">
<input type="submit" name="btnLogin" value="Đăng nhập" class="btn right">
</div>
</form>
</div>
</body>
</html>
