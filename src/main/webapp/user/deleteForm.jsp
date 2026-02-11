<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%--
    작성자 : 김동욱
    내용 : 회원 탈퇴 관련 비밀번호 확인 후 탈퇴를 진행시킴. 데이터 단에서 삭제하는 것이 하닌 
    상태를 변화시키는 형태임.
--%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴 - 확인</title>
<link rel="stylesheet" href="/summat/resources/css/user/deleteConfirm.css">
</head>
<body>	
<%
	//세션에서 아이디 꺼내고
	String user_id = (String)session.getAttribute("sid");
	//아이디 값 없으면 로그인시키고
	if(user_id == null){
		response.sendRedirect("/summat/user/loginForm.jsp");
		return;
	}	
%>
	
	<div class="contaner">
		<section>
			<h2>회원 탈퇴 확인</h2>
			<!-- 비번 입력 -->
			<form action="deletePro.jsp" method="post">
				<label for="password_hash">비밀번호 입력 : </label>
				<input type="password" id="password_hash" name="password" required="required"/>
				<input type="hidden" id="user_id" name="user_id" value="<%=user_id %>"/>
				
				<div class="btn-row">
					<button type="submit" class="btn-primary">탈퇴</button>
	          		<button type="button" class="btn-secondary" onclick="location.href='/summat/sm/main.jsp'">취소</button>
				</div>
				
			</form>
		</section>
	</div>
	
	<script src="/summat/resources/js/user/deleteConfirm.js"></script>
</body>
</html>