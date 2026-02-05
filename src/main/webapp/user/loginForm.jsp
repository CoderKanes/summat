<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인 로그인/회원가입</title>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<%-- 
	작성자 : 김동욱
	내용 : 로그인 및 회원가입 폼 페이지.
--%>

<style type="text/css">
	body {
	    font-family: Arial, sans-serif;
	    background: #f1efe7;
	    margin: 0;
	  }
	
	.container {
	    width: 980px;
	    margin: 40px auto;
	    display: grid;
	    grid-template-columns: 260px 1fr;
	    gap: 20px;
	  }


	.sidebar {
	    background: #e9e0d1;
	    padding: 20px;
	    border-radius: 8px;
	    height: 100%;
	}

	.content { padding: 20px; }

	.card { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 2px 6px rgba(0,0,0,.05); margin-bottom: 16px; }
	
	h2 { margin: 0 0 12px; font-size: 18px; }
	
	/* 폼 정렬을 위한 공통 스타일 */
	form {
	  display: grid;
	  grid-template-columns: 180px 1fr; /* 라벨 fixed, 입력창 flexible */
	  align-items: center;
	  gap: 12px 16px;
	  margin-bottom: 12px;
	}
	
	/* 각 입력 그룹(라벨+입력) 한 줄 고정 */
	.form-row { display: contents; } /* 필요시 사용 */
	
	label {
	  font-size: 14px;
	  text-align: right; /* 라벨을 오른쪽 정렬로 깔끔하게 맞춤 */
	  padding-right: 6px;
	}
	
	input {
	  padding: 10px;
	  border: 1px solid #ccc;
	  border-radius: 6px;
	  font-size: 14px;
	  width: 100%;
	  box-sizing: border-box;
	}
	
	button {
	  padding: 10px 14px;
	  border: none;
	  border-radius: 6px;
	  background: #f59e0b;
	  color: #fff;
	  font-weight: 600;
	  cursor: pointer;
	  grid-column: 2; /* 버튼은 입력 창 옆으로 정렬 */
	  justify-self: start;
	}
	
	.link { color:#1f6feb; cursor:pointer; text-decoration:underline; width:max-content; grid-column: 2; }
	
	#signupForm { display: none; }
	
	/* 반응형 간단 예시: 화면이 작아지면 1열로 전환 */
	@media (max-width: 720px) {
	  .container { grid-template-columns: 1fr; }
	  form { grid-template-columns: 1fr; }
	  label { text-align: left; }
	  button, .link { grid-column: 1; justify-self: stretch; }
	}
	.remember-row {
	  display: flex;
	  align-items: center;
	  justify-content: flex-start;  /*기본은 왼쪽 정렬, 필요 시 justify-content: flex-end로 오른쪽 배치도 가능 */
	  gap: 4px; /* 텍스트와 체크박스 사이 간격 조절 /
	  / 만약 체크박스를 텍스트 오른쪽으로 두고 싶다면 아래 주석 해제 /
	  / justify-content: flex-end; */
	  }
	  .remember-label {
	  white-space: nowrap; / 텍스트 줄 바꿈 방지 
	}
	
</style>
</head>
<body>
	<div class="container">
		<!-- 사이드 메뉴 -->
		<aside class="sidebar card" style="padding: 20px;">
  <h2>추천 글/사진</h2>

  <!-- 이미지 카드 예시 -->
  <!--  
  <div class="recommendation" style="margin-bottom:12px;">
    <a href="/posts/101" title="추천 글 제목 1">
      <img src="/images/reco1.jpg" alt="추천 글 사진 1" style="width:100%; height:auto; display:block; border-radius:6px;">
      <div style="margin-top:6px; font-weight:600;">제목 example 1</div>
    </a>
  </div>

  <div class="recommendation" style="margin-bottom:12px;">
    <a href="/posts/102" title="추천 글 제목 2">
      <img src="/images/reco2.jpg" alt="추천 글 사진 2" style="width:100%; height:auto; display:block; border-radius:6px;">
      <div style="margin-top:6px; font-weight:600;">제목 example 2</div>
    </a>
  </div>
 -->
  <!-- 간단한 글 리스트 -->
  <h3 style="font-size:14px; margin:12px 0 6px;">다른 추천 글</h3>
  <ul style="padding-left:16px; margin:0;">
    <li><a href="/posts/103">추천 글 제목 3</a></li>
    <li><a href="/posts/104">추천 글 제목 4</a></li>
    <li><a href="/posts/105">추천 글 제목 5</a></li>
  </ul>
</aside>
		
		<!-- 메인 콘텐츠 : 로그인 / 회원가입 박스 -->
		<main class="content card" id="mainContent">
			<h2>로그인</h2>
			
			<!-- 로그인 폼 -->
			<form id="loginForm" onsubmit="handleLogin(event)" action="loginPro.jsp">
				<div>
			   		<label for="user_id">아이디</label>
			   		<input type="text" id="user_id" name="user_id" required placeholder="아이디를 입력해 주세요" />
			 	</div>
			 	<div>
			   		<label for="password">비밀번호</label>
			   		<input type="password" id="password" name="password" required placeholder="비밀번호를 입력해주세요" />
			 	</div>
			 	<div class="form-row remember-row">
      				<label for="rememberMe" class="remember-label">자동로그인</label>
      				<input type="checkbox" id="rememberMe" name="rememberMe" />
    			</div> 
			 	<div></div>
			 	<button type="submit">로그인</button>
			 	<button type="button" onclick="location.href='main.jsp'">메인으로</button>
			 	
			 	<div style="grid-column:2; margin-top:8px;">
			   		<span>계정이 없으신가요?</span>
			   		<span class="link" onclick="showSignup()">회원 가입</span>
			 	</div>
			</form>
            
            <!-- 회원 가입 폼 -->
            <form id="signupForm" onsubmit="handleSignup(event)" action="insertPro.jsp" method="get">
  				<div>
    				<label for="user_id">아이디</label>
    				<input type="text" id="user_id" name="user_id" required placeholder="아이디" />
  				</div>

  				<div>
			    	<label for="username">이름</label>
			    	<input type="text" id="username" name="username" required placeholder="이름" />
			  	</div>
			
			  	<div>
			    	<label for="password">비밀번호</label>
			    	<input type="password" id="password" name="password" required placeholder="비밀번호" />
			  	</div>
			
			  	<div>
			    	<label for="email">이메일</label>
			    	<input type="email" id="email" name="email" required placeholder="이메일" />
			  	</div>
			
			  	<div>
			    	<label for="phone">휴대폰</label>
			    	<input type="text" id="phone" name="phone" required placeholder="휴대폰" />
			  	</div>
			
			  	<div>
			    	<label for="address">주소</label>
			    	<input type="text" id="address" name="address" placeholder="주소" />
			  	</div>
			
			  	<div>
			    	<label for="residNo">주민번호</label>
			    	<input type="text" id="residNo" name="resident_registration_number" placeholder="주민번호" />
			  	</div>
  					
				<button type="submit">가입하기</button>
			  	
			  	<div style="grid-column:2; margin-top:8px;">
			    	<span class="link" onclick="showLogin()">로그인으로 돌아가기</span>
			  	</div>
			</form>
		</main>
	</div>
	
	 <script type="text/javascript">
	// 화면 전환 함수
     function showSignup() {
         document.getElementById('loginForm').style.display = 'none';
         document.getElementById('signupForm').style.display = 'block';
     }

     function showLogin() {
         document.getElementById('loginForm').style.display = 'block';
         document.getElementById('signupForm').style.display = 'none';
     }
     
     function handleLogin(e) {
         if (!user_id || !password) {
             alert('이메일과 비밀번호를 입력해주세요.');
             return;
         }
         
     }
     
     function handleSignup(e) {
         // 간단한 필수 체크
         if (!user_id || !username || !password || !email || !phone || !residNo) {
             alert('아이디, 이름, 비밀번호, 이메일, 휴대폰은 필수 입력값입니다.');
             return;
         }

     }
     
     // 기본 화면은 로그인 보이도록 설정
     showLogin();
     
	 </script>
</body>
</html>