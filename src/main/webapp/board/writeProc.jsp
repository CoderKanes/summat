<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDAO, sm.data.BoardDTO" %>
<%--
	작성자 : 신동엽
    내용 : 게시글 작성 처리 페이지 (writeProc.jsp)
📌 사용자 기능
1. 게시글 작성 처리
   - write.jsp에서 전달된 제목(title), 작성자(writer), 내용(content), 비밀번호(password) 파라미터 받기
   - BoardDTO 객체에 값 저장
   - BoardDAO.insert(dto) 호출하여 DB에 게시글 저장
   - 저장 완료 후 게시글 목록(list.jsp)로 이동

📌 구현 방법
1. POST 파라미터 처리
   - request.getParameter()로 제목, 작성자, 내용, 비밀번호 받기
2. DTO 객체 사용
   - BoardDTO 생성 후 setter로 데이터 저장
3. DAO 호출
   - BoardDAO.insert(dto) 실행
   - insert() 반환값 확인 가능 (필요 시 result 활용)
4. 페이지 이동 처리
   - response.sendRedirect("list.jsp")로 목록 페이지로 이동
--%>

<%
    // 1️ BoardDTO 객체 생성
    BoardDTO dto = new BoardDTO(); // 게시글 데이터를 담을 DTO 생성

    // 2️ 폼에서 전달된 데이터 DTO에 저장
    dto.setTitle(request.getParameter("title"));      // 제목 저장
    dto.setWriter(request.getParameter("writer"));    // 작성자 저장
    dto.setContent(request.getParameter("content"));  // 내용 저장
    dto.setPassword(request.getParameter("password")); // 비밀번호 저장 (중요!)

    // 3️ DAO 객체 생성 (DB 연결 준비)
    BoardDAO dao = new BoardDAO(); 

    // 4️ insert() 메서드 호출하여 DB에 게시글 저장
    int result = dao.insert(dto); // insert 성공 시 1, 실패 시 0 반환 가능 ■writeProc페이지

    // 5️ 저장 완료 후 목록 페이지로 이동
    response.sendRedirect("list.jsp");
%>