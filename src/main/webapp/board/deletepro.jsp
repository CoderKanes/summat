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
request.setCharacterEncoding("UTF-8");

// 1️⃣ 글 번호 받기
String numStr = request.getParameter("num");
String password = request.getParameter("password");

if(numStr != null && password != null) {

    int num = Integer.parseInt(numStr);

    BoardDAO dao = new BoardDAO();

    // num + password 기준 삭제
    boolean deleted = dao.deleteComment(num, password);

    if(deleted) {
        response.sendRedirect("list.jsp");
    } else {
%>
        <script>
            alert("비밀번호가 틀렸습니다.");
            history.back();
        </script>
<%
    }

} else {
    response.sendRedirect("list.jsp");
}
%>