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
<style>
.search-card {
	width: 400px;
    padding: 16px 20px;
    margin-bottom: 24px;
    align-items: center;
}

.search-form {
    display: flex;
    align-items: center;
    gap: 12px;
}

.search-label {
    font-weight: bold;
    color: #333;
}

.search-form select,
.search-form input[type="search"] {
    padding: 8px 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
    font-size: 14px;
}

.search-form input[type="search"] {
    flex: 1;
}

.search-form button {
    background: var(--point);
    color: #fff;
    border: none;
    padding: 8px 14px;
    border-radius: 6px;
    cursor: pointer;
}

</style>

<div class="search-card">
    <form action="<%=request.getRequestURI()%>" method="get" class="search-form">
        <label class="search-label">검색</label>	
		<select name="searchType" style="margin-left:10px;">
			<option value="ALL" <%="ALL".equals(searchType)? "selected" : ""%>>제목+내용</option>
			<option value="TITLE" <%="TITLE".equals(searchType)? "selected" : ""%>>제목</option>
			<option value="CONTENT" <%="CONTENT".equals(searchType)? "selected" : ""%>>내용</option>
			<option>작성자</option>
			<option>댓글</option>
			</select> 
			<input type="search" name="keyword" value="<%=keyword%>"/>
			<input type="submit" value="doSearch" />
	</form>
</div>

<%		
	if (keyword != null && !keyword.trim().isEmpty()) {		
		%>
		<h2 style="margin: 16px 0;">
			'<span style="color: var(--point)"><%=keyword%></span>' 검색 결과
		</h2>
	<%
	}
%>

<jsp:include page="postList.jsp" />	 