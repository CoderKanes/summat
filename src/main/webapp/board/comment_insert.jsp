<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.CommentDAO, sm.data.CommentDTO" %>
<%--
    작성자 : 신동엽
    파일명 : comment_insert.jsp
    설명   : 게시글 상세 화면(view.jsp)에서 전달된
             게시글 번호(boardNum), 작성자(writer), 댓글 내용(content)을 받아
             댓글을 DB에 저장한 후
             다시 해당 게시글 상세 화면으로 이동하는 처리 페이지
--%>
<%
	// 1️폼에서 전달된 값 받기
	String boardNumStr = request.getParameter("board_Num");
	String writer = request.getParameter("writer");
	String password = request.getParameter("password");
	String content = request.getParameter("content");
	
	// boardNum 안전하게 변환
	int boardNum = 0;
	if(boardNumStr != null && !boardNumStr.isEmpty()) {
	    try {
	        boardNum = Integer.parseInt(boardNumStr);
	    } catch (NumberFormatException e) {
	        e.printStackTrace();
	        // 변환 실패 시 기본값 0으로 처리하거나 에러 페이지로 이동 가능
	    }
	}
	
	// 2️⃣ 댓글 DTO 생성
	CommentDTO comment = new CommentDTO();
	comment.setBoard_Num(boardNum);
	comment.setWriter(writer);
	comment.setPassword(password); 
	comment.setContent(content);
	
	// 3️⃣ DAO를 통해 댓글 저장
	CommentDAO cdao = new CommentDAO();
	cdao.insertComment(comment);
	
	// 4️⃣ 댓글 작성 후 원래 view.jsp로 돌아가기
	response.sendRedirect("view.jsp?num=" + boardNum);
%>
