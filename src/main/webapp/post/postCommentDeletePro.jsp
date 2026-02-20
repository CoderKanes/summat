<%@ page language="java" contentType="text/plain; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="sm.data.PostDAO" %>
<%@ page import="sm.data.PostCommentDTO" %>
<%@ page import="sm.data.MemberDAO" %>

<%

int id = Integer.parseInt(request.getParameter("id"));
String pw = request.getParameter("pw");

PostDAO dao = new PostDAO();

System.out.println(id+":"+ pw);

// 댓글 정보 조회
PostCommentDTO comment = dao.getPostComment(id);
if (comment == null) {
  out.print("FAIL");
  return;
}

// 로그인 유저
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

out.print(dao.deletePostComment(id) ? "OK" : "FAIL"); 
%>