<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴 - 확인</title>
<style type="text/css">
  body {
    font-family: Arial, sans-serif;
    background: #f1efe7;
    margin: 0;
  }

  .container {
    width: 860px; /* 폭 축소 */
    margin: 40px auto;
    display: grid;
    grid-template-columns: 1fr;
    gap: 16px;
  }

  .card {
    background: #fff;
    border-radius: 12px;
    padding: 16px; /* 내부 여백 축소 */
    box-shadow: 0 2px 6px rgba(0,0,0,.05);
  }

  h2 {
    font-size: 16px; /* 제목 크기 축소 */
    margin: 0 0 8px;
  }

  /* 폼: 라벨 fixed, 입력 필드 width를 컨테이너에 맞춤, 간격 축소 */
  form {
  display: grid;
  grid-template-columns: 120px 1fr; /* 라벨을 더 좁게, 입력창은 남은 공간만 사용 */
  align-items: center;
  gap: 8px 12px;
  margin-bottom: 8px;
}

  label {
    font-size: 13px; /* 라벨 크기 축소 */
    text-align: right;
    padding-right: 6px;
  }

  input[type="password"] {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 13px;
  width: 100%;       /* 컨테이너 폭에 맞춰 꽉 채움 */
  max-width: 340px;  /* 너무 길지 않게 제한 */
/*  예: 최대 너비를 340px로 제한하면 화면이 커져도 입력 창이 길게 늘어나지 않음 */
  box-sizing: border-box;
}

  .btn-row {
    grid-column: 2;
    display: flex;
    gap: 8px; /* 간격 축소 */
    align-items: center;
  }

  button {
    padding: 8px 12px; /* 버튼 크기 축소 */
    border: none;
    border-radius: 6px;
    font-weight: 600;
    cursor: pointer;
  }

  .btn-primary {
    background: #f59e0b;
    color: #fff;
  }

  .btn-secondary {
    background: #e5e7eb;
    color: #111;
  }

  @media (max-width: 720px) {
    .container { width: auto; padding: 0 12px; }
    form { grid-template-columns: 1fr; }
    label { text-align: left; padding-right: 0; }
    .btn-row { grid-column: 1; justify-content: flex-start; }
  }
</style>
</head>
<body>	
<%
	//세션에서 아이디 꺼내고
	String user_id = (String)session.getAttribute("sid");
	//아이디 값 없으면 로그인시키고
	if(user_id == null){
		response.sendRedirect("/summat/sm/loginForm.jsp");
		return;
	}	
%>
	
	<div class="contaner">
		<section>
			<h2>회원 탈퇴 확인</h2>
			<!-- 비번 입력 -->
			<form action="deletePro.jsp" method="post">
				<label for="password_hash">비밀번호 입력 : </label>
				<input type="password" id="password_hash" name="password_hash" required="required"/>
				<input type="hidden" id="user_id" name="user_id" value="<%=user_id %>"/>
				
				<div class="btn-row">
					<button type="submit" class="btn-primary">탈퇴</button>
	          		<button type="button" class="btn-secondary" onclick="location.href='main.jsp'">취소</button>
				</div>
				
			</form>
		</section>
	</div>
	
</body>
</html>