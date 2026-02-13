<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.CommentDAO" %>
<%--
	작성자 : 신동엽
	 파일명 : comment_delete.jsp
	내용 : 댓글 삭제 처리 페이지
	       - 목록 또는 상세보기에서 전달된 글 번호(id,boardNum,password)를 파라미터로 받음
	       - BoardDAO를 통해 해당 게시글 삭제 처리
	       - 삭제 완료 후 게시글 목록 페이지(view.jsp)로 이동
	       📌 사용자 기능
	       
1. 댓글 삭제 처리 기능
   - 상세보기(view.jsp)에서 전달된 댓글 번호(id), 게시글 번호(boardNum), 비밀번호(password) 받기
   - 입력한 비밀번호가 일치하는 경우 해당 댓글을 DB에서 삭제
   - 삭제 성공 시 해당 게시글 상세보기(view.jsp)로 이동
   - 삭제 실패 시 비밀번호 오류 메시지 출력 후 이전 페이지로 이동

📌 구현 방법
1. 파라미터 처리
   - request.getParameter()로 id, boardNum, password 값 받기
   - id, boardNum은 Integer.parseInt()로 정수 변환
   - null 체크로 잘못된 접근 방지

2. DAO 객체 사용
   - CommentDAO 객체 생성
   - deleteComment(id, password) 메서드 호출
   - id + password 일치 여부로 삭제 처리

3. 결과 분기 처리
   - deleteComment() 반환값(boolean) 확인
   - true → 삭제 성공
   - false → 삭제 실패 (비밀번호 불일치)

4. 페이지 이동 처리
   - response.sendRedirect()로 상세보기 페이지 이동
   - 실패 시 alert() 후 history.back() 실행
   - 파라미터가 없으면 list.jsp로 이동
 --%>
 
<%
    // 1️ 한글 깨짐 방지
    request.setCharacterEncoding("UTF-8");

    //  전달된 파라미터 받기
    String idStr = request.getParameter("id");
    String boardNumStr = request.getParameter("boardNum");
    String password = request.getParameter("password");

    // 3️ 파라미터 null 체크
    if(idStr != null && boardNumStr != null && password != null) {

        // 4️ 문자열 → 정수형 변환
        int id = Integer.parseInt(idStr);
        int boardNum = Integer.parseInt(boardNumStr);

        // 5️ DAO 객체 생성
        CommentDAO cdao = new CommentDAO();

        // 6️ 댓글 삭제 (id + password 일치 여부 확인)
        boolean deleted = cdao.deleteComment(id, password);

        // 7️ 삭제 결과에 따른 처리
        if(deleted) {
            //  삭제 성공 → 해당 게시글 상세보기 페이지로 이동
            response.sendRedirect("view.jsp?num=" + boardNum);
        } else {
            // ❌ 삭제 실패 → 비밀번호 오류
%>
            <script>
                alert("비밀번호가 틀렸습니다.");
                history.back();
            </script>
<%
        }

    } else {
        // ⚠ 잘못된 접근 → 목록 페이지로 이동
        response.sendRedirect("list.jsp");
    }
%>
