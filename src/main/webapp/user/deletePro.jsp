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
	//파라메터 받기
	String user_id = request.getParameter("user_id");
	String plainPassword = request.getParameter("password");
	
	//DTO생성 및 값 입력
	MemberDTO dto = new MemberDTO();
	dto.setUser_id(user_id);
	dto.setPassword_hash(plainPassword);
	
	//메세지 및 페이지 저장 변수 
	String msg;
	String pg;
	
	//상태 변경값
	String user_status = "DEACTIVE";
	
	//DAO생성 및 불러오기
	MemberDAO dao = MemberDAO.getInstance();
	boolean res = dao.memberDeactivated(dto, user_status);
	
	if(res){
		msg = "회원 탈퇴 처리가 되었습니다";
		pg = "logoutPro.jsp";
	}else{
		msg = "비밀번호를 다시 확인해 주십시오";
		pg = "deleteForm.jsp";
	}
%>
	<h1>회원 탈퇴 결과</h1>
	<p><%=msg %></p>
	<a href="<%=pg %>">다음</a>

</body>
</html>