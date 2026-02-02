<%@page import="sm.data.MemberDAO"%>
<%@page import="sm.data.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String user_id = request.getParameter("user_id");
	String username = request.getParameter("username");
	String email = request.getParameter("email");
	String phone = request.getParameter("phone");
	String address = request.getParameter("address");
	String resident_registration_number = request.getParameter("resident_registration_number");
	String password_hash = request.getParameter("password_hash");

	MemberDTO dto = new MemberDTO();
	MemberDAO dao = MemberDAO.getInstance();
	
	dto.setUser_id(user_id);
	dto.setUsername(username);
	dto.setEmail(email);
	dto.setAddress(address);
	dto.setPhone(phone);
	dto.setResident_registration_number(resident_registration_number);
	dto.setPassword_hash(password_hash);
	
	dao.infoUpdate(dto);
%>
<script type="text/javascript">
	alert("수정되었습니다");
	window.location = 'mypage.jsp';
</script>

</body>
</html>