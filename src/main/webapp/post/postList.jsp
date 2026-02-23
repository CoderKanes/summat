<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="sm.data.PostDAO" %>
<%@ page import="sm.data.PostDTO" %>
<%@ page import="sm.util.HTMLUtil" %>
<%@ page import="sm.data.PostQueryCondition" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.net.URLDecoder" %>

<%--
    작성자 : 김용진
    내용 : PostList를 얻어와 출력하는 페이지. 
    	paging 값이나 검색관련 param이 있으면 그에 맞게 list를 구성
--%>

<link href="/summat/resources/css/style.css" style="text/css" rel="stylesheet" />


<%	
	PostQueryCondition QrCondition= new PostQueryCondition();
	String encodeKeyword = request.getParameter("encodeKeyword");
	String keyword = request.getParameter("keyword");
	
	if(encodeKeyword!=null){
		keyword = URLDecoder.decode(encodeKeyword, "UTF-8");	
	}
	
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
	String MenuIdParam = request.getParameter("MenuId");
	if(MenuIdParam != null)	{
		QrCondition.setByMenuId(Integer.parseInt(MenuIdParam));
	}
	
	String StoreIdParam = request.getParameter("StoreId");
	if(StoreIdParam != null)	{
		QrCondition.setByStoreId(Integer.parseInt(StoreIdParam));
	}
	
	
	String[] roleStrings = request.getParameterValues("userRole");
	if (roleStrings != null && roleStrings.length > 0) {
	    List<PostQueryCondition.UserRole> roleList = Arrays.stream(roleStrings)
	                                    .map(PostQueryCondition.UserRole::valueOf)
	                                    .collect(Collectors.toList());
	    QrCondition.setUserRoleFilters(roleList);
	}
	
	String pageNum = request.getParameter("pageNum");
	int currentPage= pageNum!=null? Integer.parseInt(pageNum) : 1;	
	
	PostDAO dao = new PostDAO();
	int totalElementCount = dao.getPostListCount(QrCondition);
	int pageElementCount = 3; //한 페이지에 보여줄 글 수.
	if(request.getParameter("pagePostCount")!=null)
	{
		pageElementCount =  Integer.parseInt(request.getParameter("pagePostCount"));		
	}
	int desiredPageCount = 7; //페이지Nav에 보여질 페이지버튼수	
	int startRow = (currentPage - 1) * pageElementCount + 1;
	int endRow = currentPage * pageElementCount;
	
	String orderParam = request.getParameter("postListOrderType");
	if (orderParam != null && !orderParam.isEmpty()) {
	    try {	     
	        PostQueryCondition.OrderType type = PostQueryCondition.OrderType.valueOf(orderParam);
	        QrCondition.setOrderType(type);
	    } catch (IllegalArgumentException e) {
	        System.out.println("잘못된 정렬 타입입니다: " + orderParam);
	    }
	}

	List<PostDTO> postList = dao.selectPostList(startRow, endRow, QrCondition);
	
    Boolean isAuth = null;
  	if (session != null) {
      	Object authAttr = session.getAttribute("authenticated");
      	isAuth = (authAttr instanceof Boolean) ? (Boolean) authAttr : null;
  	}
  	
  	String sid= (String)session.getAttribute("sid");
	
	//param option
	boolean bShowWriteBtn = request.getParameter("showWriteBtn")!=null? Boolean.parseBoolean(request.getParameter("showWriteBtn")) : true;
	boolean bShowPageNavi = request.getParameter("showPageNavi")!=null? Boolean.parseBoolean(request.getParameter("showPageNavi")) : true;
	
%>	
<style>
.container {
	height: calc(100vh - 275px); /* header + nav + search */
}

.postcard {
  display: flex;
  gap: 16px;
  padding: 3px;
  background: #ffffff;
  border-radius: 14px;
  margin-bottom: 12px;
  text-decoration: none;
  color: inherit;
  box-shadow: 0 6px 18px rgba(0,0,0,0.05);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.postcard:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 24px rgba(0,0,0,0.08);
}

/* 이미지 */

.postcard-imagebox {
  width: 140px;
  height: 140px;
  flex-shrink: 0;
}

.postcard-image {
  width: 100%;
  height: 100%;
  border-radius: 12px;
  object-fit: cover;
}

/* 텍스트 영역 */

.postcard-textbox {
  flex: 1;
  position: relative;
}

/* 제목 */

.postcard-title {
  font-size: 18px;
  font-weight: 600;
  color: #2b2b2b;
  margin-bottom: 6px;
}

