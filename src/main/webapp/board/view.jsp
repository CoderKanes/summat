<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="sm.data.BoardDTO, sm.data.BoardDAO, sm.data.CommentDTO, sm.data.CommentDAO"%>

<link href="/summat/resources/css/style.css" rel="stylesheet" />

<html>
<head>
<meta charset="UTF-8">
<title>게시글 보기</title>

<!--  팝업 창 띄우는 화면  -->
<script>
function deleteComment(id, boardNum) {
    var pw = prompt("비밀번호를 입력하세요");

    if(pw != null) {
        location.href = "comment_delete.jsp?id=" + id 
                        + "&boardNum=" + boardNum 
                        + "&password=" + pw;
    }
}
</script>

</head>
<body>


<%
    String numStr = request.getParameter("num");
    int num = 0;
    if(numStr != null) {
        num = Integer.parseInt(numStr);
    }

    String ip = request.getRemoteAddr();

    BoardDAO dao = new BoardDAO();
    dao.increaseHitByIP(num, ip);
    BoardDTO board = dao.getBoardByNum(num);
%>

<% if(board == null) { %>

    <h3>존재하지 않는 게시글입니다.</h3>
    <a href="list.jsp">목록으로 돌아가기</a>

<% } else { %>

    <h2><%= board.getTitle() %></h2>
    <p><strong>작성자:</strong> <%= board.getWriter() %></p>
    <p><strong>작성일:</strong> <%= board.getRegDate() %></p>
    <p><strong>조회수:</strong> <%= board.getHit() %></p>

    <hr>
    <h3>내용</h3>
    <p><%= board.getContent() %></p>
    <hr>

    <!-- 댓글 영역 -->
    <h3>댓글</h3>

<%
    CommentDAO cdao = new CommentDAO();
    List<CommentDTO> comments = cdao.getCommentsByBoard_Num(board.getNum());
%>

<div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">

<% for(CommentDTO c : comments) { %>

    <p>
        <strong><%= c.getWriter() %></strong>
        [<%= c.getRegDate() %>]
        : <%= c.getContent() %>

        <!-- 댓글 삭제 -->
        <a href="javascript:void(0);" 
           onclick="deleteComment(<%= c.getId() %>, <%= board.getNum() %>)">
           삭제
        </a>
    </p>

<% } %>

</div>

<!-- 댓글 작성 폼 -->
<form action="comment_insert.jsp" method="post">
    <input type="hidden" name="board_Num" value="<%=board.getNum()%>">
    작성자: <input type="text" name="writer" required><br>
    비밀번호: <input type="password" name="password" required><br>
    내용:<textarea name="content" rows="3" cols="50" required></textarea><br>
    <input type="submit" value="댓글 작성">
</form>

<%
    cdao.close();
%>

<p>
    <a href="list.jsp">목록으로 돌아가기</a>
     <input type="submit"  value=" 글 삭제 ">
</p>

<% } %>

</body>
</html>
