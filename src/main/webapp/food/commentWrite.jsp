<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="sm.data.FoodCommentDAO" %>
<%@ page import="sm.data.FoodCommentDTO" %>


<%
    // 1. 한글 깨짐 방지
    request.setCharacterEncoding("UTF-8");
    // 2. 파라미터 받기
    String writer = request.getParameter("writer");
    String content = request.getParameter("content");
    String password = request.getParameter("password"); 
    String postIdStr = request.getParameter("postId");
    int boardNum = 0;
    if(postIdStr != null && !postIdStr.equals("")) {
        boardNum = Integer.parseInt(postIdStr);
    } else {
        System.out.println("postId 값이 안 넘어옴");
    }
    
   
    // 3. DTO 객체 생성 및 값 세팅
    FoodCommentDTO dto = new FoodCommentDTO();
    dto.setBoardNum(boardNum);
    dto.setWriter(writer);
    dto.setContent(content);
    dto.setPassword(password);    
    // 4. DAO 객체 생성 후 insert 실행
    FoodCommentDAO dao = new FoodCommentDAO();
    int result = dao.insert(dto);  

    // 5. 처리 후 게시글 상세페이지로 이동
    if(result > 0){
    	System.out.println("이동할 menuId = " + boardNum);
    	response.sendRedirect("foodView.jsp?menuId=" + boardNum); 
    		
    } else {
%>
        <script>
            alert("댓글 작성 실패");
            history.back();
        </script>
<%
    }
%>