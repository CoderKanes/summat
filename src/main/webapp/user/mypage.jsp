<%@page import="oracle.jdbc.spi.UsernameProvider"%>
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
  
  /* 오른쪽 상단 가게 등록 카드 */
.store-card {
  position: fixed;
  top: 24px;
  right: 24px;
  background: linear-gradient(180deg, #fff, #fbfbfb);
  border-radius: 10px;
  padding: 10px 14px;
  box-shadow: 0 6px 18px rgba(18, 52, 86, 0.12);
  display: flex;
  gap: 10px;
  align-items: center;
  z-index: 1200;
  border: 1px solid rgba(74, 107, 60, 0.08);
  transition: transform .18s ease, box-shadow .18s ease;
  min-width: 180px;
}

/* 호버 효과 */
.store-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 30px rgba(18,52,86,0.14);
}

/* 아이콘 스타일 */
.store-card .icon-wrap {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background: linear-gradient(135deg, #56ab2f, #a8e063);
  display:flex;
  align-items:center;
  justify-content:center;
  color: #fff;
  flex-shrink: 0;
  box-shadow: 0 4px 10px rgba(90, 138, 60, 0.12) inset;
}

/* 텍스트 영역 */
.store-card .store-info {
  display:flex;
  flex-direction:column;
  gap:2px;
  font-size: 13px;
  color: var(--text);
}

/* 타이틀과 서브텍스트 */
.store-card .store-info .title {
  font-weight: 700;
  color: #2f5e2e;
}
.store-card .store-info .sub {
  font-size: 12px;
  color: var(--muted);
}

/* 액션 버튼 (카드 우측) */
.store-card .store-btn {
  margin-left: 8px;
  background: #2e7d32;
  color: #fff;
  padding: 8px 12px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  font-weight: 700;
  box-shadow: 0 6px 14px rgba(46,125,50,0.12);
  transition: background .12s ease, transform .12s ease;
}
.store-card .store-btn:hover { transform: translateY(-2px); background:#25662a; }

/* 모바일: 고정 제거하고 오른쪽 상단 대신 흐름에 포함 */
@media (max-width:700px) {
  .store-card {
    position: static;
    width: 100%;
    margin: 12px 0;
    justify-content: space-between;
  }
  body { padding-top: 0; }
}

/* 등업 카드 크기 축소 및 카드 내부 레이아웃 조정 */
#upgrade-card {
  max-width: 360px;       /* 더 작게 유지 */
  padding: 10px 12px;     /* 내부 여백 축소 */
  border-radius: 10px;
  box-shadow: var(--shadow);
  background: var(--card);
  margin-top: 8px;
}

/* 내부 텍스트 스타일 */
#upgrade-card .uc-title { font-weight:700; color:var(--accent); font-size:14px; }
#upgrade-card .uc-desc  { color:var(--muted); font-size:12px; margin-top:4px; line-height:1.3; }

/* 버튼 그룹 크기 조정 */
#upgrade-card .upgrade-actions { display:flex; gap:8px; margin-left:8px; flex-shrink:0; }
#upgrade-card .upgrade-actions .btn {
  padding: 7px 10px;
  font-size:13px;
  border-radius:8px;
}

/* SVG 아이콘 크기 감소 */
#upgrade-card .btn svg { width:12px; height:12px; }

/* 프로필 카드 내부에서 가로 공간이 좁을 때 버튼들이 아래로 내려가지 않도록 */
.card.row > #upgrade-card { align-self:flex-start; }

