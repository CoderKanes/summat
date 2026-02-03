<%@page import="sm.data.AdminDAO"%>
<%@page import="sm.data.AdminDTO"%>
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
	//파라메터 받기
	String user_id = request.getParameter("user_id");
	String user_status	=	request.getParameter("user_status");
	
	AdminDTO dto = new AdminDTO();
	dto.setUser_id(user_id);
	dto.setUser_status(user_status);
	
	AdminDAO dao = AdminDAO.getInstance();
	boolean res = dao.adminDeactivated(user_id, user_status);
	
	response.sendRedirect("memberList.jsp");
%>
</body>
</html>