<%@page import="sm.data.InfluencerRequestDAO"%>
<%@page import="sm.data.InfluencerRequestDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>influencerUpgradePro</title>
</head>
<body>
<%
    // 세션에서 grade 가져오기 (권한 체크용)
    int sessionGrade = 0;
    Object gradeObj = session.getAttribute("grade");
    if (gradeObj != null) {
        try {
            if (gradeObj instanceof Number) {
                sessionGrade = ((Number) gradeObj).intValue();
            } else {
                sessionGrade = Integer.parseInt(gradeObj.toString());
            }
        } catch (Exception e) {
            sessionGrade = 0;
        }
    }

    // 관리자(grade=0)면 즉시 리다이렉트 — 이건 네 의도니까 유지
    if (sessionGrade == 0) {
        response.sendRedirect(request.getContextPath() + "/admin/influencerConfirm.jsp");
        return;
    }

    // 폼에서 전달된 requested_grade 사용 (파라미터 "grade")
    int requested_grade = 1; // 기본값: 인플루언서 등급
    String gradeParam = request.getParameter("grade");
    if (gradeParam != null && !gradeParam.trim().isEmpty()) {
        try {
            requested_grade = Integer.parseInt(gradeParam.trim());
        } catch (NumberFormatException e) {
            requested_grade = 1; // 숫자 아닐 땐 기본값
        }
    }

    String user_id = request.getParameter("user_id");
    String reason = request.getParameter("reason");
    String sns_urls = request.getParameter("sns_urls");

    // 필수 값 체크 (선택 사항, 안정성 위해 추가)
    if (user_id == null || user_id.trim().isEmpty() || 
        reason == null || reason.trim().isEmpty()) {
%>
        <p style="color:red;">필수 정보가 누락되었습니다.</p>
        <a href="javascript:history.back()">뒤로 가기</a>
<%
        return;
    }

    InfluencerRequestDTO dto = new InfluencerRequestDTO();
    dto.setUser_id(user_id.trim());
    dto.setRequested_grade(requested_grade); // ← 폼에서 받은 grade 사용
    dto.setReason(reason.trim());
    dto.setSns_urls(sns_urls == null ? "" : sns_urls.trim());

    InfluencerRequestDAO dao = InfluencerRequestDAO.getInstance();
    dao.influencerRequestInsert(dto);
%>

<p>신청이 정상적으로 접수되어 승인 대기중입니다.</p>
<p><a href="/summat/main/main.jsp">홈으로</a></p>

</body>
</html>