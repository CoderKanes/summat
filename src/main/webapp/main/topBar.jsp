<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<link href="/summat/resources/css/style.css" style="text/css" rel="stylesheet" />
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
        <li class="nav-item"><a href="/summat/sm/main.jsp">홈</a></li>
        <li class="nav-item"><a href="/summat/food/foodMain.jsp">음식정보</a></li>
        <li class="nav-item"><a href="/summat/post/postMain.jsp">포스트</a></li>
        <li class="nav-item"><a href="/summat/board/list.jsp">커뮤니티</a></li>
    </ul>
</nav>

<script>
  window.addEventListener('DOMContentLoaded', () => {
    const currentPath = window.location.pathname;
    const navItems = document.querySelectorAll('.top-nav li');

    navItems.forEach(li => {
      const link = li.querySelector('a');
      if (link) {
        const href = link.getAttribute('href');
        // 현재 경로가 href로 시작하거나 포함되면 active 추가
        if (currentPath === href || (href !== '/summat/sm/main.jsp' && currentPath.includes(href))) {
          li.classList.add('active');
        } else {
          li.classList.remove('active');
        }
      }
    });
  });
</script>