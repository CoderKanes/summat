<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>logout</title>
</head>
<body>
<%	
	//세션 삭제
	session.invalidate();
	
	response.sendRedirect("/summat/sm/main.jsp");
%>
</body>
</html>