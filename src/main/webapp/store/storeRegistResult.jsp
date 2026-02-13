<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<link href="/summat/resources/css/style.css" rel="stylesheet" />
<link href="/summat/resources/css/error.css" rel="stylesheet" />
<%	
	String result = request.getParameter("resultStroeId");
	int resultStroeId = result!=null?Integer.parseInt(result) : -1;
%>
<div class="container">
		<main class="error-main">
			<div class="error-card">
				<div class="error-code"></div>

				<h2 class="error-title">
					가게 등록 신청 결과  
				</h2>

				<p class="error-desc">
					<%if(resultStroeId == -1){%>
						등록실패. 나중에 다시시도해 주세요.
					<%}else{%>
						등록완료. 관리자 승인후 게재됩니다.
					<%}%>
				</p>

				<div class="error-actions">
					<button onclick="location.href='/summat/user/mypage.jsp'">마이 페이지</button>
					<button class="primary" onclick="location.href='/summat/main/main.jsp'">홈으로 가기	</button>
				</div>
			</div>
		</main>
	</div>
		