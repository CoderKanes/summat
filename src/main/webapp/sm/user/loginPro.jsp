
<%@page import="sm.data.MemberDTO"%>
<%@page import="sm.data.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 처리</title>
</head>
<body>
		
<%
	MemberDTO dto = new MemberDTO();
	
	String user_id = request.getParameter("user_id");
	String password_hash = request.getParameter("password_hash");
	
	dto.setUser_id(user_id);
	dto.setPassword_hash(password_hash);
	
	MemberDAO dao = MemberDAO.getInstance();
	
	//isActiveUser 호출해서 user_status확인
	boolean isActive = dao.isActiveUser(user_id);
	//result에 dao.loginCheck넣을지 말지
	boolean result = false;
	//grade얻기
	session.setAttribute("grade", dao.getUserGrade(dto));
	//ACTIVE 로그인 체크 실행 DEACTIVE 실행 안함
	if(isActive){
		result = dao.loginCheck(dto);
	}else{
		result = false;
	}
	
	//result가 투루이면 세션에 id 저장 후 메인으로 보내기
	if(result){
		//아이디 저장
		session.setAttribute("sid", dto.getUser_id());
		response.sendRedirect("/summat/sm/main.jsp");
	}else{
%>		
		<script type="text/javascript">
			alert("아이디와 비밀번호를 확인하세요");
			history.go(-1);
		</script>
<%
	}	
%>
</body>
</html>