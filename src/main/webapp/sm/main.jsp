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
	<link href="/summat/resources/css/style.css" rel="stylesheet" />
	<link href="/summat/resources/css/sm/main.css" rel="stylesheet" />
<%
	int grade = 1;
	// 세션에 grade가 있으면 안전하게 읽기
	if (session != null && session.getAttribute("grade") != null) {
        try {
            Object gObj = session.getAttribute("grade");
            if (gObj instanceof Integer) grade = (Integer) gObj;
            else grade = Integer.parseInt(String.valueOf(gObj));
        } catch (Exception e) {
            grade = 1;
        }
	}

	Boolean isAuth = null;
	if (session != null) {
    	Object authAttr = session.getAttribute("authenticated");
    	isAuth = (authAttr instanceof Boolean) ? (Boolean) authAttr : null;
	}

	// 자동 로그인 시도 (세션에 인증정보가 없을 때만)
	if (isAuth == null || !isAuth) {
    	Cookie[] cookies = request.getCookies();
    	String rememberToken = null;
    	String gradeCookieValue = null;

    	if (cookies != null) {
        	for (Cookie c : cookies) {
        		if ("rememberMe".equals(c.getName())) {
                	rememberToken = c.getValue();
                } else if ("userGrade".equals(c.getName())) {
                	gradeCookieValue = c.getValue();
                }
                // 주의: break 제거 — 모든 관련 쿠키를 읽도록 함
        	}
    	}

    	// remember 토큰으로 세션 복원 시도
    	if (rememberToken != null) {
        	String[] parts = rememberToken.split("\\|", 2);
        	if (parts.length == 2) {
            	String userId = parts[0];
            	if (userId != null && !userId.trim().isEmpty() && !"null".equalsIgnoreCase(userId.trim())) {
                	HttpSession newSession = request.getSession(true);
                	newSession.setAttribute("sid", userId);
                	newSession.setAttribute("authenticated", true);
                	newSession.setMaxInactiveInterval(30 * 60); // 30분
                	isAuth = true;
            	}
        	}
    	}

    	// grade 쿠키 값이 있으면 안전하게 파싱하여 세션에 저장
    	if (gradeCookieValue != null) {
        	try {
            	int parsed = Integer.parseInt(gradeCookieValue);
            	grade = parsed;
            	HttpSession s = request.getSession(true);
            	s.setAttribute("grade", grade);
        	} catch (NumberFormatException nfe) {
            	// parsing 실패하면 기본값 유지
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
			<a href="/summat/food/foodMain.jsp" class="top-nav-link"><li>음식정보</li></a>
			<a href="/summat/post/postMain.jsp" class="top-nav-link"><li>포스트</li></a>
			<a href="/summat/board/list.jsp" class="top-nav-link"><li>커뮤니티</li></a>
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
if (main && fab) {
    main.addEventListener("scroll", () => {
      fab.style.display = main.scrollTop > 200 ? "flex" : "none";
    });
}
</script>

</body>
</html>