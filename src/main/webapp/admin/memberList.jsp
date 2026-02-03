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
	String sid = (String)session.getAttribute("sid");

	boolean isAdmin = false;
	
	if("admin".equalsIgnoreCase(sid)){
		isAdmin = true;
	} 
	
	if(!isAdmin){
		response.sendRedirect("/summat/sm/main.jsp");
	}

	AdminDAO dao = AdminDAO.getInstance();
	
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
	
	totalCount = dao.getAllCount();
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
	
	List<AdminDTO> list = dao.getMemberList(start, end);
	
	
%>
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
   			<a href="postList.jsp?pageNum=<%=currentPage-1%>">[<] </a>
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