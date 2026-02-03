<%@page import="sm.data.MemberDAO"%>
<%@page import="sm.data.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>mypage</title>
<style>
  :root {
    --bg: #f5f0e7;
    --card: #ffffff;
    --text: #333;
    --muted: #666;
    --accent: #4caf50;
    --danger: #e53935;
    --btn: #4caf50;       /* 기본 버튼 색상은 여기에 맞춤 */
    --btnText: #fff;
    --shadow: 0 1px 3px rgba(0,0,0,.08);
  }
  * { box-sizing: border-box; }
  body { margin: 0; font-family: Arial, sans-serif; background: var(--bg); color: var(--text); display:flex; justify-content:center; align-items:flex-start; min-height:100vh; }
  .container { width: 100%; max-width: 960px; padding: 20px; }

  .card { background: var(--card); border-radius: 12px; padding: 16px; margin: 12px 0; box-shadow: var(--shadow); }

  .row { display:flex; gap: 16px; align-items: center; }

  .profile { display:flex; align-items:center; gap:20px; }

  .avatar { width: 120px; height: 120px; border-radius: 8px; object-fit: cover; background:#ddd; }

  .info { line-height: 1.6; font-size: 14px; color: var(--text); }

  .actions { display:flex; gap: 12px; flex-wrap: wrap; margin-top: 8px; }

  .btn { padding: 10px 16px; border: none; border-radius: 6px; cursor: pointer; background: var(--btn); color: var(--btnText); font-weight: 600; }
  .btn.primary { background: var(--accent); color: #fff; }
  .btn.danger { background: var(--danger); color: #fff; }
  .btn.link { background: transparent; color: #2a6b9e; text-decoration: underline; }

  /* 사진 변경 버튼에 색상 추가 (예: 파란 계열) */
  .btn.photo { background: #1e88e5; color: #fff; }

  /* 글자 크기 키우기 */
  .info { font-size: 16px; }

  .hidden { display:none; }

  @media (max-width: 700px) {
    .profile { flex-direction: column; align-items: flex-start; }
  }
</style>
<script>
  	// 정보 수정
  	function infoUpdate() {
    	window.location.href = 'infoUpdateForm.jsp'
  	}

  	// 메인으로 돌아가기 예시 (링크나 경로에 맞춰 수정)
  	function goMain() {
    	window.location.href = '/summat/sm/main.jsp'; // 메인 페이지 경로로 수정 필요
  	}

  	// 탈퇴 확인 및 이동 예시
  	function withdraw() {
    	if (confirm('정말로 탈퇴하시겠습니까? 탈퇴 시 계정 정보가 삭제됩니다.')) {
      	// 실제 탈퇴 경로로 이동
      		window.location.href = 'deleteForm.jsp'; // 실제 경로로 수정
    	}
  	}
</script>
</head>
<body>
	<h1>마이 페이지</h1>
	
<%
	MemberDTO dto = new MemberDTO();
	MemberDAO dao = MemberDAO.getInstance();
	
	String user_id = (String)session.getAttribute("sid");
	dto = dao.getInfo(user_id);
	String profile_image_url = dao.getImage(user_id);
	
%>
	<div class="card row" style="align-items:center;">
  		<img src="/summat/resources/profile/<%=profile_image_url%>" alt="사진" class="avatar" />

  		<!-- 사진 변경 버튼 + 파일 입력 -->
  		<form action="profile_image_uploadForm.jsp" method="post" enctype="multipart/form-data" style="display:flex; align-items:center; gap:8px;">
    		<!-- 색상 적용: photo 클래스 -->
    		<button type="submit" class="btn photo">사진 변경</button>
  		</form>
	<div class="info" style="font-size:16px;">
  		아이디 : <%=user_id %><br/>
  		이름 : <%=dto.getUsername() %><br/>
  		이메일 : <%=dto.getEmail() %><br/>
  		전화번호 : <%=dto.getPhone() %><br/>
  		주소 : <%=dto.getAddress() %><br/>
  		주민번호 :<%=dto.getResident_registration_number() %><br/>
  		회원가입일 : <%=dto.getCreated_at() %><br/>
	</div>

  	<!-- 사진 변경 버튼을 포함한 수정 가능 영역 (메인 톤에 맞춘 버튼 배치) -->
  	<div class="card row" style="justify-content: flex-start; align-items: center; gap:8px;">
  		<button class="btn" onclick="infoUpdate()">정보 수정</button>
  		<button class="btn danger" onclick="withdraw()">회원 탈퇴</button>
  		<button class="btn" onclick="goMain()">메인으로 돌아가기</button>
	</div>
</body>
</html>