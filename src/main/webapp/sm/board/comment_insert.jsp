<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
%>
    
    
<%@ page import="sm.data.CommentDAO, sm.data.CommentDTO" %>
<%
    // 1️⃣ 폼에서 전달된 값 받기
    String boardNumStr = request.getParameter("boardNum");
    String writer = request.getParameter("writer");
    String content = request.getParameter("content");

    int boardNum = 0;
    if(boardNumStr != null) {
        boardNum = Integer.parseInt(boardNumStr);
    }

    // 2️⃣ 댓글 저장
    CommentDTO comment = new CommentDTO();
    comment.setBoardNum(boardNum);
    comment.setWriter(writer);
    comment.setContent(content);

    CommentDAO cdao = new CommentDAO();
    cdao.insertComment(comment);

    // 3️⃣ 댓글 작성 후 원래 view.jsp로 돌아가기
    response.sendRedirect("view.jsp?num=" + boardNum);
%>
