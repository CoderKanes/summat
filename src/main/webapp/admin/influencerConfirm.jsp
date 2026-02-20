<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.ArrayList,java.util.Collections,java.util.Comparator" %>
<%@ page import="sm.data.InfluencerRequestDTO,sm.data.InfluencerRequestDAO" %>
<%@ page import="sm.data.AdminDAO" %>

<%
request.setCharacterEncoding("UTF-8");

// 로그인/권한 체크 (관리자 페이지라면 필요 시 grade 체크 추가)
String userId = (String) session.getAttribute("sid");
if (userId == null || userId.trim().isEmpty()) {
    response.sendRedirect(request.getContextPath() + "/user/loginForm.jsp");
    return;
}

// 파라미터 수집
String q_user_id = request.getParameter("q_user_id");
String q_status = request.getParameter("q_status");
// ✅ 핵심 수정: 기본값을 "PENDING" (대문자)로 변경
if (q_status == null || q_status.trim().isEmpty()) {
    q_status = "PENDING"; // 👈 대문자로 통일!
}
String sortDirParam = request.getParameter("sortDir"); // "asc" or "desc"
final String sortDir =
("asc".equalsIgnoreCase(sortDirParam) || "desc".equalsIgnoreCase(sortDirParam))
    ? sortDirParam.toLowerCase()
    : "desc";

String pageNum = request.getParameter("pageNum");
if (pageNum == null || pageNum.trim().isEmpty()) pageNum = "1";
int curPage = 1;
try { curPage = Math.max(1, Integer.parseInt(pageNum)); } catch (Exception e) { curPage = 1; }

// 페이징 설정
int pageSize = 20;
int pageGroupSize = 7;

// DAO 호출: 전체(혹은 큰 범위) 가져와서 JSP에서 정렬+페이징
int fetchStart = 1;
int fetchEnd = Integer.MAX_VALUE; // 주의: 대량 데이터시 성능 이슈

InfluencerRequestDAO dao = InfluencerRequestDAO.getInstance();
List<InfluencerRequestDTO> allList = new ArrayList<InfluencerRequestDTO>();
int totalCount = 0;
try {
    allList = dao.getRequeList(q_user_id, q_status, fetchStart, fetchEnd);
    totalCount = dao.getRequestCount(q_user_id, q_status);
} catch (Exception e) {
    e.printStackTrace();
    allList = new ArrayList<InfluencerRequestDTO>();
    totalCount = 0;
}

// requested_at 기준으로 서버측 정렬
Collections.sort(allList, new Comparator<InfluencerRequestDTO>() {
    public int compare(InfluencerRequestDTO a, InfluencerRequestDTO b) {
        if (a.getRequested_at() == null && b.getRequested_at() == null) return 0;
        if (a.getRequested_at() == null) return ("asc".equalsIgnoreCase(sortDir)) ? -1 : 1;
        if (b.getRequested_at() == null) return ("asc".equalsIgnoreCase(sortDir)) ? 1 : -1;
        int cmp = a.getRequested_at().compareTo(b.getRequested_at());
        return "asc".equalsIgnoreCase(sortDir) ? cmp : -cmp;
    }
});

// JSP 쪽 페이징 (sublist)
int totalPage = (int) Math.ceil((double) totalCount / pageSize);
if (totalPage < 1) totalPage = 1;
int startIndex = (curPage - 1) * pageSize; // 0-based
int endIndex = Math.min(startIndex + pageSize, allList.size());
List<InfluencerRequestDTO> pageList = new ArrayList<InfluencerRequestDTO>();
if (startIndex < allList.size()) {
    pageList = allList.subList(startIndex, endIndex);
}

// 페이징 UI 범위 계산
int startPage = Math.max(1, curPage - (pageGroupSize/2));
int endPage = Math.min(totalPage, startPage + pageGroupSize - 1);
if (endPage - startPage + 1 < pageGroupSize) {
    startPage = Math.max(1, endPage - pageGroupSize + 1);
}

