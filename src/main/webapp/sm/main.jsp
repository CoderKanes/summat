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
<%
	int grade = 1;
	//grade null 체그
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

	Boolean isAuth = null;
	if (session != null) {
    	Object authAttr = session.getAttribute("authenticated");
    	isAuth = (authAttr instanceof Boolean) ? (Boolean) authAttr : null;
	}

	// 이미 로그인 상태면 그냥 진행
	if (isAuth == null || !isAuth) {
    	// remember-me 쿠키 확인 및 재생성 시도
    	Cookie[] cookies = request.getCookies();
    	if (cookies != null) {
        	for (Cookie c : cookies) {
           		
        		if ("rememberMe".equals(c.getName())) {
                	String token = c.getValue();
                	String[] parts = token != null ? token.split("\\|", 2) : null;
                	if (parts != null && parts.length == 2) {
                    	String userId = parts[0];
                    	
                    	//userId로 세션 재생성
                    	HttpSession newSession = request.getSession(true);
                    	newSession.setAttribute("sid", userId);
                    	newSession.setAttribute("authenticated", true);
                    	newSession.setMaxInactiveInterval(30 * 60); // 30분
                    	// 재생성 후 isAuth를 true로 설정하여 아래 컨텐츠 흐름에 영향 주지 않게 함
                    	isAuth = true;
                    	//쿠키 새 새션에서 재생성
                    	
                    	
                    	
                	}
                	
            	}
        		
        		if("userGrade".equals(c.getName())){
        			grade = Integer.parseInt(c.getValue()); 
        			HttpSession newSession = request.getSession(true);
        			newSession.setAttribute("grade", grade);
        			
        			
        		}
        		break;
        	}
    	}
	}
        		
	// 이후 페이지 로직에서 isAuth 값을 사용
	if (isAuth == null) {
    	isAuth = false;
	}
		
%>


</head>

<body>
	<header> 
		☰
		<div class="search">검색바</div>

		<!-- 헤더 글쓰기 -->
		<button class="icon-btn" onclick="writePost()">✏️</button>
		<!-- 로그인 여부에 따라 버튼 변경 -->
		<% if (isAuth) { %>  
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
	<nav class="top-nav">
		<ul>
			<li class="active">홈</li>
			<li>음식정보</li>
			<a href="/summat/post/postMain.jsp" style="text-decoration: none;"><li>포스트</li></a>
			<a href="/summat/sm/board/list.jsp" style="text-decoration: none;"><li>커뮤니티</li></a>
		</ul>
	</nav>

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

main.addEventListener("scroll", () => {
  fab.style.display = main.scrollTop > 200 ? "flex" : "none";
});
</script>

</body>
</html>