/* 모바일: 카드가 너무 작으면 너비 100% */
@media (max-width:700px) {
  #upgrade-card { max-width:100%; width:100%; }
}
</style>
<script>
  	
  	function infoUpdate() {
    	window.location.href = '/summat/user/infoUpdateForm.jsp'
  	}

  	
  	function goMain() {
    	window.location.href = '/summat/main/main.jsp'; 
  	}
  	
	// 상점 신청 페이지로
  	function goStoreRegist() {
    	window.location.href = '/summat/store/storeRegist.jsp'; 
  	}

  	// 탈퇴 확인 및 이동 예시
  	function withdraw() {
      	
      	window.location.href = '/summat/user/deleteForm.jsp'; 
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
	<!-- 프로필 카드: avatar(사진)와 정보 영역을 수직 스택으로 정리 -->
<div class="card row" style="align-items:flex-start; gap:24px;">
  <!-- 왼쪽: 사진 + 사진 아래 등업 버튼 (세로로 배치) -->
  <div style="display:flex; flex-direction:column; align-items:flex-start; gap:10px;">
    <img src="/summat/resources/profile/<%=profile_image_url%>" alt="사진" class="avatar" />
    
    <!-- 사진 변경 폼 -->
    <form action="profile_image_uploadForm.jsp" method="post" enctype="multipart/form-data" style="display:flex; gap:8px; margin-bottom:6px;">
      <button type="submit" class="btn photo">사진 변경</button>
    </form>

    <!-- 등업 신청 영역: 사진 바로 아래에 세로로 배치 -->
    <div class="card" id="upgrade-card" style="padding:10px 12px; max-width:360px;">
      <div style="display:flex; flex-direction:column; gap:8px;">
        <div style="display:flex; gap:8px; margin-top:6px;">
          <a href="/summat/user/influencerUpgradeForm.jsp?user_id=<%=user_id %>" class="btn" style="display:inline-flex; align-items:center; gap:8px; padding:8px 10px; font-size:13px;">
            <svg width="14" height="14" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87L18.18 22 12 18.77 5.82 22 7 14.14l-5-4.87 6.91-1.01L12 2z" fill="#fff"/></svg>
            인플루언서 신청
          </a>

          <a href="/summat/user/reporterUpgradeForm.jsp" class="btn primary" style="display:inline-flex; align-items:center; gap:8px; padding:8px 10px; font-size:13px;">
            <svg width="14" height="14" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M3 6h18v2H3V6zm2 4h14v8H5v-8z" fill="#fff"/></svg>
            기자 신청
          </a>
        </div>
      </div>
    </div>
  </div>

  <!-- 오른쪽: 사용자 정보 및 버튼들 -->
  <div style="flex:1; min-width:220px;">

    <div class="info" style="font-size:16px;">
      아이디 : <%=user_id %><br/>
      이름 : <%=dto.getUsername() %><br/>
      이메일 : <%=dto.getEmail() %><br/>
      전화번호 : <%=dto.getPhone() %><br/>
      주소 : <%=dto.getAddress() %><br/>
      주민번호 : <%=dto.getResident_registration_number() %><br/>
      회원가입일 : <%=dto.getCreated_at() %><br/>
    </div>

    <div class="card row" style="justify-content: flex-start; align-items: center; gap:8px; margin-top:10px;">
      <button class="btn" onclick="infoUpdate()">정보 수정</button>
      <button class="btn danger" onclick="withdraw()">회원 탈퇴</button>
      <button class="btn" onclick="goMain()">메인으로 돌아가기</button>
    </div>
  </div>
</div>

  		
	
		
	<!-- 오른쪽 상단 가게 등록 카드 -->
	<div class="store-card" role="region" aria-label="가게 등록 신청">
  		<div class="icon-wrap" aria-hidden="true">
    	<!-- 간단한 상점 아이콘 SVG -->
    	<svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      		<path d="M3 7h18v2H3V7z" fill="rgba(255,255,255,0.95)"/>
      		<path d="M5 9v8a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V9H5z" fill="rgba(255,255,255,0.95)"/>
    	</svg>
  	</div>

  	<div class="store-info">
    	<div class="title">가게 등록 신청</div>
    	<div class="sub">판매자로 등록하고 가게를 오픈하세요</div>
  	</div>

  	<button class="store-btn" onclick="goStoreRegist();">신청하기</button>
</div>
</body>
</html>