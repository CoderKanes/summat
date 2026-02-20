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
    InfluencerRequestDTO dto = new InfluencerRequestDTO();
    InfluencerRequestDAO dao = InfluencerRequestDAO.getInstance();

    // 세션에서 grade 안전하게 가져오기
    int grade = 0;
    Object gradeObj = session.getAttribute("grade");
    if (gradeObj != null) {
        try {
            if (gradeObj instanceof Number) {
                grade = ((Number) gradeObj).intValue();
            } else {
                grade = Integer.parseInt(gradeObj.toString());
            }
        } catch (Exception e) {
            grade = 0; // 파싱 실패 시 기본 0
        }
    }

    if (grade == 0) {
        // grade 0이면 즉시 관리자 확인 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/admin/influencerConfirm.jsp");
        return;
    }

    // grade != 0이면 신청 처리(승인 대기)
    String user_id = request.getParameter("user_id");
    String reason = request.getParameter("reason");
    String sns_urls = request.getParameter("sns_urls");

    dto.setUser_id(user_id);
    dto.setRequested_grade(grade); // 세션 grade 사용
    dto.setReason(reason);
    dto.setSns_urls(sns_urls);

    dao.influencerRequestInsert(dto);

%>
<!-- 승인 대기 메시지(원하면 별도 JSP로 리다이렉트) -->
<p>신청이 정상적으로 접수되어 승인 대기중입니다.</p>
<p><a href="/summat/main/main.jsp">홈으로</a></p>
</body>
</html>