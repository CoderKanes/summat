<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sm.data.PostDAO"%>
<%
    int postNum = Integer.parseInt(request.getParameter("postNum"));
    String userId = (String)session.getAttribute("sid");
    
    if(userId == null) {
        out.print("{\"result\":\"fail\", \"message\":\"로그인이 필요합니다.\"}");
        return;
    }
	
    PostDAO dao = new PostDAO();
    int res = dao.updateLikeCount(postNum, userId);
    
    if(res == 1) {
        // 성공 시 최신 추천수도 같이 보내주면 JS에서 화면 갱신하기 좋음
        int newCount = dao.getLikeCount(postNum); 
        out.print("{\"result\":\"success\", \"newLikeCount\":" + newCount + "}");
    } else if(res == -1) {
        out.print("{\"result\":\"fail\", \"message\":\"이미 추천한 게시글입니다.\"}");
    } else {
        out.print("{\"result\":\"fail\", \"message\":\"오류가 발생했습니다.\"}");
    }
%>