<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<link href="/summat/resources/css/style.css" rel="stylesheet" />
<link href="/summat/resources/css/post/postEdit.css" rel="stylesheet" />

<main class="post-edit-page">

    <div class="form-container">
		<h1 class="page-title">포스트 수정</h1>
		
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
			
			String user_id = dto.getUser_id();
		%>
		
		<form action="postModifyPro.jsp" method="post" onsubmit="return beforeSubmit();">   
		    <label class="field-label">제목</label>
		    <input type="text" name="title" class="input-title" value="<%=dto.getTitle()%>" required>
		
			<label class="field-label">내용</label>
		    <div contenteditable="true" id="editor"><p><%=dto.getContent()%></p></div>
		    <input type="hidden" name="postNum" value="<%=postNum%>">
		    <input type="hidden" name="user_id" value="<%=user_id%>">
		    <input type="hidden" name="thumbnailImage" id="thumbnailImage" value="<%=dto.getThumbnailImage()%>">
		    <input type="hidden" name="content" id="content">
		
		    <label class="field-label">이미지 선택</label>
		    <input type="file" id="imageInput" multiple accept="image/*">
			
			<div class="form-actions">
                <button type="submit" class="theme-btn confirmbtn-minSize">수정완료</button>
                <a href="postMain.jsp" class="cancel-btn confirmbtn-minSize">수정취소</a>
            </div>
		</form>
	</div>
</main>
		
<script src="/summat/resources/js/post/postEdit.js" defer></script>