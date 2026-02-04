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
	
	response.sendRedirect("/summat/sm/main.jsp");
%>
</body>
</html>