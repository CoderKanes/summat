<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="sm.data.MemberDAO" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이미지 업로드</title>
</head>
<body>
<%
	//경로
	String path = request.getRealPath("resources/profile");
	//크기 10메가
	int max = 1024 * 1024 * 10;
	//인코딩
	String enc = "UTF-8";
	//중복처리
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	//객체 생성
	MultipartRequest mr = new MultipartRequest(request, path, max, enc, dp);
	//파일 타입 및 이름 저장
	String fileType = mr.getContentType("profile_image_url");
	
	File f = mr.getFile("profile_image_url");
	//이미지만 받기
	//파일명은 보통 이런 형식 image/png  , image/jpg , image/gif
	// '/' 얘 기준으로 자르자
	String [] type = fileType.split("/");
	//이미지 파일이 아니면 지워
	if(!type[0].equals("image")){
		f.delete();
	}
	//session에 있는 아이디 저장하고 
	String user_id =  (String)session.getAttribute("sid");
	String profile_image_url = mr.getFilesystemName("profile_image_url");
	
	MemberDAO dao = MemberDAO.getInstance();
	dao.profile(user_id, profile_image_url);
	
	response.sendRedirect("mypage.jsp");
%>
</body>
</html>