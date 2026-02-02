<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
	String user_id="test";

	int postNum =0;
	if(request.getParameter("postNum") !=null){
		postNum = Integer.parseInt(request.getParameter("postNum"));
	}else{
		//잘못된 요청 check postView에서 넘어오기때문에 postNum 반드시 존재함.
	}

%>
    
    <h1> 포스트 삭제</h1>
    
    <h3> 비밀번호 확인</h3>
    
    <form action="postDeletePro.jsp" method = "post">
    	<input type="password" name = "password" />    	
    	
    	<input type="hidden" name = "user_id" value="<%=user_id%>" />
	   	<input type="hidden" name = "postNum" value="<%=postNum%>" />    	
    </form>
    