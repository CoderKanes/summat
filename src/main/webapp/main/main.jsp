<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="sm.data.MenuDAO"%>
<%@ page import="sm.data.MenuDTO"%>
<%--
    작성자 : 김용진, 김동욱
    내용 : 메인페이지. 기본적인 진입방식으로 접근했을때 가장 처음 보여줄 페이지. 
    	  저장된 쿠키를 불러와 자동 로그인.
--%>

<%
	//통합검색
	String totalSearch = request.getParameter("totalSearch")!=null? request.getParameter("totalSearch") : null;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>맛집 페이지 테마 샘플</title>
	<link href="/summat/resources/css/style.css" style="text/css" rel="stylesheet" />
	<style>
.slider {
  position: relative;
  width: 800px;
  height: 100px;
  overflow: hidden;
  margin: 16px auto;
  margin-top:5px;
  
  border-radius: 5px;
  border: 1px solid #ccc;
}

.slides {
  display: flex;
  height: 100%;
  transition: transform 0.4s ease;
}

.slide {
  flex: 0 0 100%;
  width: 100%;
  height: 100%;
}

.slide img {
  width: 800px;
  height: 100px;
  object-fit: cover;
  -webkit-user-drag: none;
  user-drag: none;
  pointer-events: none;
}

.prev, .next {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  z-index: 10;

  background: transparent;   /* 🔥 네모 제거 */
  border: none;
  padding: 0;

  font-size: 30px;            /* 화살표 키움 */
  font-weight: 900;
  color: rgba(255, 255, 255, 0.9);

  cursor: pointer;

  text-shadow:
    0 0 4px rgba(0,0,0,0.8),
    0 0 8px rgba(0,0,0,0.6),
    0 0 12px rgba(0,0,0,0.4);

  transition: transform 0.2s ease, opacity 0.2s ease;
}

.prev { left: 16px; }
.next { right: 16px; }

.prev:hover,
.next:hover {
  transform: translateY(-50%) scale(1.15);
  opacity: 0.9;
  filter: drop-shadow(0 0 8px rgba(255,255,255,0.6));
}

.slider {
  cursor: grab;
}

.slider:active {
  cursor: grabbing;
}
.slider,
.slider * {
  user-select: none;
  -webkit-user-select: none;
}


.main-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 32px;
  max-width: 1200px;
  margin: 60px auto 0;
}

.main-card-link {
  display: block;
  text-decoration: none;
}

.main-card {
  background: transparent; /* 흰 판 제거 */
  border-radius: 20px;
  overflow: hidden;        /* 이미지 라운드 처리 */
  box-shadow: 0 10px 24px rgba(0,0,0,0.08);
  transition: transform 0.25s ease, box-shadow 0.25s ease;
}

.main-card img {
  width: 100%;
  height: 220px;
  object-fit: cover;
  display: block; /* inline 제거 → 중심 잡힘 */
}

.main-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 16px 36px rgba(0,0,0,0.14);
}
@media (max-width: 900px) {
  .main-cards {
    grid-template-columns: 1fr;
    gap: 20px;
  }
}
	</style>
</head>

<body>
	<jsp:include page="topBar.jsp"></jsp:include>

	<div class="container">
		<main id="mainContent">
			<%if(totalSearch==null){ 
				MenuDAO mdao = new MenuDAO();
				int menuId = mdao.getRandomMenuId();
				if(menuId == 0) menuId=91;
			
			%>
				<div class="slider">
				  <div class="slides"></div>				
				  <button class="prev">◀</button>
				  <button class="next">▶</button>
				</div>
	
			<div class="main-cards">
			  <a href="/summat/food/foodView.jsp?menuId=<%=menuId%>" class="main-card-link">
			    <div class="main-card">
			      <img src="/summat/resources/image/recommedMenu.PNG" alt="추천 메뉴">
			    </div>
			  </a>
			
			  <a href="/summat/post/postMain.jsp?postListOrderType=VIEW" class="main-card-link">
			    <div class="main-card">
			      <img src="/summat/resources/image/favoPost.PNG" alt="인기 포스트">
			    </div>
			  </a>
			
			  <a href="/summat/post/postMain.jsp?postListOrderType=LIKE" class="main-card-link">
			    <div class="main-card">
			      <img src="/summat/resources/image/recommedPost.PNG" alt="추천 포스트">
			    </div>
			  </a>
			</div>
			
	
				<!-- 리스트 -->
				<h2>최신 포스트</h2>
				<jsp:include page="/post/postList.jsp" >
					<jsp:param name="showWriteBtn" value="false"/>
					<jsp:param name="showPageNavi" value="false"/>
					<jsp:param name="pagePostCount" value="4"/>
				</jsp:include>	 
				<br />
			<%}else{ %>
				<h2>음식정보 검색결과</h2>
				<jsp:include page="/food/food_List.jsp" >
					<jsp:param name="encodeKeyword" value='<%= java.net.URLEncoder.encode(totalSearch, "UTF-8") %>'/>					
				</jsp:include>	 
				<br />
				
				<h2>포스트 검색결과</h2>
				<jsp:include page="/post/postList.jsp">
					<jsp:param name="searchType" value="ALL"/>
					<jsp:param name="encodeKeyword" value='<%= java.net.URLEncoder.encode(totalSearch, "UTF-8") %>'/>					
				</jsp:include>	 
				<br />
			<%} %>
		</main>
	</div>


