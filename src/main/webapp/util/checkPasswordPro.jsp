<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="sm.data.MemberDAO"%>
    
<%--
    작성자 : 김용진
    내용 : (실험용페이지) checkPassword.jsp의 요청으로 비밀번호를 확인만 처리해주는 페이지.
--%>

<%
    String password = request.getParameter("password");
    
    Boolean isAuth = null;
  	if (session != null) {
      	Object authAttr = session.getAttribute("authenticated");
      	isAuth = (authAttr instanceof Boolean) ? (Boolean) authAttr : null;
  	}
  	
  	String sid= (String)session.getAttribute("sid");
  	boolean success = MemberDAO.getInstance().loginCheck(sid, password);
%>

{
  "success": <%= success %>
}
