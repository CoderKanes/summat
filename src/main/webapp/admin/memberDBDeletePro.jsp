<%@page import="sm.data.AdminDAO"%>
<%@page import="sm.data.MemberDAO"%>
<%@page import="sm.data.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>delete</title>
</head>
<body>
<%
	MemberDTO dto = new MemberDTO();
	
	String user_id = request.getParameter("user_id");
	
	dto.setUser_id(user_id);
	
	AdminDAO dao = AdminDAO.getInstance();
	
	int result = dao.deleteUser(user_id);
	
	response.sendRedirect("memberList.jsp");
%>
</body>
</html>