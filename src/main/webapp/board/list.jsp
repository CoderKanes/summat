<!-- page 지시어 4가지   -->
<%-- 
	상단에 지시어 정리 하면 
	1,날짜 
	2,언어 
	3,DAO DTO 호출하고 객체 사용하는기능    
	4,유틸 패키지 사용
--%>

<%@page import="java.text.SimpleDateFormat"%>
<!-- 1 .날짜 형식을 원하는 형태로 바꿀 수 있음 없으면 SimpleDateFormat 사용 시 컴파일 에러 발생  -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!--2 프로그래밍 언어 지정 역활  고정으로 사용해야 함 (language="java" 자바 언어 사용하겠다)-->

<%@ page import="sm.data.BoardDTO, sm.data.BoardDAO, sm.data.CommentDAO"%>
<!--3 사용자 지정 클래스 가져오기 DAO호출 가능 DTO객체 사용 가능    -->

<%@ page import="java.util.*"%>
<!-- 자바 유틸패키지 list , ArrayList date Iterator 포합해서 사용하겠다 선언 -->



<%--
	작성자 : 신동엽
		
		- 사용자 기능 4가지-
		- 1.게시글 목록 보기 (.jsp)
		 (- 게시글 번호, 제목, 작성자, 작성일, 조회수 출력)
		 ( - 게시글 전체 목록 조회)
		 (- 게시글별 댓글 수 표시)
		- 2.검색기능		( - 검색어(keyword) 입력 시 제목/내용 기준 검색)
		- 3.게시글 삭제
		- 4.페이징 기능 (- 글쓰기 페이지(write.jsp) 이동 기능)
			   
		- 구현 방법 - 
		- DAO 메서드 호출  
		- 파라미터 처리
		- 계산 로직
		- javaScript 실행 
		
 --%>
 
 
<!-- 구현 방법: JavaScript 실행 -->
<!-- 사용자 기능 ③ 게시글 삭제 -->

<script> 
function boarddelete(Num) {

    var password = prompt("비밀번호를 입력하세요");  // 사용자에게 비밀번호 입력 받기

    if (password == null) {  // 취소 누른 경우
        return;
    }

    if (password.trim() === "") {  // 공백 입력
        alert("비밀번호를 틀렸습니다.");
        return;
    }

    // 삭제 처리 페이지로 이동 (num + password 전달)
    location.href =
        "deletepro.jsp?num=" + Num +
        "&password=" + encodeURIComponent(password);
}
</script>




<!-- CSS 담당하는 기능으로 페이지 모양 스타일 색깔 저장해 놓은 부분을 가져 오는 태그   -->
<link href="/summat/resources/css/style.css" style="text/css"
	rel="stylesheet" />
