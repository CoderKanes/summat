<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="sm.data.PostDAO" %>
<%@ page import="sm.data.PostDTO" %>
<%@ page import="sm.util.HTMLUtil" %>
<%@ page import="sm.data.PostQueryCondition" %>
<%@ page import="java.util.List" %>

<link href="/summat/resources/css/style.css" style="text/css" rel="stylesheet" />


<%	
	PostQueryCondition QrCondition= new PostQueryCondition();	
	String keyword = request.getParameter("keyword");
	
	if (keyword != null && !keyword.trim().isEmpty()) {
		QrCondition.setKeyword(keyword);
		String typeParam = request.getParameter("searchType");
		if (typeParam != null) {
		    try {
		    	QrCondition.setSearchType(PostQueryCondition.SearchType.valueOf(typeParam));
		    } catch (IllegalArgumentException e) {
		    	QrCondition.setSearchType(PostQueryCondition.SearchType.ALL);
		    }
		}
	}	
	String pageNum = request.getParameter("pageNum");
	int currentPage= pageNum!=null? Integer.parseInt(pageNum) : 1;	
	
	PostDAO dao = new PostDAO();
	int totalElementCount = dao.getPostListCount(QrCondition);
	int pageElementCount = 3; //한 페이지에 보여줄 글 수.
	int desiredPageCount = 7; //페이지Nav에 보여질 페이지버튼수	
	int startRow = (currentPage - 1) * pageElementCount + 1;
	int endRow = currentPage * pageElementCount;

	List<PostDTO> postList = dao.selectPostList(startRow, endRow, QrCondition);
	
%>	

<!-- HTML -->
<div class="container">
	<main id="mainContent">
<%
	if(postList != null)
	{
		for(PostDTO dto : postList)
		{		
			String dtoContentTextOnly = HTMLUtil.htmlContentToPlainText(dto.getContent(), false);
%>
			<a href="/summat/post/postView.jsp?postNum=<%=dto.getPostNum()%>"> 
				<div class="postcard" onclick="location.href='postView.jsp?postNum=<%=dto.getPostNum()%>';">
					<div class="postcard-imagebox">
						<img class="postcard-image" src="<%=dto.getThumbnailImage()%>">
					</div>
					<div class="postcard-textbox">
						<h3><%=dto.getTitle()%></h3>
						<p>
							<%=dtoContentTextOnly%>
						</p>
					</div>
				</div>
			</a><br />
<%			
		}
	}
%>
		<a href="/summat/post/postWrite.jsp"> 포스트 쓰기 </a>
<%
//calculate pageNav
		int LastPage = (int) Math.ceil(totalElementCount / (double) pageElementCount);
		int pageNav_PageCount = desiredPageCount;
		int pageNav_StartPage = Math.min(Math.max(currentPage - pageNav_PageCount / 2, 1), Math.max(LastPage - pageNav_PageCount + 1, 1));
		int pageNav_EndPage = Math.min(pageNav_StartPage + pageNav_PageCount - 1, LastPage);
		
		String pageUrl = request.getRequestURI() + "?";
		String queryString = request.getQueryString();

		if (queryString != null) {
			queryString = queryString.replaceAll("(&?pageNum=\\d+)", "");
			if (!queryString.isEmpty()) {
				pageUrl = request.getRequestURI() + "?" +queryString+ "&";
			}
		}		
		%><div class="paging-wrap" style="text-align: center"><%
		if (currentPage - 5 >= 1) {
		%><a href="<%=pageUrl%>pageNum=<%=currentPage-5%>">[<<] </a><%
		}
		if (currentPage > 1) {
		%><a href="<%=pageUrl%>pageNum=<%=currentPage-1%>">[<] </a><%
		}
		for (int i = pageNav_StartPage ; i <= pageNav_EndPage ; i++) {
			if(i == currentPage){
			%><a href="<%=pageUrl%>pageNum=<%= i %>"><font color="#b84a4a">[<%= i %>]</font></a>	<%
			}else{
			%><a href="<%=pageUrl%>pageNum=<%= i %>">[<%= i %>]</a>	<%
			}
		}
		if (currentPage < LastPage) {
			%><a href="<%=pageUrl%>pageNum=<%=currentPage+1%>"> [>]</a><%
		}
		if (currentPage+5 <= LastPage) {
			%><a href="<%=pageUrl%>pageNum=<%=currentPage+5%>"> [>>]</a><%
		}
		%></div><%
%>
	</main>
</div>