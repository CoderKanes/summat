
<%@page import="java.util.UUID"%>
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
	//이렇게 수정하면 바로 반영이 되야되는데....
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
		//인증여부
		session.setAttribute("authenticated", true);
		//시간 30분
		session.setMaxInactiveInterval(30 * 60);
		
		//쿠키 처리
		//체크박스 체그확인
		String remember = request.getParameter("rememberMe");
		if("on".equals(remember)){
			//토큰생성
			//				id + 랜덤 글자 Ex) java|fjdiao1341234ji의 형태
			String token = dto.getUser_id() + "|" + UUID.randomUUID().toString();
			//쿠킹에 토큰 저장
			Cookie rememberCookie = new Cookie("rememberMe", token);
			//리멤버 쿠키 모든 브라우저에 전달
			rememberCookie.setPath("/");
			//7일
			rememberCookie.setMaxAge(7 * 24 * 60 * 60);
			//보안설정
			rememberCookie.setHttpOnly(true);
			//hppts일 때에만 응답
			rememberCookie.setSecure(request.isSecure());
			response.addCookie(rememberCookie);
		}
		
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