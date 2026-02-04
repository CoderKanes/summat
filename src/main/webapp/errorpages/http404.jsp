<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%--
    작성자 : 김용진
    내용 : Http 404Error 발생시 보여줄 에러페이지.
--%>
	
<!DOCTYPE html>
<html>
<head>
	<title>페이지 없음</title>
	<link href="/summat/resources/css/style.css" rel="stylesheet" />
	<link href="/summat/resources/css/error.css" rel="stylesheet" />
</head>

<body>
	<header>
		<!--☰
		<div class="search">검색바</div>
		<button class="theme-btn" onclick="location.href='/summat'">홈</button>-->
	</header>

	<div class="container">
		<main class="error-main">
			<div class="error-card">
				<div class="error-code">404 ERROR</div>

				<h2 class="error-title">
					요청하신 페이지를 찾을 수 없었습니다 🧭
				</h2>

				<p class="error-desc">
					주소가 잘못 입력되었거나 삭제된 페이지일 수 있어요.<br> 
					주소를 다시 확인해주세요.
				</p>

				<div class="error-actions">
					<button onclick="history.back()">이전 페이지</button>
					<button class="primary" onclick="location.href='/summat/sm/main.jsp'">
						홈으로 가기
					</button>
				</div>
			</div>
		</main>
	</div>
</body>
</html>
