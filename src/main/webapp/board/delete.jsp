<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDAO"%> 
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
    // 1️⃣ 요청 파라미터에서 게시글 번호(num) 가져오기
    String numStr = request.getParameter("num");

    // 2️⃣ 게시글 번호를 저장할 변수 선언 및 초기화
    int num = 0;

    // 3️⃣ 게시글 번호가 전달된 경우 정수형으로 변환
    if(numStr != null) {
        num = Integer.parseInt(numStr);   // 문자열 → 정수 변환
    }

    // 4️⃣ BoardDAO 객체 생성 (DB 작업을 위해 필요)
    BoardDAO dao = new BoardDAO();

    // 5️⃣ 게시글 + 해당 게시글에 달린 댓글 함께 삭제
    dao.deleteBoardAndComments(num);
%>

<script>
    // 6️⃣ 삭제 완료 알림 메시지 출력
    alert("게시글이 삭제되었습니다.");

    // 7️⃣ 게시글 목록 페이지로 이동
    location.href="list.jsp";
</script>
