<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.CommentDAO, sm.data.CommentDTO" %>
<%--
    작성자 : 신동엽
    파일명 : comment_insert.jsp
    설명   : 게시글 상세 화면(view.jsp)에서 전달된
             게시글 번호(boardNum), 작성자(writer), 비밀번호(password), 댓글 내용(content)을 받아
             댓글을 DB에 저장한 후
             다시 해당 게시글 상세 화면으로 이동하는 처리 페이지

📌 사용자 기능
1. 댓글 작성 기능
   - 게시글 상세보기(view.jsp)에서 댓글 작성 폼 입력
   - 작성자, 비밀번호, 댓글 내용 입력 후 등록
   - 해당 게시글에 댓글 저장
   - 저장 완료 후 다시 상세보기 페이지로 이동

📌 구현 방법
1. 파라미터 처리
   - request.getParameter()로 board_Num, writer, password, content 받기
   - board_Num은 Integer.parseInt()로 정수 변환
   - 예외 처리(NumberFormatException)로 안전하게 변환

2. DTO 객체 사용
   - CommentDTO 객체 생성
   - setter 메서드로 댓글 정보 저장
   - 데이터를 하나의 객체로 묶어 DAO에 전달

3. DAO 호출
   - CommentDAO.insertComment(comment) 실행
   - DB에 댓글 INSERT 수행

4. 페이지 이동 처리
   - response.sendRedirect()로 해당 게시글 상세보기(view.jsp) 이동
--%>

<%
    // 1️⃣ 폼에서 전달된 값 받기
    String boardNumStr = request.getParameter("board_Num");  // 게시글 번호
    String writer = request.getParameter("writer");          // 작성자
    String password = request.getParameter("password");      // 비밀번호
    String content = request.getParameter("content");        // 댓글 내용

    // 2️⃣ 게시글 번호를 저장할 변수 선언 및 초기화
    int boardNum = 0;

    // 3️⃣ board_Num 값이 null이 아니고 비어있지 않다면 정수로 변환
    if(boardNumStr != null && !boardNumStr.isEmpty()) {
        try {
            boardNum = Integer.parseInt(boardNumStr);   // 문자열 → 정수 변환
        } catch (NumberFormatException e) {
            e.printStackTrace();   // 숫자 변환 실패 시 예외 출력
            // 필요 시 에러 페이지 이동 처리 가능
        }
    }

    // 4️⃣ 댓글 DTO 객체 생성
    CommentDTO comment = new CommentDTO();

    // 5️⃣ DTO에 댓글 데이터 저장
    comment.setBoard_Num(boardNum);   // 게시글 번호 설정
    comment.setWriter(writer);        // 작성자 설정
    comment.setPassword(password);    // 비밀번호 설정
    comment.setContent(content);      // 댓글 내용 설정

    // 6️⃣ DAO 객체 생성 (DB 작업을 위해 필요)
    CommentDAO cdao = new CommentDAO();

    // 7️⃣ DAO를 통해 댓글 DB에 저장
    cdao.insertComment(comment);

    // 8️⃣ 댓글 작성 완료 후 해당 게시글 상세보기 페이지로 이동
    response.sendRedirect("view.jsp?num=" + boardNum);
%>