<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.Cookie" %>
<%--
    작성자 : 김용진, 김동욱
    내용 : 메인페이지. 기본적인 진입방식으로 접근했을때 가장 처음 보여줄 페이지. 
    	  저장된 쿠키를 불러와 자동 로그인.
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>맛집 페이지 테마 샘플</title>
	<link href="/summat/resources/css/style.css" style="text/css" rel="stylesheet" />

</head>

<body>
	<jsp:include page="topBar.jsp"></jsp:include>

	<div class="container">
		<main id="mainContent">
			<div class="filter">필터링 및 카테고리 숏컷</div>

			<div class="cards">
				<div class="card">추천</div>
				<div class="card">인기</div>
				<div class="card">이벤트</div>
			</div>

			<div class="banner">뭔가 뭔가 배너</div>

			<!-- 리스트 -->
			<h2>최신 포스트</h2>
			<jsp:include page="/post/postList.jsp" />	 
			<br />
		</main>
	</div>

	<!-- 플로팅 버튼 -->
	<div class="fab" id="fab" onclick="writePost()">✏️</div>

	<script>
/* ===== THEME ===== */
const themes = [
  { header:"#4E342E", side:"#FAF7F2", main:"#F3EFEA", card:"#FFFFFF", point:"#FF8A00" },
  { header:"#5C6D63", side:"#F3EFEA", main:"#EAEDE9", card:"#FFFFFF", point:"#D4A017" },
  { header:"#8C1D18", side:"#F7F7F7", main:"#EFEFEF", card:"#FFFFFF", point:"#C62828" },
  { header:"#1F2A44", side:"#FFFFFF", main:"#F2F4F8", card:"#FFFFFF", point:"#4A6CF7" }
];

let current = 0;
function changeTheme() {
  current = (current + 1) % themes.length;
  const t = themes[current];
  document.documentElement.style.setProperty('--header-bg', t.header);
  document.documentElement.style.setProperty('--side-bg', t.side);
  document.documentElement.style.setProperty('--main-bg', t.main);
  document.documentElement.style.setProperty('--card-bg', t.card);
  document.documentElement.style.setProperty('--point', t.point);
}

/* ===== BUTTON ACTION ===== */

function writePost() {
  alert("리뷰 작성 페이지로 이동 (임시)");
}
function login() {
  location.href="/summat/user/loginForm.jsp";
}

/* ===== FLOATING BUTTON LOGIC ===== */
const main = document.getElementById("mainContent");
const fab = document.getElementById("fab");
if (main && fab) {
    main.addEventListener("scroll", () => {
      fab.style.display = main.scrollTop > 200 ? "flex" : "none";
    });
}
</script>

</body>
</html>