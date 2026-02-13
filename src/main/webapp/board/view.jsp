<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="sm.data.BoardDTO, sm.data.BoardDAO, sm.data.CommentDTO, sm.data.CommentDAO"%>
<%--
    작성자 : 신동엽
    내용 : 게시글 상세보기 페이지 (view.jsp)

📌 사용자 기능
1. 게시글 상세보기
   - 게시글 번호(num) 파라미터로 조회
   - 조회수 증가 (IP 기준 중복 방지)
   - 게시글 존재하지 않을 경우 안내 메시지 출력
2. 댓글 목록 보기
   - 해당 게시글의 댓글 리스트 출력
   - 댓글 삭제 버튼 제공 (비밀번호 확인)
3. 댓글 작성
   - 작성자, 비밀번호, 내용 입력 후 댓글 작성 가능
4. 게시글 관리
   - 글 삭제 버튼 (비밀번호 확인)
   - 글 수정 버튼 (editForm.jsp로 이동)

📌 구현 방법
1. 파라미터 처리
   - request.getParameter("num")로 게시글 번호 받기
   - 문자열 → 정수 변환
2. 게시글 조회 및 조회수 증가
   - BoardDAO 사용
   - increaseHitByIP(num, ip)로 조회수 증가
   - getBoardByNum(num)으로 게시글 조회
3. 댓글 조회
   - CommentDAO 사용
   - getCommentsByBoard_Num(boardNum)으로 댓글 리스트 가져오기
4. 페이지 출력
   - 게시글 존재 여부 분기 처리
   - 게시글 정보, 내용, 댓글 리스트 출력
   - 댓글 작성 폼 제공
   - 게시글 삭제/수정 버튼 출력
5. 댓글 DAO 자원 해제
   - cdao.close() 호출
--%>

<link href="/summat/resources/css/style.css" rel="stylesheet" />
<%-- 스타일시트 연결 --%>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 보기</title>

<script>
	 //1️ 댓글 삭제 함수
function deleteComment(id, boardNum) {
    var pw = prompt("비밀번호를 입력하세요");
    if(pw != null) {
        location.href = "comment_delete.jsp?id=" + id 
                        + "&boardNum=" + boardNum 
                        + "&password=" + encodeURIComponent(pw);
    }
}
	// 2️ 게시글 삭제 함수 ★view 페이지
function deletePost(num) {
    var pw = prompt("비밀번호를 입력하세요");
    if(pw != null) {
        location.href = "delete.jsp?num=" + num + "&password=" + encodeURIComponent(pw);
    }
}
</script>

</head>
<body>

<%
	// 3️ 게시글 번호 파라미터 받기
    String numStr = request.getParameter("num");
    int num = 0;
    if(numStr != null) num = Integer.parseInt(numStr);
    // 4️ 클라이언트 IP 가져오기 (조회수 중복 방지용)
    String ip = request.getRemoteAddr();
 	// 5️ 게시글 조회 및 조회수 증가
    BoardDAO dao = new BoardDAO();
    dao.increaseHitByIP(num, ip);
    BoardDTO board = dao.getBoardByNum(num);
%>

<% if(board == null) { %>
   <%-- 6️ 게시글 없을 경우 메시지 출력 --%>
    <h3>존재하지 않는 게시글입니다.</h3>
    <a href="list.jsp">목록으로 돌아가기</a>
<% } else { %>
    <%-- 7️ 게시글 정보 출력 --%>
<h2><%= board.getTitle() %></h2>
<p><strong>작성자:</strong> <%= board.getWriter() %></p>
<p><strong>작성일:</strong> <%= board.getRegDate() %></p>
<p><strong>조회수:</strong> <%= board.getHit() %></p>

<hr>
<h3>내용</h3>
<p><%= board.getContent() %></p>
<hr>
    <%-- 8️ 댓글 목록 가져오기 --%>
<h3>댓글</h3>
<%
    CommentDAO cdao = new CommentDAO();
    List<CommentDTO> comments = cdao.getCommentsByBoard_Num(board.getNum());
%>
    <%-- 9️ 댓글 출력 --%>
<div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">
<% for(CommentDTO c : comments) { %>
    <p>
        <strong><%= c.getWriter() %></strong> [<%= c.getRegDate() %>] : <%= c.getContent() %>
        <a href="javascript:void(0);" onclick="deleteComment(<%= c.getId() %>, <%= board.getNum() %>)">삭제</a>
    </p>
<% } %>
</div>
    <%-- 10️ 댓글 작성 폼 --%>
<form action="comment_insert.jsp" method="post">
    <input type="hidden" name="board_Num" value="<%=board.getNum()%>">
    작성자: <input type="text" name="writer" required><br>
    비밀번호: <input type="password" name="password" required><br>
    내용:<textarea name="content" rows="3" cols="50" required></textarea><br>
    <input type="submit" value="댓글 작성">
</form>

<%
// 11️ 댓글 DAO 자원 해제
    cdao.close();
%>
    <%-- 12️ 게시글 관련 버튼 --%>
<p>
    <a href="list.jsp">목록으로 돌아가기</a>
   
    <input type="button" value="글 삭제" onclick="deletePost(<%= board.getNum() %>)">
    <button onclick="location.href='editForm.jsp?id=<%= board.getNum() %>'">글 수정</button>
</p>

<% } %>
</body>
</html>
