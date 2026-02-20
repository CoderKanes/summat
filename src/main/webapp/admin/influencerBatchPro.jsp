<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Arrays, javax.servlet.http.HttpServletResponse" %>
<%@ page import="sm.data.InfluencerRequestDAO" %>
<%
request.setCharacterEncoding("UTF-8");

// === 1. 관리자 권한 체크 ===
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
    out.println("<h3>관리자만 접근 가능합니다.</h3>");
    out.println("<p><a href='" + request.getContextPath() + "/'>홈으로</a></p>");
    return;
}

// === 2. 파라미터 받기 ===
String action = request.getParameter("action");
String[] selectedIds = request.getParameterValues("selectedIds");
String adminNote = "일괄 처리됨"; // 추후 폼에서 입력받도록 확장 가능

InfluencerRequestDAO dao = InfluencerRequestDAO.getInstance();
int successCount = 0;

try {
    if ("approved_all".equals(action)) {
        // 전체 승인: PENDING 상태인 모든 신청 승인
        successCount = dao.approveAllPending(adminId, adminNote);
        
    } else if ("approved".equals(action) || "rejected".equals(action)) {
        // 선택 승인 또는 선택 반려
        if (selectedIds != null && selectedIds.length > 0) {
            String status = "approved".equals(action) ? "APPROVED" : "REJECTED";
            for (String idStr : selectedIds) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    int result = dao.changeRequestStatusById(id, status, adminId, adminNote);
                    if (result > 0) successCount++;
                } catch (NumberFormatException e) {
                    // 무시 (유효하지 않은 ID)
                }
            }
        }
    } else {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "지원되지 않는 작업입니다.");
        return;
    }

    // 성공 메시지
    String msg = "처리 성공 (" + successCount + "건)";
    if (successCount == 0) msg = "처리할 항목이 없거나 실패했습니다.";

    // Referer로 돌아가기 (필터 유지)
    String referer = request.getHeader("Referer");
    String redirectUrl = request.getContextPath() + "/admin/dashboard.jsp";
    if (referer != null && referer.contains("/admin/dashboard.jsp")) {
        redirectUrl = referer;
    }

    // 메시지 전달
    response.sendRedirect(redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));

} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp?msg=" + java.net.URLEncoder.encode("처리 중 오류 발생", "UTF-8"));
}
%>