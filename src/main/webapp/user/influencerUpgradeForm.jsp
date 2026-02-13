<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인플루언서 등업 신청</title>
<style>
/* (기존 스타일 유지) */
body { font-family: Arial, sans-serif; padding:20px; background:#f6f6f6; }
.card { background:#fff; padding:16px; border-radius:8px; max-width:720px; margin:0 auto; box-shadow:0 4px 12px rgba(0,0,0,0.06); }
.row { margin-bottom:12px; display:flex; gap:12px; align-items:flex-start; }
label { width:120px; font-weight:700; color:#333; }
input[type="text"], textarea { width:100%; padding:8px; border:1px solid #ddd; border-radius:6px; font-size:14px; }
textarea { min-height:120px; resize:vertical; }
.hint { font-size:12px; color:#666; margin-top:4px; }
.actions { display:flex; gap:8px; justify-content:flex-end; margin-top:14px; }
.btn { padding:8px 14px; border-radius:6px; border:none; cursor:pointer; font-weight:700; }
.btn.primary { background:#2e7d32; color:#fff; }
.btn.ghost { background:transparent; border:1px solid #ccc; }
.user-id { padding:8px 12px; background:#fafafa; border:1px solid #eee; border-radius:6px; }
.error { color:#b00020; font-size:13px; margin-top:6px; display:none; }
</style>
<script>
function validateAndSubmit(form) {
  const reason = form.reason.value.trim();
  const sns = form.sns_urls.value.trim();
  if (!reason) { showError("신청 사유를 입력하세요."); return false; }
  if (sns && !/^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/.*)?(,\s*(https?:\/\/)?([\w-]+\.)+[\w-]+(\/.*)?)*$/.test(sns)) {
    showError("SNS URL 형식이 올바르지 않거나 쉼표로 구분된 URL들에 문제가 있습니다.");
    return false;
  }
  form.submit();
  return true;
}
function showError(msg) {
  const el = document.getElementById('err');
  el.textContent = msg;
  el.style.display = 'block';
  setTimeout(()=> el.style.display = 'none', 5000);
}
</script>
</head>
<body>
<%
  request.setCharacterEncoding("UTF-8");
  String user_id = request.getParameter("user_id");
  if (user_id == null) user_id = (String)session.getAttribute("sid"); // 세션에서 대체
  String gradeParam = request.getParameter("grade");
  int requested_grade = 0;
  try { requested_grade = Integer.parseInt(gradeParam); } catch(Exception e) { requested_grade = 0; }
%>

<div class="card">
  <h2>인플루언서 등업 신청</h2>

  <form name="upgradeForm" method="post" action="/summat/admin/influencerConfirm.jsp" onsubmit="event.preventDefault(); validateAndSubmit(this);">
    <div class="row">
      <label>아이디</label>
      <div class="user-id"><%= (user_id != null) ? user_id : "" %></div>
    </div>

    <!-- influencer_request 테이블 컬럼명에 맞춘 숨김 필드 -->
    <input type="hidden" name="user_id" value="<%= (user_id != null) ? user_id : "" %>">
    <input type="hidden" name="requested_grade" value="<%= requested_grade %>">

    <div class="row">
      <label for="reason">신청 사유</label>
      <div style="flex:1;">
        <textarea id="reason" name="reason" placeholder="등업을 원하는 이유, 활동 내용, SNS 활동 요약 등을 작성하세요." required></textarea>
        <div class="hint">활동 분야, 팔로워 수, 활동 기간 등 핵심 정보 포함</div>
      </div>
    </div>

    <div class="row">
      <label for="sns_urls">SNS URL</label>
      <div style="flex:1;">
        <input type="text" id="sns_urls" name="sns_urls" placeholder="https://instagram.com/yourid, https://www.youtube.com/channel/..." >
        <div class="hint">여러개는 쉼표(,)로 구분하거나 JSON 문자열로 넣어도 됩니다.</div>
      </div>
    </div>

    <div id="err" class="error"></div>

    <div class="actions">
      <button type="button" class="btn ghost" onclick="history.back();">취소</button>
      <button type="submit" class="btn primary">신청하기</button>
    </div>
  </form>
</div>
</body>
</html>