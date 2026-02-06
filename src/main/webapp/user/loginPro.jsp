
<%@page import="java.util.UUID"%>
<%@page import="sm.data.MemberDTO"%>
<%@page import="sm.data.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%--
	작성자 : 김동욱
	내용 : 로그인 로직 처리 및 세션 / 쿠키 저장
--%>    
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
	String plainPassword = request.getParameter("password");//비번 받아서 
	
	
	
	dto.setUser_id(user_id);
	
	dto.setPassword_hash(plainPassword);
	
	MemberDAO dao = MemberDAO.getInstance();
	
	//isActiveUser 호출해서 user_status확인
	boolean isActive = dao.isActiveUser(user_id);
	//result에 dao.loginCheck넣을지 말지
	boolean result = false;
	//grade얻기
	session.setAttribute("grade", dao.getUserGrade(dto));
	int gradeValue = dao.getUserGrade(dto);
	
	//ACTIVE 로그인 체크 실행 DEACTIVE 실행 안함
	//일반 로그인 체크
	if(isActive){
		result = dao.loginCheck(dto);
	}else{
		result = false;
	}
	//해시 솔트 후 비번 체크
	if(isActive){
		result = dao.loginCheck(user_id, plainPassword);
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
			//grade 쿠키 생성 및 저장
			Cookie gradeCookie =  new Cookie("userGrade", String.valueOf(gradeValue));
			//리멤버 쿠키 모든 브라우저에 전달
			rememberCookie.setPath("/");
			gradeCookie.setPath("/");
			//7일
			rememberCookie.setMaxAge(7 * 24 * 60 * 60);
			gradeCookie.setMaxAge(7 * 24 * 60 * 60);
			//보안설정
			rememberCookie.setHttpOnly(true);
			gradeCookie.setHttpOnly(true);
			//hppts일 때에만 응답
			rememberCookie.setSecure(request.isSecure());
			gradeCookie.setSecure(request.isSecure());
			
			response.addCookie(rememberCookie);
			response.addCookie(gradeCookie);
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