<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%--
    작성자 : 김용진
    내용 : Post작성 요청을 처리하는 페이지
--%>

<jsp:useBean id="dao" class="sm.data.PostDAO" />
<jsp:useBean id="dto" class="sm.data.PostDTO" />
<jsp:setProperty property="*" name="dto" />
	
<h1>post write Pro</h1>

<%
    // DB 저장
    dao.insertPost(dto);

    response.sendRedirect("postMain.jsp");
	
%>