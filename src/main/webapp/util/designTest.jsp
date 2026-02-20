<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

* {
  box-sizing: border-box;
  font-family: 'Pretendard', sans-serif;
}

body {
  margin: 0;
  background: #f9f9f9;
}

/* HEADER */
.header {
  background: #fff;
  border-bottom: 1px solid #e5e5e5;
}

.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 20px;
}

.top-bar .left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.top-bar input {
  width: 280px;
  padding: 8px 12px;
  border-radius: 8px;
  border: 1px solid #ddd;
}

.main-nav ul {
  display: flex;
  gap: 24px;
  padding: 10px 20px;
  margin: 0;
  list-style: none;
}

.main-nav li {
  cursor: pointer;
  color: #555;
}

.main-nav li.active {
  color: #ff6b35;
  font-weight: 600;
}

/* CONTENT */
.content {
  padding: 24px 20px;
}

.section {
  margin-bottom: 40px;
}

.section h2 {
  margin-bottom: 16px;
}

/* CARDS */
.card-row {
  display: flex;
  gap: 16px;
  overflow-x: auto;
}

.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 16px;
}

.card,
.list-card {
  background: #fff;
  border-radius: 12px;
  padding: 16px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
}

</style>

</head>


<body>
  <header class="header">
    <div class="top-bar">
      <div class="left">
        <button class="home-btn">🏠</button>
        <input type="text" placeholder="검색어를 입력하세요" />
      </div>
      <div class="right">
        <button class="login-btn">로그인</button>
      </div>
    </div>

    <nav class="main-nav">
      <ul>
        <li class="active">홈</li>
        <li>음식점</li>
        <li>포스트</li>
        <li>커뮤니티</li>
      </ul>
    </nav>
  </header>

  <main class="content">
    <section class="section">
      <h2>🔥 인기 포스트</h2>
      <div class="card-row">
        <div class="card">포스트 카드</div>
        <div class="card">포스트 카드</div>
      </div>
    </section>

    <section class="section">
      <h2>🆕 최신 포스트</h2>
      <div class="card-column">
        <div class="list-card">포스트</div>
        <div class="list-card">포스트</div>
      </div>
    </section>

    <section class="section">
      <h2>⭐ 평점 높은 음식점</h2>
      <div class="card-grid">
        <div class="card">음식점</div>
        <div class="card">음식점</div>
      </div>
    </section>

    <section class="section">
      <h2>📍 내 위치 근처 음식점</h2>
      <div class="card-column">
        <div class="list-card">음식점</div>
      </div>
    </section>
  </main>
</body>

</html>