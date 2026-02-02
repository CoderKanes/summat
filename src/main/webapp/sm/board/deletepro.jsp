<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="sm.data.BoardDAO" %>


<%
    // 1️⃣ 글 번호 받기
    String numStr = request.getParameter("num");

    if(numStr != null) {
        int num = Integer.parseInt(numStr);

        // 2️⃣ DAO 실행
        BoardDAO dao = new BoardDAO();
        dao.delete(num); 
    }

    // 3️⃣ 목록으로 이동
    response.sendRedirect("list.jsp");
%>
