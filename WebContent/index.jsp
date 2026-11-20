<%-- Trang mac dinh khi mo http://localhost:8080/GaraMan/ (welcome-file trong WEB-INF/web.xml):
     chuyen thang toi trang dang nhap nhan vien ban hang. Dung redirect (khong forward) de duong dan tuong doi
     trong uiLogin8.jsp (../../css, doLogin8.jsp) van dung. Muon vao module 1 (khach hang): view/customer/uiMainMenu8.jsp --%>
<% response.sendRedirect(request.getContextPath() + "/view/auth/uiLogin8.jsp"); %>
