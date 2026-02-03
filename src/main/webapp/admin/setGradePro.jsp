<%@page import="sm.data.AdminDTO"%>
<%@page import="sm.data.AdminDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Grade</title>
</head>
<body>
<%
	int grade = Integer.parseInt(request.getParameter("grade"));
	String user_id = request.getParameter("user_id");
	
	AdminDAO dao = AdminDAO.getInstance();
	AdminDTO dto = new AdminDTO();
	
	int result = dao.setGrade(user_id, grade);
	
	if(result == 1){
%>		
		<script type="text/javascript">
			alert("수정 되었습니다");
			window.location = "memberList.jsp";	
		</script>
<% 
	}
%>

</body>
</html>