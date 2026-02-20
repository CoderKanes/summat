<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="sm.data.PostDAO" %>
<%@ page import="sm.data.PostCommentDTO" %>
<%@ page import="sm.data.MemberDAO" %>
<%
int id = Integer.parseInt(request.getParameter("id"));
int type = Integer.parseInt(request.getParameter("type"));

String sid= (String)session.getAttribute("sid");

PostDAO dao = new PostDAO();
int OldlikeType = dao.getLikeType(id, sid);

boolean result;
if(OldlikeType == 0){
	result = dao.insertCommentLike(id, sid, type);
}else if(OldlikeType!= type){
	result = dao.updateCommentLike(id, sid, type);
}else{
	result = dao.deleteCommentLike(id, sid);
}

out.print(result ? "OK" : "DUP");
%>