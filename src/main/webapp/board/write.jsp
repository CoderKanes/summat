<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <link href="/summat/resources/css/style.css" style="text/css" rel="stylesheet" />
<%--
	작성자 : 신동엽
	   내용 : 게시글 작성 페이지 (write.jsp)
	       - 게시글 제목, 작성자, 내용 입력 폼 제공
	       - 작성 완료 시 writeProc.jsp로 데이터 전송
	       
📌 사용자 기능
1. 게시글 작성
   - 제목, 작성자, 내용, 비밀번호 입력 폼 제공
   - 작성 완료 시 writeProc.jsp로 데이터 전송

📌 구현 방법
1. HTML form 사용
   - method="post"로 writeProc.jsp에 데이터 전송
   - input과 textarea로 게시글 정보 입력
2. 입력 필드 유효성
   - required 속성 사용으로 빈 값 제출 방지
3. 버튼 처리
   - "작성하기" → form 제출
   - "취소" → history.back()으로 이전 페이지 이동
--%>

<html>
<head>
<meta charset="UTF-8">
<title>글 작성</title>

<style>
    /* 1️ 기본 폰트 설정 */
    body {
        font-family: Arial;
    }
	/* 2️ 테이블 레이아웃 설정 */
    table {
        width: 500px;
        margin: 50px auto;
        border-collapse: collapse;
    }
        /* 3️ 테이블 셀 스타일 */
    th, td {
        border: 1px solid #ccc;
        padding: 10px;
    }
        /* 4️ 제목 셀 스타일 */
    th {
        width: 100px;
        background-color: #f2f2f2;
        text-align: center;
    }
        /* 5️ 입력 필드 너비 */
    input[type=text], textarea {
        width: 95%;
    }
        /* 6️ 버튼 정렬 */
    .btn {
        text-align: center;
    }
</style>
</head>

<body>

<h2 align="center">글 작성</h2> 
				<%-- 1 게시글 작성 폼 시작 --%>
<form action="writeProc.jsp" method="post">

			<table>
    
    	       		<%--2 제목 입력 필드 --%>
        	<tr>
            <th>제목</th>
            <td>
                <input type="text" name="title" required>
            </td>
        	</tr>
             	   <%-- 3 작성자 입력 필드 --%>
     	   <tr>
		   <th>작성자</th>
   		   <td>
                <input type="text" name="writer" required>
 		   </td>
      	   </tr>
        
        
                	<%-- 4 내용 입력 필드 --%>
        	<tr>
            <th>내용</th>
            <td>
                <textarea name="content" rows="10" required></textarea>
            </td>
			</tr>
			        <%-- 5 비밀번호 입력 필드 --%>
			<tr>
			<th>비밀번호</th>
			<td>
                <input type="text" name="password" required>
           </td>
      	   </tr>
      			    <%-- 6 제출/취소 버튼 --%>
	        <tr>
        	<tr>
				<td colspan="2" class="btn">
                <input type="submit" value="작성하기">
                <input type="button" value="취소" onclick="history.back()">
            </td>
			</tr>
			
			
			</table>
</form>

</body>
</html>