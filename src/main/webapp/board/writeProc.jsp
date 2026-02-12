<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDAO, sm.data.BoardDTO" %>
<%--
	작성자 : 신동엽
	내용 : 게시글 작성 처리 페이지
	       - write.jsp에서 전달된 제목(title), 작성자(writer), 내용(content)을 파라미터로 받음
	       - BoardDTO 객체에 값을 저장
	       - BoardDAO의 insert() 메서드를 호출하여 게시글을 DB에 저장
	       - 저장 완료 후 게시글 목록 페이지(list.jsp)로 이동
 --%>
<%
    BoardDTO dto = new BoardDTO();
    dto.setTitle(request.getParameter("title"));    // 제목
    dto.setWriter(request.getParameter("writer"));  // 작성자
    dto.setContent(request.getParameter("content"));// 내용
    // dto.setId(Integer.parseInt(request.getParameter("id"))); 나중에 할 일
    BoardDAO dao = new BoardDAO();
    int result = dao.insert(dto);
    response.sendRedirect("list.jsp");
		
    %>
 