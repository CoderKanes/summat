<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.FoodCommentDAO"%> 
<%@ page import="sm.data.MenuDAO"%>
<%@ page import="sm.data.MenuDTO"%>

<%--
     작성자 : 신동엽
    설명   : 게시글 번호(num)를 받아
             해당 게시글과 연결된 댓글을 함께 삭제한 후
             목록 페이지로 이동하는 처리 페이지
📌 사용자 기능
1. 게시글 전체 삭제 기능
   - 상세보기(view.jsp) 또는 목록(list.jsp)에서 전달된 게시글 번호(num) 받기
   - 해당 게시글과 그 게시글에 달린 댓글을 함께 삭제
   - 삭제 완료 후 목록 페이지(list.jsp)로 이동
   - 삭제 완료 메시지(alert) 출력

📌 구현 방법
1. 파라미터 처리
   - request.getParameter()로 게시글 번호(num) 받기
   - null 체크 후 Integer.parseInt()로 정수 변환

2. DAO 객체 사용
   - BoardDAO 객체 생성
   - deleteBoardAndComments(num) 메서드 호출
   - 게시글과 관련 댓글을 함께 삭제 (트랜잭션 처리 가능성 있음)

3. 페이지 이동 처리
   - 자바스크립트 alert()로 삭제 완료 메시지 출력
   - location.href로 목록 페이지 이동
--%>

<%
    // 1️⃣ 요청 파라미터 가져오기
    String idStr = request.getParameter("id");           // 삭제할 댓글 ID
    String boardNumStr = request.getParameter("boardNum"); // 댓글이 달린 게시글 ID
    String pw = request.getParameter("password");       // JS에서 입력한 비밀번호

    // 2️⃣ 초기화
    int commentId = 0;
    int boardNum = 0;

    if(idStr != null) commentId = Integer.parseInt(idStr);
    if(boardNumStr != null) boardNum = Integer.parseInt(boardNumStr);

    // 3️⃣ DAO 생성
    FoodCommentDAO dao = new FoodCommentDAO();

    // 4️⃣ 댓글 삭제 (비밀번호 검증 포함)
    int result = dao.FoodDeleteComments(commentId, pw); // 삭제 성공=1, 실패=0
%>

<script>
<%
    if(result > 0){
%>
    alert("댓글이 삭제되었습니다.");
    location.href="/summat/food/foodView.jsp?menuId=<%= boardNum %>";
<%
    } else {
%>
    alert("비밀번호가 틀렸습니다. 삭제할 수 없습니다.");
    history.back(); // 이전 페이지로 돌아가기
<%
    }
%>
</script>