<script>

let autoTimer = null;
const AUTO_DELAY = 3000;

function startAutoSlide() {
	  stopAutoSlide();
	  autoTimer = setInterval(() => {
	    moveSlide(currentIndex + 1);
	  }, AUTO_DELAY);
	}

	function stopAutoSlide() {
	  if (autoTimer) {
	    clearInterval(autoTimer);
	    autoTimer = null;
	  }
	}
/* ===== THEME ===== */
const themes = [
  { header:"#4E342E", side:"#FAF7F2", main:"#F3EFEA", card:"#FFFFFF", point:"#FF8A00" },
  { header:"#5C6D63", side:"#F3EFEA", main:"#EAEDE9", card:"#FFFFFF", point:"#D4A017" },
  { header:"#8C1D18", side:"#F7F7F7", main:"#EFEFEF", card:"#FFFFFF", point:"#C62828" },
  { header:"#1F2A44", side:"#FFFFFF", main:"#F2F4F8", card:"#FFFFFF", point:"#4A6CF7" }
];

let current = 0;
function changeTheme() {
  current = (current + 1) % themes.length;
  const t = themes[current];
  document.documentElement.style.setProperty('--header-bg', t.header);
  document.documentElement.style.setProperty('--side-bg', t.side);
  document.documentElement.style.setProperty('--main-bg', t.main);
  document.documentElement.style.setProperty('--card-bg', t.card);
  document.documentElement.style.setProperty('--point', t.point);
}

const banners = [
	  { img: "/summat/resources/image/SmmtBanner.png", link: "/summat/board/list.jsp" },
	  { img: "/summat/resources/image/GlobalIT.png", link: "https://gith.co.kr/" },
	  { img: "/summat/resources/image/SmmtBanner2.png", link: "" }
	];

const slides = document.querySelector(".slides");
const slider = document.querySelector(".slider");
let currentIndex = 0;
const total = banners.length;

/* 슬라이드 생성 */
banners.forEach(item => {
  const slide = document.createElement("div");
  slide.className = "slide";

  const img = document.createElement("img");
  img.src = item.img;

  if (item.link) {
    img.addEventListener("click", () => {
      window.location.href = item.link;
    });
  }

  slide.appendChild(img);
  slides.appendChild(slide);
});


function moveSlide(index) {
  currentIndex = (index + total) % total;
  slides.style.transform = `translateX(-\${currentIndex * 100}%)`;
}

/* 버튼 */
document.querySelector(".prev").addEventListener("click", e => {
  e.stopPropagation();   // 🔥 링크 이벤트 차단
  moveSlide(currentIndex - 1);
  startAutoSlide(); 
});

document.querySelector(".next").addEventListener("click", e => {
  e.stopPropagation();   // 🔥 링크 이벤트 차단
  moveSlide(currentIndex + 1);
  startAutoSlide(); 
});

/* =========================
   모바일 스와이프
========================= */
let startX = 0;
let endX = 0;
let isDragging = false;
let dragged = false;

slider.addEventListener("touchstart", e => {
  startX = e.touches[0].clientX;
  isDragging = true;
});

slider.addEventListener("touchend", e => {
  if (!isDragging) return;

  const endX = e.changedTouches[0].clientX;
  const diff = startX - endX;

  if (diff > 50) moveSlide(currentIndex + 1); // 왼쪽 스와이프
  if (diff < -50) moveSlide(currentIndex - 1); // 오른쪽 스와이프

  isDragging = false;
});

let currentX = 0;

slider.addEventListener("mousedown", e => {
	  e.preventDefault();
	  stopAutoSlide();   
	  startX = e.clientX;
	  isDragging = true;
	  dragged = false;
});

slider.addEventListener("mousemove", e => {
	  if (!isDragging) return;
	  endX = e.clientX;
	  if (Math.abs(startX - endX) > 10) {
	    dragged = true;
	  }
});

slider.addEventListener("mouseup", e => {
	  if (!isDragging) return;

	  
	  const diff = startX - endX;

	  if (dragged) {
	    if (diff > 50) moveSlide(currentIndex + 1);
	    else if (diff < -50) moveSlide(currentIndex - 1);
	  } else {
		  handleLinkClick(currentIndex, e); // ⭐ e 전달
	  }

	  isDragging = false;
	  startAutoSlide(); 
});

function handleLinkClick(index, event) {
	  if (event.target.closest(".prev, .next")) return;

	  const link = banners[index].link;
	  if (!link) return;

	  const isExternal = /^https?:\/\//.test(link);

	  if (isExternal) {
	    window.open(link, "_blank");
	  } else {
	    window.location.href = link;
	  }
	}

slider.addEventListener("mouseenter", () => {
	  stopAutoSlide();
});

slider.addEventListener("mouseleave", () => {
	  startAutoSlide();
	  isDragging = false;
	  slider.classList.remove("dragging");
});


startAutoSlide();
</script>

</body>
</html>