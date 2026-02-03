<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 프리뷰 게시글 작성된 글 을 클릭했을때 보는 화면  -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신청 미리보기</title>

<style>
body { margin:0; overflow:hidden; }
.slider {
    display:flex;
    width:100vw;
    height:100vh;
    transition:transform 0.5s ease;
}
.slide {
    min-width:100vw;
    height:100vh;
}
.slide img {
    width:100%;
    height:100%;
    object-fit:cover;
}
</style>
</head>

<body>

<%
    String base64Image = (String) request.getAttribute("base64Image");
%>

<div class="slider" id="slider">
    <div class="slide">
        <% if (base64Image != null && !base64Image.isEmpty()) { %>
            <img src="data:image/jpeg;base64,<%= base64Image %>">
        <% } else { %>
            <p>이미지가 없습니다.</p>
        <% } %>
    </div>
</div>

</body>
</html>
