<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%--
    작성자 : 김동욱
    내용 : 회원 탈퇴 관련 비밀번호 확인 후 탈퇴를 진행시킴. 데이터 단에서 삭제하는 것이 아닌
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
			<form id="deleteForm" action="deletePro.jsp" method="post">
				<label for="password_hash">비밀번호 입력 : </label>
				<input type="password" id="password_hash" name="password" required="required"/>
				<input type="hidden" id="user_id" name="user_id" value="<%=user_id %>"/>
				
				<div class="btn-row">
					<button type="submit" class="btn-primary">탈퇴</button>
	          		<button type="button" class="btn-secondary" onclick="location.href='mypage.jsp'">취소</button>
				</div>
				
			</form>
		</section>
	</div>
	
<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function () {
  var deleteForm = document.getElementById('deleteForm');
  if (!deleteForm) return;

  deleteForm.addEventListener('submit', function (e) {
    // 비밀번호 입력 확인 (추가적인 클라이언트 검사)
    var pwInput = document.getElementById('password_hash');
    if (!pwInput || pwInput.value.trim().length === 0) {
      e.preventDefault();
      alert('비밀번호를 입력하세요.');
      if (pwInput) pwInput.focus();
      return;
    }

    // 최종 확인
    var ok = confirm('정말로 탈퇴하시겠습니까? 탈퇴 시 계정 정보가 삭제됩니다.');
    if (!ok) {
      e.preventDefault();
      return;
    }

    // 확인 시 중복 제출 방지(버튼 비활성화)
    var submitBtns = deleteForm.querySelectorAll('[type="submit"]');
    submitBtns.forEach(function(b){
      b.disabled = true;
      b.textContent = '처리중...';
    });

    // 제출 계속 진행 (서버에서 반드시 비밀번호 및 권한 검증)
  });
});
</script>

</body>
</html>