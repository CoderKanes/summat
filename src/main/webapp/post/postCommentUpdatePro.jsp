<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="sm.data.PostDAO" %>
<%@ page import="sm.data.PostCommentDTO" %>
<%@ page import="sm.data.MemberDAO" %>

<%
request.setCharacterEncoding("UTF-8");

int id = Integer.parseInt(request.getParameter("id"));
String content = request.getParameter("content");
String pw = request.getParameter("pw");

PostDAO dao = new PostDAO();
PostCommentDTO comment = dao.getPostComment(id);

if (comment == null) {
  out.print("FAIL");
  return;
}

// 로그인 사용자
String sid= (String)session.getAttribute("sid");

// ===== 로그인 댓글 =====
if (comment.getUser_Id() != null) {
	if (sid == null || !comment.getUser_Id().equals(sid)) {
		out.print("DENY");
	    return;
	}	
} else {// ===== 비로그인 댓글 =====
	
	if (pw == null || !comment.getGuestPassword().equals(pw)) {
	  out.print("PW_FAIL");
	  return;
	}	
}
out.print(dao.updatePostComment(id, content) ? "OK" : "FAIL"); 
%>