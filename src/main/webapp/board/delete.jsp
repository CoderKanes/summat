<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDAO"%> 
<%--
    작성자 : 신동엽
    설명   : 게시글 번호(num)를 받아
             해당 게시글과 연결된 댓글을 함께 삭제한 후
             목록 페이지로 이동하는 처리 페이지
--%>
<%
    // 1️ 요청 파라미터에서 게시글 번호(num) 가져오기
    
    String numStr = request.getParameter("num");
    int num = 0;
    // 2️ 게시글 번호가 전달된 경우 정수로 변환
    if(numStr != null) {
        num = Integer.parseInt(numStr);
    }
    // 3️ DAO 객체 생성
    BoardDAO dao = new BoardDAO();
    // 4️⃣ 게시글 + 해당 게시글의 댓글 함께 삭제
    dao.deleteBoardAndComments(num);
%>
<script>
    // 5️ 삭제 완료 알림
    alert("게시글이 삭제되었습니다.");
    // 6️ 게시글 목록 페이지로 이동
    location.href="list.jsp";
</script>
