<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDTO, sm.data.BoardDAO"%>
<link href="/summat/resources/css/style.css" rel="stylesheet" />

<%--
   작성자 : 신동엽
    내용 : 게시글 수정 화면 페이지
           - 상세보기(view.jsp)에서 전달된 글 번호(id)를 파라미터로 받음
           - BoardDAO를 통해 해당 글 정보를 조회
           - 기존 제목, 작성자, 내용을 수정 폼에 출력
           - 수정 버튼 클릭 시 editPro.jsp로 POST 전송
           - 취소 버튼 클릭 시 해당 글 상세보기(view.jsp)로 이동
📌 사용자 기능
1. 게시글 수정 화면 제공
   - 상세보기에서 "수정" 클릭 시 수정 화면으로 이동
   - 기존 제목, 작성자, 내용을 불러와 수정 가능
   - 비밀번호 입력 후 수정 가능
   - 수정 버튼 클릭 시 수정 처리(editPro.jsp)로 이동
   - 취소 버튼 클릭 시 다시 상세보기 화면으로 이동

📌 구현 방법
1. 파라미터 처리
   - request.getParameter("id")로 게시글 번호 받기
   - null / 공백 체크로 잘못된 접근 방지
   - Integer.parseInt()로 문자열 → 정수 변환

2. DAO 호출
   - BoardDAO 객체 생성
   - getBoardByNum(id) 실행하여 기존 게시글 정보 조회

3. 예외 처리
   - 게시글 정보가 null이면 잘못된 접근으로 간주하고 종료

4. 화면 출력
   - 조회한 BoardDTO 객체(post)의 값을 input, textarea에 출력
   - hidden 필드로 글 번호 전달
   - form은 POST 방식으로 editPro.jsp에 전송
--%>

<%
    // 1️⃣ 수정할 게시글 번호(id) 파라미터 받기
    String paramId = request.getParameter("id");

    // 2️⃣ id 값이 없거나 비어있는 경우 예외 처리
    if(paramId == null || paramId.isEmpty()){
        out.println("수정할 글을 선택해주세요.");  // 안내 메시지 출력
        return;  // 더 이상 진행하지 않음
    }

    // 3️⃣ 문자열로 전달된 id를 정수형(int)으로 변환
    int id = Integer.parseInt(paramId);

    // 4️⃣ DAO 객체 생성 (DB 접근 준비)
    BoardDAO dao = new BoardDAO();

    // 5️⃣ 글 번호를 기준으로 해당 게시글 정보 조회
    BoardDTO post = dao.getBoardByNum(id);

    // 6️⃣ 조회 결과가 없는 경우 예외 처리
    if(post == null){
        out.println("글 정보를 가져올 수 없습니다.");  // 잘못된 번호 접근
        return;  // 실행 중단
    }
%>

<h2>게시글 수정</h2>

<!-- 7️⃣ 수정 데이터를 editPro.jsp로 POST 방식 전송 -->
<form action="editPro.jsp" method="post"> 

    <!-- 8️⃣ 글 번호는 화면에 보이지 않지만 수정 처리에 필요하므로 hidden으로 전달 -->
    <input type="hidden" name="num" value="<%= post.getNum() %>">
    
    <!-- 9️⃣ 기존 제목을 입력창에 출력하여 수정 가능하도록 설정 -->
    <label>제목</label><br>
    <input type="text" name="title" 
           value="<%= post.getTitle() %>" size="60"><br><br>
    
    <!-- 10 기존 작성자 정보를 입력창에 출력 -->
    <label>작성자</label><br>
    <input type="text" name="writer" 
           value="<%= post.getWriter() %>" size="30"><br><br>
    
    <!-- 1️1️ 기존 내용을 textarea에 출력하여 수정 가능하도록 처리 -->
    <label>내용</label><br>
    <textarea name="content" rows="10" cols="60">
        <%= post.getContent() %>
    </textarea><br><br>
    
    <!-- 1️2️ 수정 시 본인 확인을 위한 비밀번호 입력창 -->
    <label>비밀번호</label><br>
    <input type="password" name="password" value="" size="20"><br><br>
    
    <!-- 1️3️ 수정 버튼: editPro.jsp로 POST 전송 -->
    <input type="submit" value="수정">
    
    <!-- 1️4️ 취소 버튼: 수정 취소 후 상세보기 페이지로 이동 -->
    <input type="button" value="취소" 
           onclick="location.href='view.jsp?num=<%= post.getNum() %>';">
</form>