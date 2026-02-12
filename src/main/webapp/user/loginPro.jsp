<%@page import="java.util.UUID"%>
<%@page import="sm.data.MemberDTO"%>
<%@page import="sm.data.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 처리</title>
</head>
<body>
<%
    MemberDTO dto = new MemberDTO();

    String user_id = request.getParameter("user_id");
    String plainPassword = request.getParameter("password"); // 비번 받아서

    if (user_id == null) user_id = "";
    if (plainPassword == null) plainPassword = "";

    dto.setUser_id(user_id);
    dto.setPassword_hash(plainPassword);

    MemberDAO dao = MemberDAO.getInstance();

    // isActiveUser 호출해서 user_status 확인
    boolean isActive = false;
    try {
        isActive = dao.isActiveUser(user_id);
    } catch (Exception e) {
        e.printStackTrace();
        isActive = false;
    }

    // 로그인 체크
    boolean result = false;
    if (isActive) {
        try {
            result = dao.loginCheck(user_id, plainPassword);
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
        }
    } else {
        result = false;
    }

    // 로그인 성공 처리: 세션, grade 조회, 쿠키
    if (result) {
        // 세션 설정
        session.setAttribute("sid", user_id);
        session.setAttribute("authenticated", true);
        session.setMaxInactiveInterval(30 * 60); // 30분

        // grade는 로그인 성공 후 한 번만 조회
        int gradeValue = 1;
        try {
            // DAO의 getUserGrade가 MemberDTO 기반이면 dto.user_id가 이미 설정되어 있으므로 사용
            gradeValue = dao.getUserGrade(dto);
            // DAO에 user_id 기반 메서드가 있으면 그걸 쓰는 게 더 명확함:
            // gradeValue = dao.getUserGradeById(user_id);
        } catch (Exception e) {
            e.printStackTrace();
            gradeValue = 1;
        }
        session.setAttribute("grade", gradeValue);

        // 쿠키 처리 (자동로그인)
        String remember = request.getParameter("rememberMe");
        if ("on".equals(remember) && user_id != null && !user_id.isEmpty()) {
            // 토큰 생성 (주의: 서버에 저장/검증하지 않음)
            String token = user_id + "|" + UUID.randomUUID().toString();

            Cookie rememberCookie = new Cookie("rememberMe", token);
            Cookie gradeCookie = new Cookie("userGrade", String.valueOf(gradeValue));

            rememberCookie.setPath("/");
            gradeCookie.setPath("/");

            rememberCookie.setMaxAge(7 * 24 * 60 * 60);
            gradeCookie.setMaxAge(7 * 24 * 60 * 60);

            rememberCookie.setHttpOnly(true);
            gradeCookie.setHttpOnly(true);

            rememberCookie.setSecure(request.isSecure());
            gradeCookie.setSecure(request.isSecure());

            response.addCookie(rememberCookie);
            response.addCookie(gradeCookie);

            // 권고: 토큰을 DB에 저장/검증하지 않는다면 보안상 취약하니 운용 주의
        }

        // 리다이렉트 (컨텍스트 패스 사용 권장)
        String ctx = request.getContextPath();
        response.sendRedirect(ctx + "/sm/main.jsp");
    } else {
%>
    <script type="text/javascript">
        alert("아이디와 비밀번호를 확인하세요");
        history.go(-1);
    </script>
<%
    }
%>
</body>
</html>