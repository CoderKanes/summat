<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDAO, sm.data.BoardDTO" %>

<%
        // 전달 받은 값이 여기로 왔다.  title = 00  writer = 00  content = 00 대기중 
		// [ 2 ]
    BoardDTO dto = new BoardDTO();  // 1  객체 생성하고 board  DTO dto(주소) 변수 명에다가  
    dto.setTitle(request.getParameter("title"));  //  2  파라미터로 받은 값을 꺼낸다 > 호출 dto . set dto에 저장할거다 
    dto.setWriter(request.getParameter("writer")); // title = 00  writer = 00  content = 00 대기중  dto. 호출 저장한다
    dto.setContent(request.getParameter("content")); // ㄴ dto. set 여기 내용을 title = 00  writer = 00  content = 00 

    BoardDAO dao = new BoardDAO(); // 위에 선언 되어 있는 객체 생성하고  
    dao.insert(dto);   // DAO에 insert 메서드 있어야 함 
    // ㄴ dao 호출 이 동작 실행 
    
    
    
    response.sendRedirect("list.jsp"); // 다 끝나면 이 페이지로 이동 
%>
