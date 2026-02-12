<%@ page import="sm.data.AdminDAO" %>
<%@ page import="sm.data.StatsDTO" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 대시보드</title>
<style>
/* 헤더/카드 스타일 */
.container { max-width:1100px; margin:20px auto; padding:0 12px; }
.header-row { display:flex; justify-content:space-between; align-items:center; gap:12px; margin: 6px 0 18px; }
.page-title { font-size:1.6rem; color:#222; }

/* 검색 폼 */
.search-form { display:flex; gap:8px; align-items:center; margin-bottom:12px; }
.search-form input[type="text"] { padding:8px 10px; border:1px solid #d0d7e9; border-radius:6px; width:260px; }
.search-form button { padding:8px 12px; border-radius:6px; background:#4f6bd9; color:#fff; border:none; cursor:pointer; }
.search-form a.reset { margin-left:8px; font-size:13px; color:#666; text-decoration:none; }

/* 카드 그리드 */
.stats-grid { display:grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap:12px; width:100%; max-width:980px; }

/* 단일 카드 */
.stat-card { display:flex; align-items:center; gap:12px; background:linear-gradient(180deg,#fff,#fbfdff); border:1px solid #e6eefc; padding:10px 14px; border-radius:10px; box-shadow:0 6px 18px rgba(50,80,160,0.06); min-width:160px; }
.icon { width:44px; height:44px; border-radius:50%; display:flex; align-items:center; justify-content:center; color:#fff; font-weight:700; box-shadow:0 4px 10px rgba(0,0,0,0.08); }
.icon.total { background: linear-gradient(135deg,#4f6bd9,#6e8bf3); }
.icon.active { background: linear-gradient(135deg,#28a745,#49c26d); }
.icon.deactive { background: linear-gradient(135deg,#e24b4b,#ff7b7b); }
.icon.verified { background: linear-gradient(135deg,#f59e0b,#fbbf24); }
.icon.male { background: linear-gradient(135deg,#3b82f6,#60a5fa); }
.icon.female { background: linear-gradient(135deg,#ec4899,#fb7185); }

.stat-card .meta { display:flex; flex-direction:column; line-height:1; }
.stat-card .meta .label { font-size:12px; color:#55607a; }
.stat-card .meta .value { font-size:18px; font-weight:700; color:#1f3b8a; }

/* 연령대 카드 내부 정렬 */
.age-grid { display:flex; gap:10px; flex-wrap:wrap; }
.age-item { min-width:120px; display:flex; flex-direction:column; gap:6px; padding:8px 10px; border-radius:8px; background:#fff; border:1px solid #eef3fb; box-shadow:0 4px 10px rgba(50,80,160,0.03); }

@media (max-width:560px) {
  .header-row { flex-direction:column; align-items:flex-start; gap:10px; }
  .search-form input[type="text"] { width:160px; }
}
</style>
</head>
<body>
<div class="container">
<%
    // Admin 체크 필요 시 추가
    AdminDAO dao = AdminDAO.getInstance();
    String searchQuery = request.getParameter("searchQuery");

    // 통계 및 기본 카운트 (DAO는 searchQuery 파라미터를 사용해 필터링한다고 가정)
    StatsDTO sdto = dao.getStats(searchQuery); // 성별/연령 통계
    int totalMembers = dao.getAllCount(searchQuery);
    int activeMembers = dao.getCountByStatus("ACTIVE", searchQuery);
    int deactiveMembers = dao.getCountByStatus("DEACTIVE", searchQuery);
    int emailVerified = dao.getEmailVerifiedCount(searchQuery);
%>

<div class="header-row">
  <div class="page-title">
  	관리자 대시보드
  	<button type="button" onclick="document.location.href='/summat/admin/memberList.jsp'">리스트로</button>
  	<button type="button" onclick="document.location.href='/summat/sm/main.jsp'">메인으로</button>
  </div>
  <!-- 검색 폼 -->
  <form class="search-form" method="get" action="dashboard.jsp">
    <input type="text" name="searchQuery" placeholder="아이디/이름 검색" value="<%= (request.getParameter("searchQuery") != null) ? request.getParameter("searchQuery") : "" %>">
    <button type="submit">검색</button>
    <a class="reset" href="dashboard.jsp">전체</a>
  </form>
</div>

<!-- 상단 요약 카드 -->
<div class="stats-grid" style="margin-bottom:14px;">
  <div class="stat-card" title="총 회원수">
    <div class="icon total">U</div>
    <div class="meta">
      <div class="label">총 회원수</div>
      <div class="value"><%= totalMembers %></div>
    </div>
  </div>

  <div class="stat-card" title="활성 회원수 (ACTIVE)">
    <div class="icon active">A</div>
    <div class="meta">
      <div class="label">활성 회원수</div>
      <div class="value"><%= activeMembers %></div>
    </div>
  </div>

  <div class="stat-card" title="탈퇴/비활성 회원수 (DEACTIVE)">
    <div class="icon deactive">D</div>
    <div class="meta">
      <div class="label">탈퇴 회원수</div>
      <div class="value"><%= deactiveMembers %></div>
    </div>
  </div>

  <div class="stat-card" title="이메일 인증 완료 회원수">
    <div class="icon verified">E</div>
    <div class="meta">
      <div class="label">이메일 인증 완료</div>
      <div class="value"><%= emailVerified %></div>
    </div>
  </div>
</div>

<!-- 성별 통계 -->
<h3 style="margin:8px 0 6px; color:#333;">성별 통계</h3>
<div class="stats-grid" style="margin-bottom:14px;">
  <div class="stat-card" title="분석 대상 총수">
    <div class="icon total">#</div>
    <div class="meta">
      <div class="label">총 (분석 대상)</div>
      <div class="value"><%= sdto.total %></div>
    </div>
  </div>

  <div class="stat-card" title="남성 수">
    <div class="icon male">M</div>
    <div class="meta">
      <div class="label">남성</div>
      <div class="value"><%= sdto.male %></div>
    </div>
  </div>

  <div class="stat-card" title="여성 수">
    <div class="icon female">F</div>
    <div class="meta">
      <div class="label">여성</div>
      <div class="value"><%= sdto.female %></div>
    </div>
  </div>

  <div class="stat-card" title="성별 알 수 없음">
    <div class="icon verified">?</div>
    <div class="meta">
      <div class="label">알 수 없음</div>
      <div class="value"><%= sdto.unknownGender %></div>
    </div>
  </div>
</div>

<!-- 연령대 통계 -->
<h3 style="margin:8px 0 6px; color:#333;">연령대 통계</h3>
<div class="age-grid" style="margin-bottom:40px;">
  <div class="age-item">
    <div style="font-size:12px;color:#55607a;">0-9세</div>
    <div style="font-weight:700;font-size:16px;color:#1f3b8a;"><%= sdto.age0_9 %></div>
  </div>

  <div class="age-item">
    <div style="font-size:12px;color:#55607a;">10-19세</div>
    <div style="font-weight:700;font-size:16px;color:#1f3b8a;"><%= sdto.age10_19 %></div>
  </div>

  <div class="age-item">
    <div style="font-size:12px;color:#55607a;">20대</div>
    <div style="font-weight:700;font-size:16px;color:#1f3b8a;"><%= sdto.age20_29 %></div>
  </div>

  <div class="age-item">
    <div style="font-size:12px;color:#55607a;">30대</div>
    <div style="font-weight:700;font-size:16px;color:#1f3b8a;"><%= sdto.age30_39 %></div>
  </div>

  <div class="age-item">
    <div style="font-size:12px;color:#55607a;">40대</div>
    <div style="font-weight:700;font-size:16px;color:#1f3b8a;"><%= sdto.age40_49 %></div>
  </div>

  <div class="age-item">
    <div style="font-size:12px;color:#55607a;">50대</div>
    <div style="font-weight:700;font-size:16px;color:#1f3b8a;"><%= sdto.age50_59 %></div>
  </div>

  <div class="age-item">
    <div style="font-size:12px;color:#55607a;">60세 이상</div>
    <div style="font-weight:700;font-size:16px;color:#1f3b8a;"><%= sdto.age60_plus %></div>
  </div>
</div>

</div> <!-- container -->
</body>
</html>