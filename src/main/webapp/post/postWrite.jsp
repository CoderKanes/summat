<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.StoreDAO"%>
<%@ page import="sm.data.StoreDTO"%>
<%@ page import="sm.data.MenuDAO"%>
<%@ page import="sm.data.MenuDTO"%>
    
<%--
    작성자 : 김용진
    내용 : Post를 작성하는 페이지.
--%>

<%--@ //include file="/common/header.jsp" --%> 
<%--@ include file="/common/nav.jsp" --%>

<link href="/summat/resources/css/style.css" rel="stylesheet" />
<link href="/summat/resources/css/post/postEdit.css" rel="stylesheet" />

<jsp:include page="/main/topBar.jsp">
	<jsp:param  name="showSearch" value="false"/>
	<jsp:param  name="showRightBtns" value="false"/>
	<jsp:param  name="showNaviMenu" value="false"/>
</jsp:include>

<main class="post-edit-page">

    <div class="form-container">
        <h1 class="page-title">리뷰 포스트 작성</h1>

        <jsp:useBean id="dao" class="sm.data.PostDAO" />
        <%
	        Boolean isAuth = null;
	    	if (session != null) {
	        	Object authAttr = session.getAttribute("authenticated");
	        	isAuth = (authAttr instanceof Boolean) ? (Boolean) authAttr : null;
	    	}
	    	
	    	String sid= (String)session.getAttribute("sid");
            String user_id = sid;
        %>

        <form id="writeForm" action="postWritePro.jsp" method="post" onsubmit="return beforeSubmit();">

            <label class="field-label">제목</label>
            <input type="text" name="title" class="input-title" required>

            <label class="field-label">내용</label>
            <div contenteditable="true" id="editor"><p>여기에 글을 작성하세요...<p></div>

            <input type="hidden" name="user_id" value="<%=user_id%>">
            <input type="hidden" name="thumbnailImage" id="thumbnailImage">
            <input type="hidden" name="content" id="content">

            <label class="field-label">이미지 선택</label>
            <input type="file" id="imageInput" multiple accept="image/*">
            
            <label class="field-label">방문 가게/메뉴 등록</label>
			<div class="store-search-row"> 
			    <input type="button" id="findStoreBtn" value="매장찾기">
			    <div id="resultDisplay"></div> 
			</div>

            <div class="form-actions">
                <button type="submit" class="theme-btn confirmbtn-minSize">작성완료</button>
                <a href="postMain.jsp" class="cancel-btn confirmbtn-minSize">작성취소</a>
            </div>
        </form>
    </div>
</main>

<script src="/summat/resources/js/post/postEdit.js" defer></script>
