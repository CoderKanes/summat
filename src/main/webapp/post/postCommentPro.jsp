<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.net.URLEncoder"%>   
<%@ page import="sm.data.PostDAO"%>
<%@ page import="sm.data.PostCommentDTO"%>

<%
	request.setCharacterEncoding("UTF-8");
	
	int postNum = Integer.parseInt(request.getParameter("postNum"));
	String content = request.getParameter("content");
	String user_id = request.getParameter("user_id");
	String guestName = request.getParameter("guestName");
	String guestPassword = request.getParameter("guestPassword");
	
	if(content != null && !content.trim().isEmpty()){
	    PostDAO dao = new PostDAO();
	    
	    PostCommentDTO dto = new PostCommentDTO();
		dto.setPostNum(postNum);				
		dto.setUser_Id(user_id);
		dto.setGuestName(guestName); 
		dto.setGuestPassword(guestPassword);
		dto.setContent(content);	
		//dto.setReplyTarget(rs.getInt("replytarget"));	
	    dao.insertComment(dto);
	}
	
	String returnUrl = request.getParameter("returnUrl");

	if(returnUrl != null && !returnUrl.isEmpty()){
	    response.sendRedirect(returnUrl);
	} else {
	    response.sendRedirect("post.jsp?postNum=" + postNum);
	}
	return;
%>