<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDAO, sm.data.BoardDTO" %>
<%--
    작성자 : 신동엽
    
 	사용자 기능
	1. 게시글 수정 처리
	- 수정 폼(editForm.jsp)에서 전달된 데이터 처리
	- 수정 성공 시 상세보기(view.jsp) 이동
	- 수정 실패 시 에러 메시지 출력

	 구현 방법
	- POST 파라미터 받기 (request.getParameter)
	- DTO 객체 생성 및 값 세팅
	- DAO.update() 호출
	- 결과값(result) 조건 분기 처리
	- response.sendRedirect() 페이지 이동
--%>

<%
    // 1️ POST로 전달된 글 번호(num) 받기 (문자열 → 정수 변환)
    int num = Integer.parseInt(request.getParameter("num"));

    // 2️ 수정 폼에서 전달된 데이터 받기
    String title = request.getParameter("title");       // 제목
    String writer = request.getParameter("writer");     // 작성자
    String content = request.getParameter("content");   // 내용
    String password = request.getParameter("password"); // 수정 확인용 비밀번호

    // 3️ BoardDTO 객체 생성
    BoardDTO dto = new BoardDTO();

    // 4️ DTO에 수정 데이터 저장
    dto.setNum(num);           // 글 번호 설정
    dto.setTitle(title);       // 제목 설정
    dto.setWriter(writer);     // 작성자 설정
    dto.setContent(content);   // 내용 설정
    dto.setPassword(password); // 비밀번호 설정

    // 5️ DAO 객체 생성 (DB 접근 준비)
    BoardDAO dao = new BoardDAO(); 

    // 6️ update 메서드 호출 (글 번호 기준 수정)
    int result = dao.update(dto);

    // 7️ 수정 결과에 따른 분기 처리
    if(result > 0){
        // ✅ 수정 성공 → 상세보기 페이지로 이동
        response.sendRedirect("view.jsp?num=" + num);
    } else {
        // ❌ 수정 실패 → 비밀번호 오류 또는 수정 실패
        out.println("<h3>글 수정 실패. 비밀번호를 확인하세요.</h3>");
        out.println("<a href='editForm.jsp?id=" + num + "'>수정 페이지로 돌아가기</a>");
    }
%>