<%@page import="sm.data.InfluencerRequestDTO"%>
<%@page import="java.util.List"%>
<%@page import="sm.data.InfluencerRequestDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLEncoder, javax.servlet.http.HttpServletResponse" %>
<%!
public String escapeHtml(String s) {
    if (s == null) return "";
    return s.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#x27;");
}
%>
<%
request.setCharacterEncoding("UTF-8");

String adminId = (String) session.getAttribute("sid");
Object gradeObj = session.getAttribute("grade");

if (adminId == null || adminId.trim().isEmpty()) {
    response.sendRedirect(request.getContextPath() + "/user/loginForm.jsp");
    return;
}

int grade = -1;
try {
    if (gradeObj instanceof Integer) grade = ((Integer) gradeObj).intValue();
    else if (gradeObj != null) grade = Integer.parseInt(gradeObj.toString());
} catch (Exception ex) {
    grade = -1;
}

if (grade != 0) {
    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
    out.println("<h3>관리자만 접근 가능합니다.</h3>");
    out.println("<a href='" + request.getContextPath() + "/'>홈으로</a>");
    return;
}

// ✅ id 기반
String idParam = request.getParameter("id");
if (idParam == null || idParam.trim().isEmpty()) {
    out.println("<h3>잘못된 요청: 신청 ID가 필요합니다.</h3>");
    out.println("<a href='javascript:history.back();'>뒤로</a>");
    return;
}

int requestId = -1;
try {
    requestId = Integer.parseInt(idParam);
} catch (NumberFormatException e) {
    out.println("<h3>잘못된 신청 ID 형식입니다.</h3>");
    out.println("<a href='javascript:history.back();'>뒤로</a>");
    return;
}

// 신청 정보 조회 (선택 사항: 폼에 표시하려면)
InfluencerRequestDAO dao = InfluencerRequestDAO.getInstance();
List<InfluencerRequestDTO> list = dao.getRequeList(null, null, 1, Integer.MAX_VALUE);
InfluencerRequestDTO dto = null;
for (InfluencerRequestDTO item : list) {
    if (item.getId() == requestId) {
        dto = item;
        break;
    }
}

if (dto == null) {
    out.println("<h3>해당 신청을 찾을 수 없습니다.</h3>");
    out.println("<a href='javascript:history.back();'>뒤로</a>");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>단건 승인 - ID: <%= requestId %></title>
  <style>
    .container { max-width:700px; margin:30px auto; font-family:Arial, sans-serif; }
    label{display:block;margin-top:10px;}
    textarea{width:100%;height:120px;}
    .btns{margin-top:12px;}
    input[readonly] { background:#f5f5f5; }
  </style>
</head>
<body>
  <div class="container">
    <h3>단건 승인</h3>

    <form method="post" action="<%= request.getContextPath() %>/admin/influencerApprovePro.jsp">
      <!-- ✅ id 전달 -->
      <input type="hidden" name="id" value="<%= requestId %>">
      
      <label>신청 ID
        <input type="text" value="<%= requestId %>" readonly>
      </label>
      
      <label>사용자ID
        <input type="text" value="<%= escapeHtml(dto.getUser_id()) %>" readonly>
      </label>
      
      <label>요청 등급
        <input type="text" value="<%= dto.getRequested_grade() == 2 ? "인플루언서" : dto.getRequested_grade() %>" readonly>
      </label>

      <label>관리자 메모 (1000자 이하)
        <textarea name="adminNote" maxlength="1000" placeholder="승인 사유를 입력하세요"></textarea>
      </label>

      <div class="btns">
        <button type="submit" name="action" value="approve">승인 처리</button>
        <button type="button" onclick="history.back();">취소</button>
      </div>
    </form>
  </div>
</body>
</html>