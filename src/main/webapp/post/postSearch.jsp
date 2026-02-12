<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%--
    작성자 : 김용진
    내용 : 키워드 검색하여 Post List를 보여주는 페이지.
--%>

<%		
	String keyword = request.getParameter("keyword");
	
	if (keyword == null ) {
		keyword="";
	}
	
	String searchType = request.getParameter("searchType");

%>

<link href="/summat/resources/css/style.css" rel="stylesheet" />
<link href="/summat/resources/css/post/postSearch.css" rel="stylesheet" />

<div class="search-card">
    <form action="<%=request.getRequestURI()%>" method="get" class="search-form">
        <label class="search-label">검색</label>	
		<select name="searchType" class="select-base">
			<option value="ALL" <%="ALL".equals(searchType)? "selected" : ""%>>제목+내용</option>
			<option value="TITLE" <%="TITLE".equals(searchType)? "selected" : ""%>>제목</option>
			<option value="CONTENT" <%="CONTENT".equals(searchType)? "selected" : ""%>>내용</option>
			<option>작성자</option>
			<option>댓글</option>
			</select> 
			<input type="search" name="keyword" class="input-base" value="<%=keyword%>"/>
			<input type="submit" value="검색" />
	</form>
</div>

<%		
	if (keyword != null && !keyword.trim().isEmpty()) {		
		%>
		<h2 class="page-title">
			'<span class="text-point"><%=keyword%></span>' 검색 결과
		</h2>
	<%
	}
%>

<jsp:include page="postList.jsp" />	 