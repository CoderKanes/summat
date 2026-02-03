<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 작성</title>

<style>
    body {
        font-family: Arial;
    }
    table {
        width: 500px;
        margin: 50px auto;
        border-collapse: collapse;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 10px;
    }
    th {
        width: 100px;
        background-color: #f2f2f2;
        text-align: center;
    }
    input[type=text], textarea {
        width: 95%;
    }
    .btn {
        text-align: center;
    }
</style>
</head>

<body>

<h2 align="center">글 작성</h2>

<form action="writeProc.jsp" method="post">
    <table>
        <tr>
            <th>제목</th>
            <td>
                <input type="text" name="title" required>
            </td>
        </tr>

		<%
		String id = (String)session.getAttribute("sid");
		if(id==null){ %>
        <tr>
            <th>작성자</th>
            <td>
                <input type="text" name="writer" required>
            </td>
        </tr>
		<%}else{%>

        <tr>
            <th>작성자ID</th>
            <td>
                <input type="text" name="id" required>
            </td>
        </tr>
		<%}%>


        <tr>
            <th>내용</th>
            <td>
                <textarea name="content" rows="10" required></textarea>
            </td>
        </tr>

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