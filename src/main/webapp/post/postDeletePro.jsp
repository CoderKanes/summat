<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:useBean id="dao" class="sm.data.PostDAO" />
<jsp:useBean id="dto" class="sm.data.PostDTO" />
<jsp:setProperty property="*" name="dto" />
	
<h1>post Delete Pro</h1>

<%
	boolean deleteResult = false;

	boolean authenticated = "true".equals(request.getParameter("checkAuthenticated"));

	if(authenticated)
	{	
		if(request.getParameter("postNum") !=null){
			int postNum = Integer.parseInt(request.getParameter("postNum"));
			deleteResult = dao.deletePost(postNum);
		}else{
			//잘못된 요청
		}		
	}else{
		%>
			alert("비밀번호 인증에 실패했습니다.");	
			history.go(-1);
		<%
	}
		
	if(deleteResult == true)
	{
   		//response.sendRedirect("postMain.jsp");
	}else{
		//response.sendRedirect("postView.jsp");
	}
%>