/* 본문 */

.postcard-desc {
  font-size: 14px;
  color: #6f6f6f;
  line-height: 1.5;
  margin-bottom: 20px;
}

/* 조회수 + 날짜 */

.postcard-meta {
  position: absolute;
  right: 0;
  bottom: 0;
  font-size: 12px;
  color: #9a9a9a;
}

/* 링크 기본 스타일 제거 */

.postcard:link,
.postcard:visited {
  text-decoration: none;
  color: inherit;
}

.postcard:hover .postcard-title {
  color: var(--point); /* 테마 포인트 색 */
}

.write-post-btn {
  display: inline-block;
  margin: 20px 0;
  padding: 10px 18px;
  border-radius: 999px;
  background: var(--point);
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  text-decoration: none;
  box-shadow: 0 4px 10px rgba(0,0,0,0.15);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.write-post-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 18px rgba(0,0,0,0.2);
}

.paging-wrap {
  margin: 30px 0;
  text-align: center;
}

.paging-wrap a {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  margin: 0 4px;
  border-radius: 50%;
  background: #fff;
  color: #555;
  font-size: 13px;
  text-decoration: none;
  box-shadow: 0 3px 8px rgba(0,0,0,0.08);
  transition: all 0.2s ease;
}

.paging-wrap a:hover {
  background: var(--point);
  color: #fff;
}

/* 현재 페이지 */
.paging-wrap font {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: var(--point);
  color: #fff !important;
  font-size: 13px;
  font-weight: 600;
  box-shadow: 0 4px 10px rgba(0,0,0,0.15);
}
.post-bottom-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: 30px 0;
}


.post-bottom-bar {
  position: relative;       /* 기준점 */
  margin: 1px 0;
  min-height: 40px;
}

/* 글쓰기 버튼 */
.write-post-btn {
  position: relative;
  z-index: 1;
}

/* 페이징을 항상 중앙에 */
.paging-wrap {
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
}
</style>
<!-- HTML -->
<div class="container">
	<main id="mainContent" style="padding-top: 5px;" >
<%
	if(postList != null && postList.size()>0)
	{
		for(PostDTO dto : postList)
		{		
			String dtoContentTextOnly = HTMLUtil.htmlContentToPlainText(dto.getContent(), false);
%>
			<a class="postcard"
			   href="/summat/post/postView.jsp?postNum=<%=dto.getPostNum()%>&pageNum=<%=currentPage%>">
			
			    <div class="postcard-imagebox">
			        <img class="postcard-image"
			             src="<%=dto.getThumbnailImage()%>"
			             onerror="this.style.display='none';">
			    </div>
			
			    <div class="postcard-textbox">
			        <h3 class="postcard-title">
			            <%=dto.getTitle()%>
			        </h3>
			
			        <p class="postcard-desc">
			            <%=dtoContentTextOnly%>
			        </p>
			
			        <div class="postcard-meta">
			            조회수 <%=dto.getViewCount()%> · <%=dto.getCreated_at()%> 
			        </div>
			    </div>
			
			</a>
<%			
		}
	}else{	%>
	
	<h3>검색 결과가 없습니다.</h3>
	<%} %>


	<div class="post-bottom-bar">
<%
	if(bShowPageNavi){
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
		%><a href="<%=pageUrl%>pageNum=<%=currentPage-5%>"><< </a><%
		}
		if (currentPage > 1) {
		%><a href="<%=pageUrl%>pageNum=<%=currentPage-1%>">< </a><%
		}
		for (int i = pageNav_StartPage ; i <= pageNav_EndPage ; i++) {
			if(i == currentPage){
			%><a href="<%=pageUrl%>pageNum=<%= i %>"><font color="#b84a4a"><%= i %></font></a>	<%
			}else{
			%><a href="<%=pageUrl%>pageNum=<%= i %>"><%= i %></a>	<%
			}
		}
		if (currentPage < LastPage) {
			%><a href="<%=pageUrl%>pageNum=<%=currentPage+1%>"> ></a><%
		}
		if (currentPage+5 <= LastPage) {
			%><a href="<%=pageUrl%>pageNum=<%=currentPage+5%>"> >></a><%
		}
		%></div>
	<%} %>		
		<% if(bShowWriteBtn && !(isAuth == null || sid==null || sid.isEmpty())){%>
		<a href="/summat/post/postWrite.jsp" class="write-post-btn">
		  ✏️ 포스트 쓰기
		</a>
		<%} %>	
	</div>
	</main>
</div>