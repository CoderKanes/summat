<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:useBean id="dao" class="sm.data.PostDAO" />
<jsp:useBean id="dto" class="sm.data.PostDTO" />
<jsp:setProperty property="*" name="dto" />

<h1>post modify Pro</h1>

<%
	
	
	int postNum =0;
	if(request.getParameter("postNum") !=null){
		postNum = Integer.parseInt(request.getParameter("postNum"));
	}else{
		//잘못된 요청
		%>
		<h2>request postnum is null %></h2>
		<%		
	}		
	
	%>
	<h2> postNum : <%=postNum %> , dto.pnum : <%=dto.getPostNum() %></h2>
	<%		
	


	boolean modifyResult =dao.updatePost(dto);
	%>
	<h2> 수정결과 : <%=modifyResult %></h2>
	<%		
	

    response.sendRedirect("postView.jsp?postNum="+postNum);	
%>