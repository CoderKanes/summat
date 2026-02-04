<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%--
    작성자 : 김용진
    내용 : Http 500Error 발생시 보여줄 에러페이지.
--%>
	
<!DOCTYPE html>
<html>
<head>
	<title>500 - 서버 오류</title>
	<link href="/summat/resources/css/style.css" rel="stylesheet" />
	<link href="/summat/resources/css/error.css" rel="stylesheet" />
</head>

<body>
	<header>
		<!-- ☰
		<div class="search">검색바</div>
		<button class="theme-btn" onclick="location.href='/summat'">홈</button> -->
	</header>

	<div class="container">
		<main class="error-main">
			<div class="error-card">
				<div class="error-code">500</div>

				<h2 class="error-title">
					현재 요청하신 페이지는 점검 중입니다 🛠
				</h2>

				<p class="error-desc">
					서비스 안정화를 위해<br>
					잠시 점검을 진행하고 있어요.<br><br>
					조금만 기다렸다가 다시 이용해 주세요.
				</p>

				<div class="error-actions">
					<button onclick="location.reload()">새로고침</button>
					<button class="primary" onclick="location.href='/summat/sm/main.jsp'">
						홈으로
					</button>
				</div>
			</div>
		</main>
	</div>
</body>
</html>