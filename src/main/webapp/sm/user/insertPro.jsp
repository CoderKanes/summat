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
	<jsp:useBean class="sm.data.MemberDTO" id="dto"></jsp:useBean>
	<jsp:setProperty property="*" name="dto"/>
	
	
	
<%
	MemberDAO dao = MemberDAO.getInstance();

	dto.setCreated_at(new Timestamp(System.currentTimeMillis()));

	dao.insert(dto);
	
	response.sendRedirect("loginForm.jsp");
%>
</body>
</html>