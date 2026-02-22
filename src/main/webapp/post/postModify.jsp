<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>

<%--
    작성자 : 김용진
    내용 : 작성한 Post 수정페이지.
--%>
<jsp:useBean id="dao" class="sm.data.PostDAO" />
<jsp:useBean id="dto" class="sm.data.PostDTO" />
<% 		
	int postNum = -1;
	if(request.getParameter("postNum") !=null){
		postNum = Integer.parseInt(request.getParameter("postNum"));
		dto = dao.selectPost(postNum);
	}else{
		//잘못된 요청
	}

	String pageNumParam = request.getParameter("pageNum");
	String user_id = dto.getUser_id();

	Integer existingStoreId = dao.getStoreIdByPost(postNum);
	Integer[] existingMenus = null;
	List<Integer> menuIds = dao.getMenusByPost(postNum);
	if(menuIds.size()>0){
 		existingMenus = menuIds.toArray(Integer[]::new);
	}
	
	String menusString = "";
    if (existingMenus != null && existingMenus.length > 0) {
        // Stream을 이용해 각 Integer를 String으로 변환 후 ","로 연결
        menusString = java.util.Arrays.stream(existingMenus)
                                    .map(String::valueOf)
                                    .collect(java.util.stream.Collectors.joining(","));
    }

%>
<link href="/summat/resources/css/style.css" rel="stylesheet" />
<link href="/summat/resources/css/post/postEdit.css" rel="stylesheet" />

<script>
document.addEventListener('DOMContentLoaded', function() {
    const oldStoreId = "<%= existingStoreId %>";     
	const oldMenus = [<%= menusString %>];
    if (oldStoreId && window.selectStore) {
        window.selectStore(oldStoreId, oldMenus);
    }	
});
</script>

<jsp:include page="/main/topBar.jsp">
	<jsp:param  name="showSearch" value="false"/>
	<jsp:param  name="showRightBtns" value="false"/>
	<jsp:param  name="showNaviMenu" value="false"/>
</jsp:include>

<main class="post-edit-page">
    <div class="form-container">
		<h1 class="page-title">포스트 수정</h1>			
		<form id="writeForm" action="postModifyPro.jsp" method="post" onsubmit="return beforeSubmit();">   
		    <label class="field-label">제목</label>
		    <input type="text" name="title" class="input-title" value="<%=dto.getTitle()%>" required>
		
			<label class="field-label">내용</label>
		    <div contenteditable="true" id="editor"><p><%=dto.getContent()%></p></div>
		    <input type="hidden" name="postNum" value="<%=postNum%>">
		    <input type="hidden" name="pageNum" value="<%=pageNumParam%>">
		    <input type="hidden" name="user_id" value="<%=user_id%>">
		    <input type="hidden" name="thumbnailImage" id="thumbnailImage" value="<%=dto.getThumbnailImage()%>">
		    <input type="hidden" name="content" id="content">
		
		    <label class="field-label">이미지 선택</label>
		    <input type="file" id="imageInput" multiple accept="image/*">
		    
		    <label class="field-label">방문 가게/메뉴 등록</label>
			<div class="store-search-row"> 
			    <input type="button" id="findStoreBtn" value="매장찾기">
			    <div id="resultDisplay"></div> 
			</div>
			
			<div class="form-actions">
                <button type="submit" class="theme-btn confirmbtn-minSize">수정완료</button>
                <a href="postView.jsp?postNum=<%=postNum%>&pageNum=<%=pageNumParam%>" class="cancel-btn confirmbtn-minSize">수정취소</a>
            </div>
		</form>
	</div>
</main>
		
<script src="/summat/resources/js/post/postEdit.js" defer></script>
