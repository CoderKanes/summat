<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:useBean id="dao" class="sm.data.PostDAO" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>맛집 리뷰 작성</h1>

	<% 
		//String c = dao.testSelectLast();
	%>

    제목: <input type="text" name="title" required><br><br>

    <div >
  
    </div>
    <input type="hidden" name="content" id="content"><br>

    이미지 선택: <input type="file" id="imageInput" multiple accept="image/*"><br><br>

    <button type="submit">등록</button>

</body>
</html>