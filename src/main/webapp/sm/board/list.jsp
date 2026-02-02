<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, sm.data.BoardDTO, sm.data.BoardDAO, sm.data.CommentDAO"%>
<%@ page import="java.util.*"%>

<%
    // GET/POST 파라미터 처리 전 반드시 인코딩 설정
    
%>

<html>
<head>
    <meta charset="UTF-8"> <!-- HTML 인코딩 -->
    <title>게시글 목록</title>
</head>
<body>

    <h2>게시글 목록</h2>

    <!-- 검색 폼 -->
    <form method="get" action="list.jsp">
        <input type="text" name="keyword" placeholder="검색어 입력"
            value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
        <input type="submit" value="검색">
    </form>

<%
    String keyword = request.getParameter("keyword");

    BoardDAO dao = new BoardDAO();
    List<BoardDTO> list;

    if(keyword != null && !keyword.trim().isEmpty()) {
        // 검색어가 있으면 검색
        list = dao.searchBoards(keyword.trim());
    } else {
        // 전체 목록
        list = dao.getAllBoards();
    }
%>

    <table border="1" width="800">
        <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>날짜</th>
            <th>조회수</th>
            <th>댓글</th>
            <th>삭제</th>
        </tr>

<% if(list != null && !list.isEmpty()) {
       CommentDAO cdao = new CommentDAO();
       for(BoardDTO board : list) { %>
        <tr>
            <td><%= board.getNum() %></td>
            <td>
                <a href="view.jsp?num=<%= board.getNum() %>">
                    <%= board.getTitle() %>
                </a>
            </td>
            <td><%= board.getWriter() %></td>
            <td><%= board.getRegDate() %></td>
            <td><%= board.getHit() %></td>
            <td><%= cdao.getCommentCountByBoardNum(board.getNum()) %></td>
            <td>
                <a href="deletePro.jsp?num=<%=board.getNum()%>"
                 onclick="return confirm('삭제하시겠습니까?');">삭제</a>
            </td>
        </tr>
<%   } 
       cdao.close();
   } else { %>
           <tr>
            <td colspan="7" align="center">게시글이 없습니다.</td>
        </tr> 
<% } %>

    </table>

    <br>
    <input type="button" value="글쓰기" onclick="location.href='write.jsp'">

</body>
</html>
