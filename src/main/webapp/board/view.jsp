<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="sm.data.BoardDTO, sm.data.BoardDAO, sm.data.CommentDTO, sm.data.CommentDAO" %>
<%
    // UTF-8 응답 설정
    
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 보기</title>
</head>
<body>

<%
    // 글 번호 가져오기
    String numStr = request.getParameter("num");
    int num = 0;
    if(numStr != null) {
        num = Integer.parseInt(numStr);
    }

    // 클라이언트 IP 가져오기
    String ip = request.getRemoteAddr();

    // 게시글 DAO 생성
    BoardDAO dao = new BoardDAO();

    // 조회수 증가 (IP 기준 한 번만 증가)
    dao.increaseHitByIP(num, ip);

    // 게시글 정보 가져오기
    BoardDTO board = dao.getBoardByNum(num);
%>

<% if(board == null) { %>
    <h3>존재하지 않는 게시글입니다.</h3>
    <a href="list.jsp">목록으로 돌아가기</a>
<% } else { %>

    <!-- 게시글 내용 -->
    <h2><%= board.getTitle() %></h2>
    <p><strong>작성자:</strong> <%= board.getWriter() %></p>
    <p><strong>작성일:</strong> <%= board.getRegDate() %></p>   
    <p><strong>조회수:</strong> <%= board.getHit() %></p>
    <hr>
    <p><%= board.getContent() %></p>
    <hr>

    <!-- 삭제 버튼 -->
    <input type="button" value="삭제" 
        onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='delete.jsp?num=<%= board.getNum() %>'">

    <!-- 댓글 영역 -->
    <h3>댓글</h3>
    <%
        CommentDAO cdao = new CommentDAO();
        List<CommentDTO> comments = cdao.getCommentsByBoardNum(board.getNum());
    %>

    <div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">
        <% for(CommentDTO c : comments) { %>
            <p>
                <strong><%= c.getWriter() %></strong> 
                [<%= c.getRegDate() %>]: 
                <%= c.getContent() %>
            </p>
        <% } %>
    </div>

    <!-- 댓글 작성 폼 -->
    <form action="comment_insert.jsp" method="post">
        <input type="hidden" name="boardNum" value="<%= board.getNum() %>">
        작성자: <input type="text" name="writer" required><br>
        내용: <textarea name="content" rows="3" cols="50" required></textarea><br>
        <input type="submit" value="댓글 작성">
    </form>

    <%
        cdao.close();
    %>

    <!-- 목록으로 돌아가기 -->
    <p>
        <a href="list.jsp">목록으로 돌아가기</a>
    </p>

<% } %>

</body>
</html>
