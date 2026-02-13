<%@page import="java.net.SecureCacheResponse"%>
<%@page import="java.util.List"%>
<%@page import="sm.data.AdminDAO"%>
<%@page import="sm.data.AdminDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원리스트</title>
<style>  
	/* main.jsp와 어울리는 기본 스타일 */  
	.toolbar {
    display: flex;
    flex-wrap: nowrap;     /* 한 줄로 유지하다가 공간이 부족하면 줄바꿈 가능하게 하려면 wrap으로 바꿔도 됨 */
    align-items: center;
    gap: 12px;
    margin: 12px 0 20px;
    padding: 8px;
    border: 1px solid #e0e0e0;
    border-radius: 6px;
    background: #fff;
  }

  .toolbar .section {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 6px 10px;
    border-right: 1px solid #eee; /* 구분선 느낌 */
  }
  .toolbar .section:last-child {
    border-right: none;
  }

  .toolbar label {
    font-size: 14px;
  }

  .toolbar input[type="text"],
  .toolbar select {
    padding: 6px 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
  }

  .btn {
    padding: 8px 12px;
    border-radius: 4px;
    border: none;
    background: #2d7be6;
    color: #fff;
    cursor: pointer;
  }

  /* 필요시 반응형 처리: 좁아지면 두 영역이 자동으로 줄바꿈되도록 */
  @media (max-width: 900px) {
    .toolbar { flex-wrap: wrap; }
    .toolbar .section { border-right: none; padding-right: 0; padding-left: 0; }
  }
	body { font-family: Arial, sans-serif; color: #333; margin: 20px; background-color: #f8f8f8; }  
	h1 { font-size: 1.6rem; margin-bottom: 16px; }  
	.panel { background: #fff; border: 1px solid #ddd; border-radius: 6px; padding: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }  
	table { border-collapse: collapse; width: 100%; }  
	th, td { border: 1px solid #ddd; padding: 8px 12px; text-align: left; }  
	thead { background: #f0f2f5; }  
	tr:nth-child(even) { background: #fafafa; }  
	.note { font-size: 0.9rem; color: #666; margin-top: 12px; }  
	.no-data { padding: 12px; color: #666; }  
	/* 버튼 등 추가 요소가 필요하면 아래에 스타일 추가 */  
	.btn { display: inline-block; padding: 8px 12px; background: #2d7be6; color: #fff; border-radius: 4px; text-decoration: none; }  
</style> 
</head>
<body>
	<h1>회원리스트</h1>
<%
	//얘는 그냥 시험용 
	//String sid = (String)session.getAttribute("sid");
	int grade = (int)session.getAttribute("grade");	

	boolean isAdmin = false;
	/*
	if("admin".equalsIgnoreCase(sid)){
		isAdmin = true;
	} 
	*/
	//grade비교
	if(grade == 0){
		isAdmin = true;
	}
	
	if(!isAdmin){
		response.sendRedirect("/summat/main/main.jsp");
	}
	
	
	
	AdminDAO dao = AdminDAO.getInstance();
	
	String searchQuery = request.getParameter("searchQuery");
	String sortField = request.getParameter("sortField");
	String sortDir = request.getParameter("sortDir");
	
	int pageSize = 20;
	
	int pageGroupSize = 7;
	
	String pageNum = request.getParameter("pageNum");
	
	if(pageNum == null){
		pageNum = "1";
	}
	//문자열 숫자로 바꾸기 
	int currentPage = Integer.parseInt(pageNum);
	
	int totalCount = 0;
	int totalPage = 0;
	
	totalCount = dao.getAllCount(searchQuery);
	
	out.println(totalCount);
	
	totalPage = (int)Math.ceil((double)totalCount / pageSize);
	//페이지 네비게이션 범위
	int startPage = Math.max(1, currentPage - (pageGroupSize / 2));
	int endPage = Math.min(totalPage, startPage + pageGroupSize - 1);
	
	if(endPage - startPage + 1 < pageGroupSize){
		startPage = Math.max(1, endPage - pageGroupSize + 1);
	}
	
	//dao로 보낼 start와 end값
	int start = (currentPage - 1) * pageSize;
	int end = currentPage * pageSize;
	
	List<AdminDTO> list = dao.getMemberList(start, end, sortField, sortDir, searchQuery);
	
	
%>
	<!-- 한 줄로 배치된 검색+정렬 영역 -->
  <div class="toolbar" role="toolbar" aria-label="검색 및 정렬 도구">
    <!-- 검색 영역 (왼쪽 영역) -->
    <div class="section" style="border-right:1px solid #eaeaea;">
      <form id="searchForm" method="get" action="memberList.jsp" style="display:flex; align-items:center; gap:6px;">
        <label for="searchQuery" style="margin:0;">검색</label>
        <input type="text" id="searchQuery" name="searchQuery" placeholder="아이디/이름 ..." value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "" %>"/>
        <button type="submit" class="btn">검색</button>
      </form>
    </div>

    <!-- 정렬 영역 (오른쪽 영역) -->
    <div class="section" style="border-right: none;">
      <form id="sortForm" method="get" action="memberList.jsp" style="display:flex; align-items:center; gap:6px;">
        <label for="sortField" style="margin:0 0 0 6px;">정렬기준</label>
        <select name="sortField" id="sortField">
          <option value="created_at" <%= "created_at".equals(request.getParameter("sortField")) ? "selected" : "" %>>생성일</option>
          <option value="user_id" <%= "user_id".equals(request.getParameter("sortField")) ? "selected" : "" %>>아이디</option>
          <option value="username" <%= "username".equals(request.getParameter("sortField")) ? "selected" : "" %>>이름</option>
          <option value="grade" <%= "grade".equals(request.getParameter("sortField")) ? "selected" : "" %>>등급</option>
          <option value="user_status" <%= "user_status".equals(request.getParameter("sortField")) ? "selected" : "" %>>상태</option>
        </select>

        <label for="sortDir" style="margin:0 0 0 6px;">정렬방향</label>
        <select name="sortDir" id="sortDir">
          <option value="asc" <%= "asc".equals(request.getParameter("sortDir")) ? "selected" : "" %>>오름차순</option>
          <option value="desc" <%= "desc".equals(request.getParameter("sortDir")) ? "selected" : "" %>>내림차순</option>
        </select>

        <button type="submit" class="btn">적용</button>
      </form>
    </div>
    
     <!-- 추가: 관리자 페이지 버튼 (오른쪽 끝) -->
    <div class="section" style="border-right: none; margin-left: auto;">
      <button type="button" class="btn" onclick="location.href='dashboard.jsp'">관리자 페이지</button>
    </div>
    
  </div>
	
	<table>
		<thead>
			<tr>
				<th>User ID</th>
				<th>Username</th>
				<th>Email</th>
				<th>Phone</th>
				<th>Address</th>
				<th>Resident Registration</th>
				<!-- 보안상 필요 시 제거 -->
				<th>Password Hash</th>
				<th>Password Salt</th>
				<th>User Status</th>
				<th>Email Verified</th>
				<th>Phone Verified</th>
				<th>Created At</th>
				<th>Updated At</th>
				<th>Last Login</th>
				<th>Password Changed At</th>
				<th>Grade</th>
			</tr>
		</thead>
		
		<tbody>
<%
			for(AdminDTO dto : list){
%>
			<tr>
				<td><%=dto.getUser_id() %></td>
				<td><%=dto.getUsername() %></td>
				<td><%=dto.getEmail() %></td>
				<td><%=dto.getPhone() %></td>
				<td><%=dto.getAddress() %></td>
				<td><%=dto.getResident_registration_number() %></td>
				<td><%=dto.getPassword_hash() %></td>
				<td><%=dto.getPassword_salt() %></td>
				<td>
					<form action="adminDeletePro.jsp" method="post">
						<input type="hidden" name="user_id" value="<%=dto.getUser_id() %>"/>
						<select name="user_status">
							<option value="ACTIVE" <%= "ACTIVE".equals(dto.getUser_status()) ? "selected" : "" %>>활성</option>
							<option value="DEACTIVE" <%= "DEACTIVE".equals(dto.getUser_status()) ? "selected" : "" %>>탈퇴</option>
							<option value="STOPPED" <%= "STOPPED".equals(dto.getUser_status()) ? "selected" : "" %>>정지</option>
						</select>
						<%=dto.getUser_status() %>
						<input type="submit" value="수정"/>
					</form>
					<hr/>
					<form action="memberDBDeletePro.jsp">
						<input type="hidden" name="user_id" value="<%=dto.getUser_id() %>"/>
						<input type="submit" value="삭제"/>
					</form>
					
				</td>
				<td><%=dto.getEmail_verified() %></td>
				<td><%=dto.getPhone_verified() %></td>
				<td><%=dto.getCreated_at() %></td>
				<td><%=dto.getUpdated_at() %></td>
				<td><%=dto.getLast_login_at() %></td>
				<td><%=dto.getPassword_changed_at() %></td>
				<td>
					<form action="setGradePro.jsp" method="post">
						<input type="hidden" name="user_id" value="<%=dto.getUser_id() %>"/>
						<select name="grade">
							<option value="0" <%=dto.getGrade() == 0 ? "selected" : "" %>>관리자</option>
							<option value="1" <%=dto.getGrade() == 1 ? "selected" : "" %>>일반회원</option>
							<option value="2" <%=dto.getGrade() == 2 ? "selected" : "" %>>인플루언서</option>
							<option value="3" <%=dto.getGrade() == 3 ? "selected" : "" %>>기자</option>
						</select>
						<%=dto.getGrade() %>
						<input type="submit" value="수정"/>
					</form>
					
				</td>
			</tr>
<%
	}
%>
		</tbody>
	</table>		
	
	<!-- 페이징 UI -->
	
	
	<div class="pagination">
<%
		 if (currentPage-5 >= 1) {
%>
  		 	<a href="memberList.jsp?pageNum=<%=currentPage-5%>">[<<] </a>
<%
   }
   		if (currentPage > 1) {
%>
   			<a href="memberList.jsp?pageNum=<%=currentPage-1%>">[<] </a>
<%
   		}
   		for (int i = startPage ; i <= endPage ; i++) {
      		if(i == currentPage){
%>
      			<a href="memberList.jsp?pageNum=<%= i %>"><font color="#b84a4a">[<%= i %>]</font></a>   
<%
      		}else{
%>
				<a href="memberList.jsp?pageNum=<%= i %>">[<%= i %>]</a>   
<%
      		}
   		}
   		if (currentPage < totalPage) {
%>
      		<a href="memberList.jsp?pageNum=<%=currentPage+1%>"> [>]</a>
<%
   		}
   		if (currentPage+5 <= totalPage) {
%>
      		<a href="memberList.jsp?pageNum=<%=currentPage+5%>"> [>>]</a>
<%
   		}
%>		

	</div>
</div>
	
</body>
</html>