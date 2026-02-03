<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.Part" %>
<%@ page import="sm.data.StoreDTO, sm.data.StoreDAO" %>
<%@ page import="sm.data.MenuDAO, sm.data.MenuDTO" %>

<%
    String idx = request.getParameter("idx");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사진 등록</title>

<script>
function sendImage() {
    const fileInput = document.getElementById("imageFile");
    if (!fileInput.files[0]) {
        alert("사진을 선택하세요");
        return;
    }

    opener.setMenuImage("<%=idx%>", fileInput.files[0].name);
    window.close();
}
</script>
</head>
<body>

	<h3>메뉴 사진 선택</h3>

	<input type="file" id="imageFile" accept="image/*">
	<br>
	<br>
	<!-- 이 부분 수정해야 됨 2/3일날  -->
	<button onclick="location.href='foodlist.jsp'">등록</button>
	<button type="button" onclick="window.close()">취소</button>

</body>
</html>
<!-- foodApplyPro.jsp -->


<%
    request.setCharacterEncoding("UTF-8");

    String storeName = request.getParameter("storeName");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String menuName = request.getParameter("menuName");
    String menuImage = request.getParameter("menuImage");

    // DAO 연결 후 DB 저장 처리
%>

 
<%

    // 가게 저장
    
    StoreDTO storeDto = new StoreDTO();
    storeDto.setStoreName(storeName);
    storeDto.setPhone(phone);
    storeDto.setAddress(address);

    StoreDAO storeDao = new StoreDAO();
    int storeId = storeDao.insertStore(storeDto);
    System.out.println("storeId 결과값 = " + storeId);
    
%>


<html>
<head>
<meta charset="UTF-8">
<title>음식 정보 신청 완료</title>
<style>
    body { font-family: Arial; padding: 30px; }
    .box {
        border: 1px solid #ccc;
        padding: 20px;
        width: 500px;
    }
    h3 { margin-top: 0; }
</style>
</head>
<body>

<div class="box">
    <h3>음식 정보 신청 완료</h3>

    <p><strong>가게 이름:</strong> <%= storeName %></p>
    <p><strong>전화번호:</strong> <%= phone %></p>
    <p><strong>주소:</strong> <%= address %></p>

    <hr>

    <p><strong>메뉴 이름:</strong> <%= menuName %></p>
    <p><strong>메뉴 이미지:</strong> <%= menuImage %></p>

    <br>
    <button onclick="location.href='foodApply.jsp'">다시 신청</button>
    <button onclick="location.href='index.jsp'">메인으로</button>
</div>

</body>
</html>