// baseUrl (필터/정렬 유지)
String baseUrl = request.getRequestURI() + "?";
if (q_user_id != null && !q_user_id.isEmpty()) baseUrl += "q_user_id=" + java.net.URLEncoder.encode(q_user_id, "UTF-8") + "&";
if (q_status != null && !q_status.isEmpty()) baseUrl += "q_status=" + java.net.URLEncoder.encode(q_status, "UTF-8") + "&";
baseUrl += "sortDir=" + java.net.URLEncoder.encode(sortDir, "UTF-8") + "&";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인플루언서 등업 신청 목록 (관리자)</title>
<style>
.container { max-width:1100px; margin:24px auto; padding:18px; font-family:Arial, sans-serif; }
.toolbar { display:flex; gap:8px; align-items:center; margin-bottom:12px; }
.table { width:100%; border-collapse:collapse; }
.table th, .table td { border:1px solid #ddd; padding:8px; text-align:left; vertical-align:top; }
.table thead { background:#f3f6ff; }
.pager { margin-top:12px; }
.pager a { margin:0 4px; text-decoration:none; color:#0366d6; }
.small { font-size:0.9rem; color:#666; }
</style>
</head>
<body>

<%
// 처리 결과 메시지 표시
String rawMsg = request.getParameter("msg");
String msg = "";
if (rawMsg != null) {
    try {
        msg = java.net.URLDecoder.decode(rawMsg, "UTF-8");
    } catch (Exception e) {
        msg = rawMsg;
    }
}
if (!msg.isEmpty()) {
%>
<div style="background:#e6f4ea; color:#137333; padding:12px; border-radius:6px; margin-bottom:16px; border:1px solid #c6e0d0;">
  <strong>알림:</strong> <%= msg %>
</div>
<%
}
%>

<div class="container">
  <h2>인플루언서 등업 신청 목록 (관리자)</h2>

    <form method="post" action="<%= request.getContextPath() %>/admin/influencerBatchPro.jsp">
    <div class="toolbar">
      사용자ID:
      <input type="text" name="q_user_id" value="<%= (q_user_id==null) ? "" : q_user_id %>">
      상태:
      <select name="q_status">
        <option value="">전체</option>
        <!-- ✅ 모든 value를 대문자로 통일 -->
        <option value="PENDING" <%= "PENDING".equals(q_status) ? "selected" : "" %>>대기</option>
        <option value="APPROVED" <%= "APPROVED".equals(q_status) ? "selected" : "" %>>승인</option>
        <option value="REJECTED" <%= "REJECTED".equals(q_status) ? "selected" : "" %>>반려</option>
      </select>

      정렬(요청일):
      <select name="sortDir">
        <option value="desc" <%= "desc".equalsIgnoreCase(sortDir) ? "selected" : "" %>>최신순(내림)</option>
        <option value="asc" <%= "asc".equalsIgnoreCase(sortDir) ? "selected" : "" %>>오래된순(오름)</option>
      </select>

      <input type="submit" value="검색/정렬" formaction="">
      <span class="small">ID는 관리자 화면에 표시하지 않습니다.</span>
    </div>

    <table class="table" role="table" aria-label="인플루언서 신청 목록">
      <thead>
        <tr>
          <th><input type="checkbox" id="selectAll" title="모두 선택"></th>
          <th>사용자ID</th>
          <th>요청등급</th>
          <th>사유</th>
          <th>SNS URLs</th>
          <th>상태</th>
          <th>요청일</th>
          <th>처리자</th>
          <th>처리일</th>
          <th>관리자 메모</th>
        </tr>
      </thead>
      <tbody>
        <%
          if (pageList == null || pageList.isEmpty()) {
        %>
          <tr><td colspan="10" style="text-align:center; color:#666;">신청 내역이 없습니다.</td></tr>
        <%
          } else {
            for (InfluencerRequestDTO dto : pageList) {
        %>
          <tr>
            <td style="text-align:center;">
              <input type="checkbox" name="selectedIds" value="<%= dto.getId() %>">
            </td>
            <td><%= dto.getUser_id() %></td>
            <td><%= dto.getRequested_grade() %></td>
            <td><%= dto.getReason() != null ? dto.getReason().replaceAll("\n","<br/>") : "" %></td>
            <td><%= dto.getSns_urls() %></td>
            <td><%= dto.getStatus() %></td>
            <td><%= dto.getRequested_at() %></td>
            <td><%= dto.getProcessed_by() %></td>
            <td><%= dto.getProcessed_at() %></td>
            <td><%= dto.getAdmin_note() != null ? dto.getAdmin_note().replaceAll("\n","<br/>") : "" %></td>
          </tr>
        <%
            }
          }
        %>
      </tbody>
    </table>

    <div style="margin-top:12px;">
      <button type="submit" name="action" value="APPROVED">선택 승인</button>
      <button type="submit" name="action" value="REJECTED">선택 반려</button>
      <button type="submit" name="action" value="APPROVED_ALL" onclick="return confirm('전체 신청을 승인하시겠습니까?');">전체 승인</button>
    </div>
  </form>

  <div class="pager" role="navigation" aria-label="페이지 네비게이션">
    <%
      if (curPage > 1) {
    %>
      <a href="<%= baseUrl %>pageNum=<%= curPage-1 %>">이전</a>
    <%
      }
      for (int i = startPage; i <= endPage; i++) {
        if (i == curPage) {
    %>
      <strong><%= i %></strong>
    <%
        } else {
    %>
      <a href="<%= baseUrl %>pageNum=<%= i %>"><%= i %></a>
    <%
        }
      }
      if (curPage < totalPage) {
    %>
      <a href="<%= baseUrl %>pageNum=<%= curPage+1 %>">다음</a>
    <%
      }
    %>
  </div>

  <div style="margin-top:12px;">
    <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">관리자 페이지로 돌아가기</a>
  </div>
</div>
</body>

<script>
(function(){
	form.addEventListener('submit', function(e){
	    const action = (e.submitter && e.submitter.name === 'action') ? e.submitter.value : null;
	    if (!action) return;

	    if (action === 'APPROVED_ALL') return; // 전체 승인은 그냥 제출

	    const checked = Array.from(form.querySelectorAll('input[name="selectedIds"]:checked'));
	    if (checked.length === 0) {
	        e.preventDefault();
	        alert('하나 이상 선택하세요.');
	        return;
	    }

	    // ✅ 1건이든 다건이든 그냥 batch로 제출
	    if (!confirm(checked.length + '건을 ' + (action === 'APPROVED' ? '승인' : '반려') + '하시겠습니까?')) {
	        e.preventDefault();
	    }
	});
</script>

</html>