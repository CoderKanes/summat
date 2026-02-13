<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>logout</title>
<%--
	작성자 : 김동욱
	내용 : 로그아웃 처리 
 --%>
</head>
<body>
<%	
	//세션 삭제 있음 지워라
	if(session != null){
		session.invalidate();
	}
	
	//쿠키 삭제 모든 항목 동일하게
	Cookie rm = new Cookie("rememberMe", "");
	rm.setPath("/");
	rm.setMaxAge(0);
	rm.setHttpOnly(true);
	rm.setSecure(request.isSecure());
	
	response.addCookie(rm);
	
	Cookie ug = new Cookie("userGrade", "");
	ug.setPath("/");
	ug.setMaxAge(0);
	ug.setHttpOnly(true);
	ug.setSecure(request.isSecure());
	
	response.addCookie(ug);
	
	response.sendRedirect("/summat/main/main.jsp");
%>
</body>
</html>