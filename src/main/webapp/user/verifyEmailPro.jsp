<%@page import="sm.data.MemberDAO"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이메일 인증 처리</title>
</head>
<body>
<%
	String email = request.getParameter("email");
	String otp = request.getParameter("otp");
	
	if(email == null || otp == null){
		session.setAttribute("verifyMsg", "잘못된 요청입니다");
		response.sendRedirect("verifyEmailForm.jsp");
		return;
	}
	
	String sessOtp = (String)session.getAttribute("otp" + email);
	Long expiry = (Long)session.getAttribute("otp_expiry_" + email);
	
	if(sessOtp == null || expiry == null){
		session.setAttribute("vertfyMsg", "인증코드가 없습니다. 다시 발송하세요");
		response.sendRedirect("verifyEmail.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
        return;
	}
	
	if(!sessOtp.equals(otp)){
		session.setAttribute("verifyMsg", "인증코드가 일치하지 않습니다");
		response.sendRedirect("verifyEmail.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
        return;
	}
	
	 MemberDAO dao = MemberDAO.getInstance();
	    try {
	        dao.verifyEmailByEmail(email);
	    } catch (Exception e) {
	        e.printStackTrace();
	        session.setAttribute("verifyMsg", "인증 처리 중 오류가 발생했습니다. 관리자에게 문의하세요.");
	        response.sendRedirect("verifyEmail.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
	        return;
	    }

	    // 세션에서 otp 제거
	    session.removeAttribute("otp_" + email);
	    session.removeAttribute("otp_expiry_" + email);

	    session.setAttribute("verifyMsg", "이메일 인증이 완료되었습니다. 로그인 해주세요.");
	    response.sendRedirect("loginForm.jsp");
	
%>
</body>
</html>