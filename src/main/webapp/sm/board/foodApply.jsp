<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음식 정보 등록 신청</title>

<style>
    body {
        font-family: Arial, sans-serif;
    }

    .container {
        width: 900px;
        margin: 30px auto;
        border: 2px solid #000;
        padding: 20px;
    }

    .input-box {
        width: 100%;
        margin-bottom: 15px;
    }

    .input-box input {
        width: 100%;
        padding: 10px;
        font-size: 16px;
    }

    .menu-area {
        display: flex;
        gap: 20px;
        margin-top: 20px;
    }

    .menu-list {
        width: 60%;
        border: 2px solid #000;
        padding: 15px;
    }

    .menu-tags {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-top: 10px;
    }

    .tag {
        padding: 8px 12px;
        border: 1px solid #000;
        border-radius: 20px;
        cursor: pointer;
    }

    .preview-area {
        width: 40%;
        border: 2px solid #000;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 50px;
    }
</style>
</head>

<body>

<div class="container">

    <!-- 가게 이름 -->
    <div class="input-box">
        <input type="text" placeholder="가게 이름">
    </div>

    <!-- 전화번호 -->
    <div class="input-box">
        <input type="text" placeholder="전화번호">
    </div>

    <!-- 주소 -->
    <div class="input-box">
        <input type="text" placeholder="주소">
    </div>

    <!-- 메뉴 영역 -->
    <div class="menu-area">

        <!-- 메뉴 목록 -->
        <div class="menu-list">
            <h3>메뉴 목록</h3>

            <div class="menu-tags">
                <div class="tag">김치찌개</div>
                <div class="tag">된장찌개</div>
                <div class="tag">불고기</div>
                <div class="tag">비빔밥</div>
            </div>
        </div>

        <!-- 사진 / 정보 미리보기 -->
        <div class="preview-area">
            +
        </div>

    </div>

</div>

</body>
</html>