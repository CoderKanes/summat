<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String email = request.getParameter("email");
    if (email == null || email.trim().isEmpty()) {
        Object s = session.getAttribute("lastSignUpEmail");
        email = s != null ? String.valueOf(s) : "";
    } else {
        session.setAttribute("lastSignUpEmail", email);
    }

    String emailEscaped = "";
    if (email != null && !email.isEmpty()) {
        emailEscaped = email.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
                            .replace("\"","&quot;").replace("'","&#39;");
    }

    String msg = (String) session.getAttribute("verifyMsg");
    if (msg != null) {
        out.println("<p style='color:green;'>" + msg.replace("&","&amp;") + "</p>");
        session.removeAttribute("verifyMsg");
    }
%>

<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>이메일 인증</title></head>
<body>
    <h2>이메일 인증</h2>

    <% if (emailEscaped == null || emailEscaped.isEmpty()) { %>
        <p>이메일을 입력하세요:</p>
        <form action="resendOtp.jsp" method="get">
            <input type="email" name="email" placeholder="example@domain.com" required />
            <button type="submit">인증코드 요청</button>
        </form>
    <% } else { %>
        <p>가입하신 이메일: <strong><%= emailEscaped %></strong></p>

        <form action="verifyEmailPro.jsp" method="post">
            <input type="hidden" name="email" value="<%= emailEscaped %>" />
            <label>인증코드: <input type="text" name="otp" required /></label>
            <button type="submit">인증하기</button>
        </form>

        <p>
            인증 코드를 못 받으셨나요?
            <a href="resendOtp.jsp?email=<%= URLEncoder.encode(email, "UTF-8") %>">재전송</a>
        </p>
    <% } %>

    <p><a href="loginForm.jsp">뒤로</a></p>
</body>
</html>