<style>
/* 게시판 전용 추가 스타일 */
.board-container {
    max-width: 90%;
    margin: 40px auto;
    padding: 20px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.board-table {
	width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    /* 테이블 레이아웃을 고정하여 컬럼 너비를 강제합니다 */
    table-layout: fixed;
}

.board-table th {
    background-color: #f8f9fa;
    color: #444;
    padding: 15px;
    border-bottom: 2px solid #eee;
    font-weight: 600;
}

/* 각 컬럼의 너비를 비율로 지정 (총합 100%) */
.board-table th:nth-child(1) { width: 60px; }  /* 번호 */
.board-table th:nth-child(2) { width: auto; }  /* 제목 (남은 공간 모두 차지) */
.board-table th:nth-child(3) { width: 100px; } /* 작성자 */
.board-table th:nth-child(4) { width: 120px; } /* 날짜 */
.board-table th:nth-child(5) { width: 70px; }  /* 조회수 */
.board-table th:nth-child(6) { width: 60px; }  /* 댓글 */
.board-table th:nth-child(7) { width: 80px; }  /* 관리 */

.board-table td {
    padding: 15px;
    border-bottom: 1px solid #eee;
    text-align: center;
    color: #555;
    /* 내용이 넘칠 때를 대비한 설정 */
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.board-table tr:hover {
    background-color: #fafafa;
}

.board-table .title-cell {
	text-align: left;
    /* 말줄임표 핵심 속성 */
    white-space: nowrap;      /* 줄바꿈 방지 */
    overflow: hidden;         /* 영역 밖 숨김 */
    text-overflow: ellipsis;  /* ... 표시 */
}

.board-table .title-cell a {
    display: block;           /* 클릭 영역 확장 및 정렬 유지 */
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.board-table a {
    text-decoration: none;
    color: var(--text);
}

.board-table a:hover {
    color: var(--point);
}

/* 검색창 및 버튼 디자인 */
.search-area {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.search-form input[type="text"] {
    padding: 8px 12px;
    border: 1px solid #ddd;
    border-radius: 6px;
    outline: none;
}

.pagination {
    display: flex;
    justify-content: center;
    gap: 8px;
    margin-top: 30px;
}

.pagination a {
    padding: 8px 14px;
    border: 1px solid #ddd;
    border-radius: 6px;
    background: #fff;
    color: #333;
    text-decoration: none;
}

.pagination a:hover {
    border-color: var(--point);
    color: var(--point);
}
</style>

	<jsp:include page="/main/topBar.jsp"></jsp:include>
	
<div class="board-container">
	
	<!-- 2️ 검색 폼 영역 -->
	<div class="search-area">
		<form method="get" action="list.jsp" class="search-form">
			<input type="text" name="keyword" placeholder="검색어 입력"
				value="<%=request.getParameter("keyword") != null ? request.getParameter("keyword") : ""%>">
			<button type="submit" class="theme-btn">검색</button>
		</form>
	</div>


	<!------3️ JSP 선언부 (전역 변수)---->
<%! 
	int pageSize = 10;  // 한 페이지에 보여줄 게시글 수
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

	<!--  교무실 행정  파라미터 받기 db조회   -->
	<!-- 3️ 검색 조건 판단 + 게시글 조회 -->
	<%
	//페이지 번호를 요청 파라미터로 받아온다
	String pageNum = request.getParameter("pageNum"); // 입력 받기 
	//페이지 번호가 없으면 기본값으로 1페이지 설정
	if (pageNum == null) { // 만약에 기본값이 없으면
		pageNum = "1"; // ㄴ 기본값 1로 하겠다 
	}
	// 페이지 이동 시 사용할 반환용 문자열 초기화
	String pageReturn = ""; // 다음 페이지로 넘어갈 때 함께 들고 갈 정보 보관용 
	// 현재 보고 있는 페이지 번호를 정수로 변환
	int currentPage = Integer.parseInt(pageNum);
	// 현재 페이지 기준으로 시작 행과 끝 행 계산 (페이징 처리)
	int startRow = (currentPage - 1) * pageSize + 1;
	int endRow = currentPage * pageSize;
	// 전체 게시글 수 및 화면에 출력할 번호 변수
	int count = 0;
	int number = 0;

	// BoardDAO 싱글톤 객체 생성
	BoardDAO dao = BoardDAO.getInstance();
	// 전체 게시글 수 조회
	count = dao.getBoardCount();

	// 검색어 파라미터 받아오기
	String keyword = request.getParameter("keyword");

	// 게시글 목록을 담기 위한 리스트 변수 선언
	List<BoardDTO> list = null;

	// 게시글이 하나 이상 존재할 경우에만 목록 조회 수행
	if (count > 0) {
		// 검색어가 존재하고 공백이 아닌 경우 검색 결과 목록 조회
		// trim(): 공백 제거 / isEmpty(): 문자열 길이가 0인지 확인
		if (keyword != null && !keyword.trim().isEmpty()) {
			// 검색어가 있으면 검색
			list = dao.searchBoards(keyword.trim());
		} else {
			// 검색어가 없으면 전체 게시글 목록을 페이징 처리하여 조회
			list = dao.getAllBoards(startRow, endRow);
		}
	}
	%>
	<!--******************************************************************************************-->
	<!-- -----4. 리스트 글 목록 --------->
	<table class="board-table">
        <thead>
		<tr height="30">
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>날짜</th>
			<th>조회수</th>
			<th>댓글</th>
			<th>삭제</th>
		</tr>
		</thead>
		<!-- -----5. 리스트 글 목록 --------->
		<tbody>
		<%
		if (list != null && !list.isEmpty()) {
			CommentDAO cdao = new CommentDAO();
			for (BoardDTO board : list) {
		%>

		<!-- ---------6. 게시글 리스트 출력  --------->
		<tr>
			<td><%=board.getNum()%></td>
			<td><a href="view.jsp?num=<%=board.getNum()%>"> <%=board.getTitle()%></a></td>
			<td><%=board.getWriter()%></td>
			<td><%=board.getRegDate()%></td>
			<td><%=board.getHit()%></td>

			<td><%=cdao.getCommentCountByBoardNum(board.getNum())%></td>

			<td><a href="#"
				onclick="boarddelete(<%=board.getNum()%>); return false;">삭제</a> <%
 }
 cdao.close();
 } else {
 %>
		<tr>
			<td colspan="7" align="center">게시글이 없습니다.</td>
		</tr>
		<%
		}
		%>
		</tbody>
	</table>
	<!--******************************************************************************************-->

	<!------글쓰기 버튼 영역---->
	<br>
	<div style="text-align: right; margin-top: 20px;">		
        <button class="theme-btn" onclick="location.href='write.jsp'">글쓰기</button>
    </div>

	<!--페이지 총 글자수 계산 1페이지에서 보여줄 갯수 확인 만약에 카운트가 0보다 크면-->
	<div class="pagination">
	<%
	// 만약에 카운트가 0보다 크면 
	if (count > 0) {
		// 카운트 나누기 페이지 사이트 더하기 ( 카운트 나누기 페이지 사이즈 는 == 0 ? 0 : 1 );
		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
		// 현재 페이지를 10으로 나눈 "페이지 그룹"을 구한 뒤
		// 해당 그룹의 시작 페이지 번호를 계산 (정수 나눗셈)
		int startPage = (int) (currentPage / 10) * 10 + 1;

		//페이지 블록 밑에 [1] << 이게 10개씩 보여준다는 의미에 선언문
		int pageBlock = 10;
		// 마지막 페이지는 = 시작페이지 더하기 페이지블록(10)-1 그래서 시작페이지 1이라고 생각하면 엔드페이지 10임   
		int endPage = startPage + pageBlock - 1;
		// 마지막 페이지가  크다 페이지 카운트 보다 
		if (endPage > pageCount) {
			endPage = pageCount;
			// 페이지 카운트에 마지막페이지 넣기 
		}
		// 만약에 시작페이지가 크다 10보다 
		//시작페이지가 10보다 크면 여기 안에 if문 실행 하겠다 . 
		// 기능은 스타트페이지 -10 하고 페이지리턴은 
		if (startPage > 10) {
	%>

	<!-- 리스트페이지 이전 태그이동 시작페이지 -10 페이지리턴 ""  -->
	<!--  여기 안에 시작페이지 기능 리턴페이지 기능 자바스크립트 추가 하기    -->
	
	<a href="list.jsp?pageNum=<%=startPage - 10%><%=pageReturn%>">[이전]</a>

	<%
	}

	for (int i = startPage; i <= endPage; i++) {
	%>

	<a href="list.jsp?pageNum=<%=i%><%=pageReturn%>">[<%=i%>]
	</a>
	<%
	}
	if (endPage < pageCount) {
	%>
	<a href="list.jsp?pageNum=<%=startPage + 10%><%=pageReturn%>">[다음]</a>
	<%
	}
	}
	%>
	</div>
	
	<button class="search-btn" onclick="location.href='list.jsp'">게시글 목록</button>  		
</div>
