<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDAO" %>
<%@ page import="sm.data.BoardDTO" %>
<%--
	 작성자 : 신동엽
    내용 : 게시글 삭제 처리 페이지
	       
📌 사용자 기능
1. 게시글 삭제 처리 기능
   - 상세보기(view.jsp) 또는 목록(list.jsp)에서 전달된 글 번호(num), 비밀번호(password) 받기
   - 입력한 비밀번호가 일치하는 경우 해당 게시글을 DB에서 삭제
   - 삭제 성공 시 게시글 목록 페이지(list.jsp)로 이동
   - 삭제 실패 시 비밀번호 오류 메시지 출력 후 이전 페이지로 이동

📌 구현 방법
1. request.getParameter()로 num, password 값 받기
2. Integer.parseInt()로 문자열 → 정수 변환
3. BoardDAO 객체 생성 후 삭제 메서드 호출
4. 반환값(boolean)에 따라 성공/실패 분기 처리
--%>


<%
    // 1️⃣ 한글 깨짐 방지
    request.setCharacterEncoding("UTF-8");

    // 2️⃣ 전달된 글 번호(num)와 비밀번호(password) 받기
    String numStr = request.getParameter("num");
    String password = request.getParameter("password");

    // 3️⃣ null 체크 (잘못된 접근 방지)
    if(numStr != null && password != null) {

        // 4️⃣ 문자열로 받은 글 번호를 정수형으로 변환
        int num = Integer.parseInt(numStr);

        // 5️⃣ BoardDAO 객체 생성 (DB 작업을 위해 필요)
        BoardDAO dao = new BoardDAO();

        // 6️⃣ 글 번호 + 비밀번호 기준으로 게시글 삭제
        //    (비밀번호가 일치해야 삭제됨)
        boolean deleted = dao.deleteComment(num, password);

        // 7️⃣ 삭제 결과 확인
        if(deleted) {
            // ✅ 삭제 성공 → 게시글 목록 페이지로 이동
            response.sendRedirect("list.jsp");
        } else {
            // ❌ 삭제 실패 → 비밀번호 오류 메시지 출력
%>
        <script>
            alert("비밀번호가 틀렸습니다.");  // 경고창 출력
            history.back();                  // 이전 페이지로 이동
        </script>
<%
        }

    } else {
        // ⚠️ 파라미터가 없는 잘못된 접근 → 목록 페이지로 이동
        response.sendRedirect("list.jsp");
    }
%>