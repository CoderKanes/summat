<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDTO, sm.data.BoardDAO, sm.data.CommentDAO"%>
<%@ page import="java.util.*"%>

<link href="/summat/resources/css/style.css" style="text/css" rel="stylesheet" />
<%--
	작성자 : 신동엽
	내용 : 게시글 목록 페이지
	       - 게시글 전체 목록 조회
	       - 검색어(keyword) 입력 시 제목/내용 기준 검색
	       - 게시글 번호, 제목, 작성자, 작성일, 조회수 출력
	       - 게시글별 댓글 수 표시
	       - 게시글 삭제 기능 제공
	       - 글쓰기 페이지(write.jsp) 이동 기능
	       
	       - 1. 검색 폼 
	       - 2. JSP 선언부 (전역 변수 / 유틸 메서드)
	       - 3. 검색 조건 판단 + 게시글 조회 
	       - 4. 리스트 글 목록 
	       - 5. 리스트 글 목록 
	       - 6. 게시글 한 줄 출력
	       - 7. 
	       - 8. 
 --%>
 
<html>
<head>
<meta charset="UTF-8">
<!-- HTML 인코딩 -->
<h2>
    <a href="list.jsp?">게시글 목록</a>
</h2>
</head>
<body>
	

	<!-- 1 검색 폼 -->
	<form method="get" action="list.jsp">
		<input type="text" name="keyword" placeholder="검색어 입력"
			value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
		<input type="submit" value="검색">
	</form>
	
	<!------2 JSP 선언부 (전역 변수 / 유틸 메서드)---->
<%!
	int pageSize = 10;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
  <!-- 3️ 검색 조건 판단 + 게시글 조회 -->
<%
	//페이지 번호를 요청 파라미터로 받아온다
	String pageNum = request.getParameter("pageNum");  // 입력 받기 
	//페이지 번호가 없으면 기본값으로 1페이지 설정
	if(pageNum == null){     // 만약에 기본값이 없으면
		pageNum="1";        // ㄴ 기본값 1로 하겠다 
	}
	// 페이지 이동 시 사용할 반환용 문자열 초기화
	String pageReturn = "";     // 다음 페이지로 넘어갈 때 함께 들고 갈 정보 보관용 
	// 현재 보고 있는 페이지 번호를 정수로 변환
	int currentPage = Integer.parseInt(pageNum); 
	// 현재 페이지 기준으로 시작 행과 끝 행 계산 (페이징 처리)
	int startRow = (currentPage - 1) * pageSize + 1;
	int endRow = currentPage * pageSize;
	// 전체 게시글 수 및 화면에 출력할 번호 변수
	int count = 0;
	int number= 0;
	
	
	
	// BoardDAO 싱글톤 객체 생성
	BoardDAO dao = BoardDAO.getInstance();
	// 전체 게시글 수 조회
	count = dao.getBoardCount();
	
	// 검색어 파라미터 받아오기
    String keyword = request.getParameter("keyword");
	
 	
    List<BoardDTO> list = null;
    
 	// 게시글이 하나 이상 존재할 경우에만 목록 조회 수행
    if (count > 0) {
    	// 검색어가 존재하고 공백이 아닌 경우 검색 결과 목록 조회
        // trim(): 공백 제거 / isEmpty(): 문자열 길이가 0인지 확인
	    if(keyword != null && !keyword.trim().isEmpty()) {
	        // 검색어가 있으면 검색
	        list = dao.searchBoards(keyword.trim()); 
	    } else {
	    	  // 검색어가 없으면 전체 게시글 목록을 페이징 처리하여 조회
	        list = dao.getAllBoards(startRow , endRow);
	    }
    }
    
%>

<!-- -----4. 리스트 글 목록 ---------> 

<table border="1" width="100%" cellpadding="0" cellspacing="0" align="center">
			<tr height="30">
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>날짜</th>
			<th>조회수</th>
			<th>댓글</th>
			<th>삭제</th>
		</tr>
		
<!-- -----5. 리스트 글 목록 ---------> 
<%	
if( list != null && !list.isEmpty() ) { 
       CommentDAO cdao = new CommentDAO();
       for(BoardDTO board : list) { %>
       
<!-- ---------6. 게시글 한 줄 출력--------->    
		<tr>
			<td><%= board.getNum() %></td>
			<td><a href="view.jsp?num=<%= board.getNum() %>"> <%= board.getTitle() %>
			</a></td>
			<td><%= board.getWriter() %></td>
			<td><%= board.getRegDate() %></td>
			<td><%= board.getHit() %></td>

<!-- ----7. 댓글 수 조회------>    
			<td><%= cdao.getCommentCountByBoardNum(board.getNum()) %></td>
<!------삭제 ------>
			<td><a href="deletepro.jsp?num=<%=board.getNum()%>"
				onclick="return confirm('삭제하시겠습니까?');">삭제</a></td>
		</tr>
		
		<%   } 
       cdao.close();
   } else { %>
		<tr>
			<td colspan="7" align="center">게시글이 없습니다.</td>
		</tr>
		<% } %>

	</table>
<!------글쓰기 버튼 영역---->
	<br>
	<input type="button" value="글쓰기" onclick="location.href='write.jsp'">

	<!------페이지 계산 ---->
	<!--페이지 총 글자수 계산 1페이지에서 보여줄 갯수 확인-->
	
	
	<!-- 만약에 카운트가 0보다 크면   -->
<%
 // 만약에 카운트가 0보다 크면 
if (count > 0) {
	// 카운트 나누기 페이지 사이트 더하기 ( 카운트 나누기 페이지 사이즈 는 == 0 ? 0 : 1 );
	int pageCount = count / pageSize + ( count % pageSize == 0 ? 0 : 1);
	// 현재 페이지를 10으로 나눈 "페이지 그룹"을 구한 뒤
	// 해당 그룹의 시작 페이지 번호를 계산 (정수 나눗셈)
	int startPage = (int)(currentPage/10)*10+1;
	
	//페이지 블록 밑에 [1] << 이게 10개씩 보여준다는 의미에 선언문
	int pageBlock=10;
	// 마지막 페이지는 = 시작페이지 더하기 페이지블록(10)-1 그래서 시작페이지 1이라고 생각하면 엔드페이지 10임   
	int endPage = startPage + pageBlock-1;
	// 마지막 페이지가  크다 페이지 카운트 보다 
	if (endPage > pageCount){
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
		<a href="list.jsp?pageNum=<%= startPage - 10 %><%=pageReturn%>">[이전]</a>
		
<%
	}
	
	for (int i = startPage ; i <= endPage ; i++) {
%>
		<a href="list.jsp?pageNum=<%= i %><%=pageReturn%>">[<%= i %>]</a>
<%
	}
	if (endPage < pageCount) {
%>
		<a href="list.jsp?pageNum=<%= startPage + 10 %><%=pageReturn%>">[다음]</a>
<%
	}
}
%>
</body>
</html>