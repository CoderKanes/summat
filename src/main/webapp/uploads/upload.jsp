<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
<html>
<head>
<meta charset="UTF-8">
<title>이미지 업로드</title>
</head>
<body>

<h2>이미지 업로드</h2>

<form action="upload.do" method="post" enctype="multipart/form-data">
    <input type="file" name="image"><br><br>
    <input type="submit" value="업로드">
</form>

</body>
</html>
