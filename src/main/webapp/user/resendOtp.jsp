<%@page import="java.net.URLEncoder"%>
<%@page import="sm.util.EmailUtil"%>
<%@page import="java.util.Random"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>otp재전송</title>
</head>
<body>
<%
	String email = request.getParameter("email");
	if(email == null){
		response.sendRedirect("verifyEmailForm.jsp");
		return;
	}
	
	//새 opt생성
	String otp = String.format("%06d", new Random().nextInt(1000000));
	session.setAttribute("otp" + email, otp);
	session.setAttribute("otp_expiry_" + email, System.currentTimeMillis() + 10 * 60 * 1000);
	
	// 메일 발송
    try {
        EmailUtil.sendEmail(email, "회원가입 인증코드(재전송)", "인증코드: " + otp + "\n10분 안에 입력해 주세요.");
        session.setAttribute("verifyMsg", "인증코드를 재전송했습니다.");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("verifyMsg", "인증코드 재전송에 실패했습니다.");
    }

    response.sendRedirect("verifyEmail.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
	
%>
</body>
</html>