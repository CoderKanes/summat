<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="sm.data.InfluencerRequestDAO" %>
<%
request.setCharacterEncoding("UTF-8");

String adminId = (String) session.getAttribute("sid");
Object gradeObj = session.getAttribute("grade");

if (adminId == null || adminId.trim().isEmpty()) {
    response.sendRedirect(request.getContextPath() + "/user/loginForm.jsp");
    return;
}

int grade = -1;
try {
    if (gradeObj instanceof Integer) grade = ((Integer) gradeObj).intValue();
    else if (gradeObj != null) grade = Integer.parseInt(gradeObj.toString());
} catch (Exception e) {
    grade = -1;
}

if (grade != 0) {
    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
    out.println("<h3>권한 없음</h3>");
    return;
}

String idParam = request.getParameter("id");
String adminNote = request.getParameter("adminNote");
if (adminNote == null) adminNote = "";

if (idParam == null || idParam.trim().isEmpty()) {
    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID 누락");
    return;
}

int id = Integer.parseInt(idParam);

InfluencerRequestDAO dao = InfluencerRequestDAO.getInstance();
int result = dao.changeRequestStatusById(id, "APPROVED", adminId, adminNote);

String redirectUrl = request.getHeader("Referer");
if (redirectUrl == null || !redirectUrl.contains("/admin/")) {
    redirectUrl = request.getContextPath() + "/admin/influencerList.jsp";
}

String msg = result > 0 ? "승인 완료" : "처리 실패";
response.sendRedirect("dashboard.jsp");
%>