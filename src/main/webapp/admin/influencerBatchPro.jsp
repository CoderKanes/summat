<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Arrays, java.util.List, javax.servlet.http.HttpServletResponse" %>
<%@ page import="sm.data.InfluencerRequestDAO" %>
<%@ page import="sm.data.AdminDAO" %> <!-- ✅ 추가 -->
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
String adminNote = "일괄 처리됨";

InfluencerRequestDAO infDao = InfluencerRequestDAO.getInstance();
AdminDAO adminDao = AdminDAO.getInstance(); // ✅ 추가

int successCount = 0;

try {
	if ("APPROVED_ALL".equals(action)) {
        // 🔸 1. 전체 승인: 요청 상태 변경
        int updatedRequests = infDao.approveAllPending(adminId, adminNote);
        
        // 🔸 2. PENDING 사용자 ID 목록 가져오기
        List<String> pendingUserIds = infDao.getAllPendingUserIds();
        
        // 🔸 3. 각 사용자의 grade = 2 로 업데이트
        int updatedGrades = 0;
        for (String user_id : pendingUserIds) {
            if (user_id != null && !user_id.trim().isEmpty()) {
                int result = adminDao.setGrade(user_id, 2);
                if (result > 0) updatedGrades++;
            }
        }
        
        successCount = Math.min(updatedRequests, updatedGrades); // 간단한 성공 추정

    } else if ("APPROVED".equals(action) || "REJECTED".equals(action)) {
        if (selectedIds != null && selectedIds.length > 0) {
        	String status = "APPROVED".equals(action) ? "APPROVED" : "REJECTED";
            for (String idStr : selectedIds) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    
                    // 🔸 1. 요청 상태 업데이트
                    int result1 = infDao.changeRequestStatusById(id, status, adminId, adminNote);
                    
                    // 🔸 2. 승인일 경우만 grade 업데이트
                    int result2 = 0;
                    if ("APPROVED".equals(status)) {
                        String user_id = infDao.getUser_idById(id);
                        if (user_id != null && !user_id.trim().isEmpty()) {
                            result2 = adminDao.setGrade(user_id, 2);
                        }
                    }
                    
                    if (result1 > 0 && ("REJECTED".equals(status) || result2 > 0)) {
                        successCount++;
                    }
                } catch (NumberFormatException e) {
                    // 무시
                }
            }
        }
    } else {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "지원되지 않는 작업입니다.");
        return;
    }

    String msg = "처리 성공 (" + successCount + "건)";
    if (successCount == 0) msg = "처리할 항목이 없거나 실패했습니다.";

    String referer = request.getHeader("Referer");
    String redirectUrl = request.getContextPath() + "/admin/influencerConfirm.jsp";
    if (referer != null && referer.contains("/admin/")) {
        redirectUrl = referer;
    }

    response.sendRedirect(redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));

} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect(request.getContextPath() + "/admin/influencerConfirm.jsp?msg=" + java.net.URLEncoder.encode("처리 중 오류 발생", "UTF-8"));
}
%>