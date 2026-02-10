<%@page import="java.util.Random"%>
<%@page import="sm.util.EmailUtil"%>
<%@page import="sm.util.PasswordUtil"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.MemberDAO" %>
<%@ page import="sm.data.MemberDTO" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insert</title>
</head>
<body>
	
<%
	MemberDTO dto = new MemberDTO();
	MemberDAO dao = MemberDAO.getInstance();
	
	String user_id = request.getParameter("user_id");
	String username = request.getParameter("username");
	String email = request.getParameter("email");
	String phone = request.getParameter("phone");
	String address = request.getParameter("address");
	String resident_registration_number = request.getParameter("resident_registration_number");

	//패스워드 받기
	String plainPassword = request.getParameter("password");
	
	//솔트 생성
	String salt = PasswordUtil.generateSalt();
	
	//out.println("DEBUG: salt = " + salt);
	
	//해시 생성
	String hash = PasswordUtil.passwordHash(plainPassword, salt);
	
	//out.println("DEBUG: hash = " + hash);
	dto.setUser_id(user_id);
	dto.setUsername(username);
	dto.setEmail(email);
	dto.setPhone(phone);
	dto.setAddress(address);
	dto.setResident_registration_number(resident_registration_number);
	
	dto.setPassword_salt(salt);
	
	dto.setPassword_hash(hash);

	dto.setCreated_at(new Timestamp(System.currentTimeMillis()));
	
	dto.setEmail_verified(0);

	dao.insert(dto);
	
	//otp생성
	String otp = String.format("%06d", new Random().nextInt(1000000));
	
	//otp세션에 저장
	session.setAttribute("otp" + email, otp);
	
	session.setAttribute("otp_expiry_" + email, System.currentTimeMillis() + 10 * 60 *1000);
	
	//이메일 발송
	String subject = "회원가입 인증코드";
	String body = "인증코드" + otp + "\n 10분 안에 입력해 주세요";
	
	try{
		EmailUtil.sendEmail(email, subject, body);
	}catch (Exception e){
		e.printStackTrace();
		//사용자 피드백
		session.setAttribute("mailError", "인증고드 발송이 실패하였습니다 다시 시도해주세요");
	}
	//email인코딩으로 보내기
	response.sendRedirect("verifyEmailForm.jsp? email=" + java.net.URLEncoder.encode(email, "UTF-8"));
%>
</body>
</html>