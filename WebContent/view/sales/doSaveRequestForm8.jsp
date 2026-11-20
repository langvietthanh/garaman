<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*, model.*, java.util.*" %>
<%-- ===== THUỘC TÍNH ẨN (khớp design-class-diagram-2: doSaveRequestForm8.jsp) ===== --%>
<%
    Employee8 currentEmployee = (Employee8) session.getAttribute("currentEmployee");   // nhân viên đăng nhập (auth/doLogin8.jsp)
    RequestForm8 requestForm = (RequestForm8) session.getAttribute("requestForm");     // phiếu yêu cầu (tạo ở uiCarSelection8.jsp)
    CarReceipt8 carReceipt = (CarReceipt8) session.getAttribute("carReceipt");         // biên bản nhận xe (tạo ở uiCarSelection8.jsp)
%>
<%-- ===== XỬ LÝ ===== --%>
<%
    request.setCharacterEncoding("UTF-8");
    if (currentEmployee == null || requestForm == null || carReceipt == null || !"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("uiMainSales8.jsp");
        return;
    }
    if (request.getParameter("txtNotes") != null) carReceipt.setNotes(request.getParameter("txtNotes").trim());

    Date now = new Date();
    requestForm.setProcessingStatus("Đang xử lý");
    carReceipt.setActualCreationTime(now);
    carReceipt.setActualReceiptTime(now);

    // Thu tu theo sequence: saveRequestForm -> save*Detail -> updateStockQuantity -> saveCarReceipt,
    // tat ca trong mot giao tac: buoc nao loi thi khong luu gi.
    boolean ok = false;
    boolean stockOk = true;
    try {
        DAO.con.setAutoCommit(false);
        ok = new RequestFormDAO8().saveRequestForm(requestForm)
                && new ServiceDetailDAO8().saveServicesDetail(requestForm.getId(), requestForm.getServiceDetails())
                && new PartDetailDAO8().savePartsDetail(requestForm.getId(), requestForm.getPartDetails())
                && new AssignmentDetailDAO8().saveAssignmentDetail(requestForm.getId(), requestForm.getAssignmentDetails());
        if (ok) {
            stockOk = new PartVariantDAO8().updateStockQuantity(requestForm.getPartDetails());
            ok = stockOk && new CarReceiptDAO8().saveCarReceipt(carReceipt);
        }
        if (ok) DAO.con.commit(); else DAO.con.rollback();
    } catch (Exception e) {
        e.printStackTrace();
        try { DAO.con.rollback(); } catch (Exception ex) { }
        ok = false;
    } finally {
        try { DAO.con.setAutoCommit(true); } catch (Exception ex) { }
    }

    if (ok) {
        response.sendRedirect("uiCarReceipt8.jsp");
    } else {
        requestForm.setId(0);
        carReceipt.setId(0);
        requestForm.setProcessingStatus("Nháp");
        session.removeAttribute("partList"); // ton kho co the da doi -> tai lai khi vao chon phu tung
        response.sendRedirect("uiRequestForm8.jsp?err=" + (stockOk ? "save" : "stock"));
    }
%>
