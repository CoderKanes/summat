<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.CommentDAO" %>
<%--
	작성자 : 신동엽
	내용 : 댓글 삭제 처리 페이지
	       - 목록 또는 상세보기에서 전달된 글 번호(id,boardNum,password)를 파라미터로 받음
	       - BoardDAO를 통해 해당 게시글 삭제 처리
	       - 삭제 완료 후 게시글 목록 페이지(view.jsp)로 이동
 --%>
<%
request.setCharacterEncoding("UTF-8");

String idStr = request.getParameter("id");
String boardNumStr = request.getParameter("boardNum");
String password = request.getParameter("password");

if(idStr != null && boardNumStr != null && password != null) {

    int id = Integer.parseInt(idStr);
    int boardNum = Integer.parseInt(boardNumStr);

    CommentDAO cdao = new CommentDAO();

    // 🔥 id + password 기준 삭제
    boolean deleted = cdao.deleteComment(id, password);

    if(deleted) {
        response.sendRedirect("view.jsp?num=" + boardNum);
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
