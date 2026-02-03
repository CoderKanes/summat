<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDAO"%> 

<%
    String numStr = request.getParameter("num");
    int num = 0;
    if(numStr != null) {
        num = Integer.parseInt(numStr);
    }

    BoardDAO dao = new BoardDAO();
    dao.deleteBoardAndComments(num); // 댓글 + 게시글 삭제
%>

<script>
    alert("게시글이 삭제되었습니다.");
    location.href="list.jsp"; // 삭제 후 목록으로 이동
</script>


