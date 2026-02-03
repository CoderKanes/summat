<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로필 이미지 업로드</title>
</head>
<body>
	<h2>프로필 이미지 업로드</h2>

	<!-- Multipart 폼: 파일 업로드 처리 -->
	<form action="profile_image_uploadPro.jsp" method="post" enctype="multipart/form-data">
		<label for="profile_image_url">이미지 선택</label>
		<input type="file" name="profile_image_url" id="profile_image_url" required />
		<br/><br/>
		<button type="submit">업로드</button>
	</form>
	
	<a href="mypage.jsp">마이페이지로 돌아가기</a>
</body>
</html>