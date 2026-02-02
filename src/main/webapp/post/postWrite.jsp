<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%--@ //include file="/common/header.jsp" --%> 
<%--@ include file="/common/nav.jsp" --%>

<link href="/summat/resources/css/style.css" rel="stylesheet" />
<link href="/summat/resources/css/post/postEdit.css" rel="stylesheet" />

<main class="post-edit-page">

    <div class="form-container">
        <h1 class="page-title">리뷰 포스트 작성</h1>

        <jsp:useBean id="dao" class="sm.data.PostDAO" />
        <%
            String user_id = "test";
        %>

        <form action="postWritePro.jsp" method="post" onsubmit="return beforeSubmit();">

            <label class="field-label">제목</label>
            <input type="text" name="title" class="input-title" required>

            <label class="field-label">내용</label>
            <div contenteditable="true" id="editor"><p>여기에 글을 작성하세요...<p></div>

            <input type="hidden" name="user_id" value="<%=user_id%>">
            <input type="hidden" name="thumbnailImage" id="thumbnailImage">
            <input type="hidden" name="content" id="content">

            <label class="field-label">이미지 선택</label>
            <input type="file" id="imageInput" multiple accept="image/*">

            <div class="form-actions">
                <button type="submit" class="theme-btn confirmbtn-minSize">작성완료</button>
                <a href="postMain.jsp" class="cancel-btn confirmbtn-minSize">작성취소</a>
            </div>
        </form>
    </div>
</main>

<script src="/summat/resources/js/post/postEdit.js" defer></script>
