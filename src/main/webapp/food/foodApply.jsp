  <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- foodApply.jsp -->
<html>
<head>
<meta charset="UTF-8">

<!-- 폼 화면 게시글 작성 화면  -->
<title>음식 정보 신청</title>

<script>
function openPhotoPopup(menuIndex) {
    window.open(
        "photoPopup.jsp?idx=" + menuIndex,
        "photoPopup",
        "width=400,height=450"
    );
}

// photoPopup.jsp 에서 호출
function setMenuImage(idx, fileName) {
    document.getElementById("menuImage_" + idx).value = fileName;
}
</script>

<style>
    body { font-family: Arial; padding: 30px; }
    .menu-box { margin-bottom: 10px; }
</style>

</head>
<body>

<h2>음식 정보 등록 신청</h2>

<form action="foodApplypro.jsp" method="post">

    <!-- 가게 정보 -->
    <h3>가게 정보</h3>
    <input type="text" name="storeName" placeholder="가게 이름" required><br><br>
<input type="text" name="phone" placeholder="전화번호"><br><br>
    <input type="text" name="address" placeholder="주소"><br><br>

    <!-- 메뉴 정보 -->
    <h3>메뉴 정보</h3>

    <div class="menu-box">
    <input type="text" name="menuName" placeholder="메뉴 이름">

    <!-- 실제 파일 선택 -->
    <input type="file" id="file_1" accept="image/*" style="display:none"
           onchange="previewImage(this, 1)">

    <!-- 파일명 저장용 (pro.jsp로 넘어감) -->
    <input type="hidden" name="menuImage" id="menuImage_1">

    <!-- 미리보기 이미지 -->
    <img id="preview_1" src="" style="width:100px;height:100px;display:none;border:1px solid #ccc;">

    <!-- + 버튼 -->
    <button type="button" onclick="document.getElementById('file_1').click()">+</button>
</div>

    <br>
    <button type="submit">신청하기</button>

</form>

</body>
</html>
