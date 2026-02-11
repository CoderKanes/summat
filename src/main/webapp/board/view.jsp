<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page
	import="sm.data.BoardDTO, sm.data.BoardDAO, sm.data.CommentDTO, sm.data.CommentDAO"%>
<link href="/summat/resources/css/style.css" style="text/css"
	rel="stylesheet" />
<%--
	작성자 : 신동엽
	내용 : 게시글 상세 보기 페이지
	       - 게시글 번호(num)로 게시글 조회
	       - IP 기준 조회수 증가
	       - 게시글 내용 출력
	       - 댓글 목록 조회 및 출력
	       - 댓글 작성 처리
 --%>

<html>
<head>
<meta charset="UTF-8">
<title>게시글 보기</title>
</head>
<body>

	<!-- 게시글 상세보기 요청 시 글 번호(num)와 접속 IP를 이용해 조회수를 증가시키고 게시글 정보를 조회 -->
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

	<% }


else { %>

	<!-- 게시글 내용 -->
	<h2><%= board.getTitle() %></h2>
	<p>
		<strong>작성자:</strong>
		<%= board.getWriter() %></p>
	<p>
		<strong>작성일:</strong>
		<%= board.getRegDate() %></p>
	<p>
		<strong>조회수:</strong>
		<%= board.getHit() %></p>


	<hr>
	<h3>내용</h3>
	<p><%= board.getContent() %></p>
	<hr>

	<!-- 삭제 버튼 -->
	<input type="button" value="글 삭제"
		onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='comment_delete.jspnum=<%= board.getNum() %>'">

	<!-- 댓글 영역 -->
	<h3>댓글</h3>
	<%
	CommentDAO cdao = new CommentDAO();
	List<CommentDTO> comments = cdao.getCommentsByBoard_Num(board.getNum());
	%>

	<div
		style="border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
		<%
		for (CommentDTO c : comments) {
		%>
		<p>
			<strong><%=c.getWriter()%></strong> [<%=c.getRegDate()%>]:
			<%=c.getContent()%>

			<!--  댓글 1삭제   -->
			<a href="#" onclick="deleteComment(${comment.id})">삭제</a>

			<script>
			function deleteComment(id) {
			    var pw = prompt("비밀번호를 입력하세요");
			
			    if(pw != null) {
			        location.href = "commentDelete.jsp?id=" + id + "&password=" + pw;
			    }
			}
			</script>
			<!--  댓글 2수정   -->
			<a
				href="comment_delete.jsp?id=<%=c.getId()%>&boardNum=<%=board.getNum()%>"
				onclick="return confirm('수정 완료 ');">수정</a>
		</p>
		<%
		}
		%>
	</div>

	<!-- 댓글 작성 폼 -->
	<form action="comment_insert.jsp" method="post">
		<input type="hidden" name="board_Num" value="<%=board.getNum()%>">
		작성자: <input type="text" name="writer" required><br> 비밀번호:
		<input type="password" name="password" required><br> 내용:
		<textarea name="content" rows="3" cols="50" required></textarea>
		<br> <input type="submit" value="댓글 작성">
	</form>

	<%
	cdao.close();
	%>

	<!-- 목록으로 돌아가기 -->
	<p>
		<a href="list.jsp">목록으로 돌아가기</a>
	</p>
	<%

    } %>

</body>
</html>
