<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이메일 인증</title>
</head>
<body>
<%
	String email = request.getParameter("email");
	if(email == null){
		email = (String)session.getAttribute("lastSingUpEmail");
	}else{
		session.setAttribute("lastSingUpEmail", email);
	}
%>

	<h2>이메일 인증</h2>
	<p>가입하신 이메일 : <strong><%=email %></strong></p>
	
	<form action="verifyEmailPro.jsp" method="post">
		<input type="hidden" name="email" value="<%=email %>"/>
		<label>
			인증코드 : <input type="text" name="otp" required="required"/>
		</label>
		<button type="submit">인증하기</button>
	</form>
	
	<p>
		인증 코드를 못 받으셨나요?
		<a href="resendOtp.jsp?email=<%= java.net.URLEncoder.encode(email, "UTF-8")%>">재전송</a>
	</p>
	
<%
	String msg = (String)session.getAttribute("verifyMsg");
	if(msg != null){
		out.println("<p style ='color : red;'>" + msg + "</p>");
		session.removeAttribute("verifyMsg");
	}
%>	
</body>
</html>