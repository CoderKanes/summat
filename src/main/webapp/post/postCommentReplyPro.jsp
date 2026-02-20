<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="sm.data.PostDAO"%>
<%@ page import="sm.data.PostCommentDTO"%>
<%@ page import="sm.data.MemberDTO"%>

<%

int postNum = Integer.parseInt(request.getParameter("postNum"));
int parentId = Integer.parseInt(request.getParameter("parentId"));
String content = request.getParameter("content");

Boolean isAuth = null;
if (session != null) {
  	Object authAttr = session.getAttribute("authenticated");
  	isAuth = (authAttr instanceof Boolean) ? (Boolean) authAttr : null;
}
String sid= (String)session.getAttribute("sid");
String guestName = request.getParameter("guestName");
String guestPassword = request.getParameter("guestPassword");

if (content == null || content.trim().isEmpty()) {
  out.print("FAIL");
  return;
}

PostCommentDTO dto = new PostCommentDTO();
dto.setPostNum(postNum);
dto.setContent(content);
dto.setReplyTarget(parentId);  

if (isAuth != null && sid != null) {
  dto.setUser_Id(sid);
} else {
  dto.setGuestName(guestName);
  dto.setGuestPassword(guestPassword);
}

PostDAO dao = new PostDAO();
boolean result = dao.insertComment(dto);

out.print(result ? "OK" : "FAIL");
%>