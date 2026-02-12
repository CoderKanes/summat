<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.CommentDAO" %>
<%@ page import="sm.data.CommentDTO" %>

<%
String writerstr = request.getParameter("writer");
String boardNumStr = request.getParameter("boardNum");
String password = request.getParameter("password");   // 🔥 추가

if(writerstr != null && boardNumStr != null && password != null) {

    CommentDAO cdao = new CommentDAO();

    // 🔥 writer + password 같이 전달
    boolean deleted = cdao.deleteComment(writerstr, password);

    if(deleted) {
        response.sendRedirect("view.jsp?num=" + boardNumStr);
    } else {
%>
        <script>
            alert("비밀번호가 틀렸습니다.");
            history.back();
        </script>
<%
    }
}
%>