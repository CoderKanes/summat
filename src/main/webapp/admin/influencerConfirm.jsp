<%@ page import="java.sql.*" %>
<%@ page import="sm.data.OracleConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

// 로그인 확인: 세션에서 user_id와 grade를 읽음
String userId = (String) session.getAttribute("sid");
Integer gradeObj = (Integer) session.getAttribute("grade"); // 세션에 grade가 int로 저장되어 있다고 가정

// 비로그인 처리
if (userId == null || userId.trim().isEmpty()) {
    response.sendRedirect("/summat/user/login.jsp");
    return;
}

// 세션에 grade가 없으면 안전하게 멤버 조회 없이 접근 차단(또는 필요하면 DB에서 한번만 조회하도록 변경)
if (gradeObj == null) {
    // 세션에 grade 정보가 없으면 마이페이지로 리다이렉트하거나 오류 페이지
    response.sendRedirect("/summat/user/myPage.jsp");
    return;
}

int grade = gradeObj.intValue();

// 이제 grade 값에 따라 JSP 본문에서 분기 처리합니다.
// grade == 0 : 신청 가능
// grade == 1 : 승인 대기중
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인플루언서 등업 신청 확인</title>
<style>
/* 간단한 스타일 */
.container { max-width:700px; margin:30px auto; padding:18px; background:#fff; border-radius:8px; box-shadow:0 6px 18px rgba(0,0,0,0.06); font-family:Arial, sans-serif;}
.h1 { font-size:20px; margin-bottom:12px; color:#1f3b8a; }
.notice { padding:12px; border-radius:6px; background:#f5f7ff; border:1px solid #e1e8ff; color:#243b6b; }
.btn { padding:8px 12px; border-radius:6px; border:none; cursor:pointer; font-weight:700; }
.btn.primary { background:#2e7d32; color:#fff; }
.btn.ghost { background:#fff; border:1px solid #ccc; }
</style>
</head>
<body>
<div class="container">
  <div class="h1">인플루언서 등업 신청</div>

<%
if (grade == 0) {
%>
  <!-- grade 0: 신청 가능 (원본 폼에서 전달된 값으로 여기서 DB insert 처리하거나 confirm 페이지로 연결) -->
  <div class="notice">현재 등업 등급: <strong>0</strong>. 인플루언서 등업을 신청하실 수 있습니다.</div>

  <!-- 간단한 확인/요약 보여주고 서버의 실제 insert 처리 페이지로 POST -->
  <form method="post" action="/summat/user/influencerConfirmProcess.jsp">
    <input type="hidden" name="user_id" value="<%= userId %>">
    <div style="margin-top:12px;">
      <label>신청 등급: </label>
      <select name="requested_grade">
        <option value="1">1</option>
        <option value="2">2</option>
      </select>
    </div>
    <div style="margin-top:12px;">
      <label>신청 사유</label><br>
      <textarea name="reason" rows="6" style="width:100%" required></textarea>
    </div>
    <div style="margin-top:8px;">
      <label>SNS URL</label><br>
      <input type="text" name="sns_urls" style="width:100%" placeholder="https://instagram.com/..., 쉼표(,)로 구분">
    </div>

    <div style="margin-top:14px; display:flex; gap:8px; justify-content:flex-end;">
      <button type="button" class="btn ghost" onclick="history.back();">취소</button>
      <button type="submit" class="btn primary">신청하기</button>
    </div>
  </form>

<%
} else if (grade == 1) {
%>
  <!-- grade 1: 이미 신청 상태(대기 중) -->
  <div class="notice">
    현재 등업 등급: <strong>1</strong> (승인 대기중입니다).<br>
    관리자의 승인 후 등급이 반영됩니다. 문의가 필요하면 고객센터로 연락해주세요.
  </div>
  <div style="margin-top:16px;">
    <a href="/summat/main/main.jsp"><button class="btn ghost">메인으로</button></a>
    <a href="/summat/user/myPage.jsp"><button class="btn primary">내 계정 보기</button></a>
  </div>

<%
} else if (grade == -1) {
%>
  <!-- members에 레코드 없음 -->
  <div class="notice" style="background:#fff0f0;border-color:#ffd6d6;color:#8b1f1f;">
    사용자 정보를 찾을 수 없습니다. 로그아웃 후 다시 로그인하거나 관리자에게 문의하세요.
  </div>
  <div style="margin-top:12px;">
    <a href="/summat/user/login.jsp"><button class="btn primary">로그인</button></a>
  </div>

<%
} else {
%>
  <!-- 기타 상태(오류) -->
  <div class="notice" style="background:#fff7e6;border-color:#ffe7b3;color:#7a5200;">
    현재 등업 처리 상태를 확인할 수 없습니다. 잠시 후 다시 시도하거나 관리자에게 문의하세요.
  </div>
<%
}
%>

</div>
</body>
</html>