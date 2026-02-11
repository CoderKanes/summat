<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDAO" %>
<%@ page import="sm.data.BoardDTO" %>
<%--
	작성자 : 신동엽
	내용 : 게시글 삭제 처리 페이지
	       - 목록 또는 상세보기에서 전달된 글 번호(num)를 파라미터로 받음
	       - BoardDAO를 통해 해당 게시글 삭제 처리
	       - 삭제 완료 후 게시글 목록 페이지(list.jsp)로 이동
 --%>
<%
    // 1️⃣ 글 번호 받기
    String numStr = request.getParameter("num");

    if(numStr != null) {
        int num = Integer.parseInt(numStr);

        // 2️⃣ DAO 실행
        BoardDAO dao = new BoardDAO();
        dao.deleteBoard(num);
    } 

    // 3️⃣ 목록으로 이동
    response.sendRedirect("list.jsp");
%>
