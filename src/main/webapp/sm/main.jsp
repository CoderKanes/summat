<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>
	<title>맛집 페이지 테마 샘플</title>
	<link href="/summat/resources/css/style.css" style="text/css" rel="stylesheet" />
<% 	
	
	//로그인 여부 
	boolean isLogin = (session.getAttribute("sid") != null);
	//null 체그
	int grade = 1;
	
	if(session.getAttribute("grade") != null){
		grade = (Integer)session.getAttribute("grade");
	}

	//grade 저장
	/*
	int grade = 1;
	
	Object gradeObj = session.getAttribute("grade");
	if (gradeObj instanceof Integer) {
		grade = (Integer) gradeObj;
		// 필요시 0/1 이외의 값도 기본값으로 보정
		if (grade != 0 && grade != 1) {
		    grade = 1;
		}
	}
	*/
%>
</head>

<body>
	<header> 
		☰
		<div class="search">검색바</div>

		<!-- 헤더 글쓰기 -->
		<button class="icon-btn" onclick="writePost()">✏️</button>
		<!-- 로그인 여부에 따라 버튼 변경 -->
		<% if (isLogin) { %>  
			<% if (grade == 0) { %>  
				<button class="theme-btn" onclick="location.href='/summat/admin/memberList.jsp'">회원 관리</button>  
			<% } else if (grade == 1) { %>  
				<button class="theme-btn" onclick="location.href='/summat/user/mypage.jsp'">마이페이지</button>  
			<% } %>  
			<button class="theme-btn" onclick="location.href='/summat/user/logoutPro.jsp'">로그아웃</button>  
		<% } else { %>  
			<button class="theme-btn" onclick="login()">로그인</button>  
			<% } %> 
	</header>

	<div class="container">
		<aside>
			<h3>사이드 메뉴</h3>
			<p>카테고리</p>
			<p>지역</p>
			<p>가격대</p>

			<!-- 사이드 글쓰기 -->
			<div class="side-write" onclick="writePost()">✍ 리뷰 쓰기</div>
			
		</aside>

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
			<% for(int i = 0 ; i < 10; ++i) { %>
			<div class="card">
				<div class="image-box">
				<img src="/summat/resources/image/image00.jfif">
				</div>

				<div class="text-box">
					<h3>글 제목이 들어감</h3>
					<p>
						글 내용이 들어감 oooooooooooooooooooooooooo<br>
						ooooooooooooooooooooooooooooooooooooooooooo<br>
						ooooooooooooooooooooooooooooooooooooooooooo
					</p>
				</div>
			</div>
			<br />
			<br />
			<% } %>
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

main.addEventListener("scroll", () => {
  fab.style.display = main.scrollTop > 200 ? "flex" : "none";
});
</script>

</body>
</html>