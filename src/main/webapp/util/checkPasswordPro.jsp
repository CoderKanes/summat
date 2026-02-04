<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%--
    작성자 : 김용진
    내용 : (실험용페이지) checkPassword.jsp의 요청으로 비밀번호를 확인만 처리해주는 페이지.
--%>

<%
    String password = request.getParameter("password");
    boolean success = "1234".equals(password);
%>

{
  "success": <%= success %>
}
