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

	dao.insert(dto);
	
	response.sendRedirect("loginForm.jsp");
%>
</body>
</html>