<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.MenuCategoryDAO"%>
<%@ page import="java.util.Map"%>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/> 

<style>
body {
  font-family: Arial, sans-serif;
}

button {
  padding: 6px 12px;
  margin-right: 5px;
  cursor: pointer;
}

.search-mode button.active {
  background: #333;
  color: #fff;
}

.search-wrapper {
  width: 95%;      /* 또는 80% 유지해도 됨 */
  margin: 0;        /* 가운데 정렬 제거 */
  padding: 0 20px;  /* 좌우 여백만 살짝 */
}

.search-mode {
  margin-bottom: 10px;      /* 버튼과 박스 간격 */
}

.filter-box {
  border: 2px solid #000;
  padding: 15px;
  box-sizing: border-box;
  max-height: 350px;
}

.hidden {
   display: none !important;
}

select, input {
  margin: 5px 0;
  padding: 5px;
}

.address-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.address-row input[type="text"] {
  min-width: 375px;
  padding: 6px;
}

.address-row button {
  padding: 6px 12px;
  cursor: pointer;
}

.tab-btn {
  padding: 6px 14px;
  border: 1px solid #444;
  background: #f5f5f5;
  cursor: pointer;
  border-radius: 3px;
}

.tab-btn.active {
  background: #222;
  color: #fff;
  border-color: #222;
}

.action-btn {
 align-items: center;     /* 위아래 중앙 */
  width: 75px;
  padding: 6px 16px;
  background: #b36611;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.action-btn:hover {
  width: 75px;
  background: #b39623;
}
.category-row {
  display: flex;
  gap: 10px;
  margin: 10px 0;
}

.category-row select {
  flex: 1;
  min-width: 120px;
}

#map { 
width:100%; 
height:400px; 
 margin:15px 0; }
</style>

<%
	Map< String, Integer> cultureMap = MenuCategoryDAO.getInstance().getCultureCategoryReverseMap();
	Map< String, Integer> foodtypeMap = MenuCategoryDAO.getInstance().getFoodTypeReverseMap();
	Map< String, Integer> foodItemMap = MenuCategoryDAO.getInstance().getFoodItemReverseMap();
	
	
%>

<div class="search-wrapper">
	<!-- 검색 모드 -->
	<div class="search-mode">
	  <button id="foodBtn" class="tab-btn active" onclick="switchMode('food')">음식검색</button>
	  <button id="locBtn" class="tab-btn" onclick="switchMode('location')">위치검색</button>
	</div>
	
	<!-- 필터 영역 -->
	<div class="filter-box">
	
	  <!-- 음식 검색 -->
	  <div id="foodFilter">	
	  	<form action="/summat/food/foodMain.jsp" method="get">
		  <div class="filter-tabs">
			   <input type="button" class="tab-btn active" onclick="switchFoodTab('keyword', this)" value="메뉴검색">
			   <input type="button" class="tab-btn" onclick="switchFoodTab('category', this)" value="카테고리선택">
		  </div>
		  <div class="tab-content">
		
			  <!-- 메뉴 검색 -->
			  <div id="keywordTab">
			    <input type="search" name="Keyword" placeholder="음식 검색어">
			    <input type="submit"  class="action-btn" value="검색"></button>
			  </div>
			  <!-- 카테고리 선택 -->
			  <div id="categoryTab" class="hidden">
			  <div class="category-row"> 
			    <select id="ccategorySelect" name="ccategory" onchange="FilteredFoodsbyCategory()">
			      <option value=>분류1</option>
			      <%for(String key:cultureMap.keySet()){ %>
			       <option value="<%=key%>"><%=key%></option>			      
			      <%} %>
			    </select><br>
			    <select id="fcategorySelect" name="fcategory" onchange="FilteredFoodsbyCategory()">
			      <option value=>분류2</option>
			      <%for(String key:foodtypeMap.keySet()){ %>
			       <option value="<%=key%>"><%=key%></option>			      
			      <%} %>
			    </select><br>
			    <select id="foodItemSelect" name="foodItem" >
			      <option value=>상위 카테고리 먼저 선택</option>			     
			    </select>
			    
			    <input type="submit"  class="action-btn" value="검색"></button>
			    </div>
			  </div>
	   
		  </div>
	    <!-- 가격 -->
	    <div>
	      <input type="number" name="minPrice" placeholder="최소가격"> ~
	      <input type="number" name="maxPrice" placeholder="최대가격">
	    </div>
	    </form>
	  </div>
	
	  <!-- 위치 검색 -->
	  <div id="locationFilter" class="hidden">	
	    <input type="button" id="btn_addressSearch" class="tab-btn active" onclick="switchLocationTab('address', this)"  value="주소검색"></input>
	    <input type="button" id="btn_mapSearch" class="tab-btn" onclick="switchLocationTab('map', this)" value="지도검색"></input>
	
	    <div id="addressSearch" class="address-row">
	      <input id="my_address" type="text" placeholder="주소 입력" onchange="runGeocode(this.value)">
	      <input type="button" class="action-btn" style="width=40px;" onclick="openPostcode()" value="주소찾기"></input>	      
	    </div>
	
	    <div id="mapSearch" class="hidden">
	      <div id="map" style="border:1px solid #aaa; height:200px; margin-top:10px;">
	        지도 영역 (API 연결 전)
	      </div>	    
	    </div>
	    
	    <form id="geoCodeform" action="/summat/food/foodMain.jsp" method="get">
	    	<input type="hidden" id="location_Lat" name="location_Lat"/>
	    	<input type="hidden" id="location_Lon" name="location_Lon"/>
	    	<input type="submit" value="찾기" />
	    </form>
	  </div>
	
	</div>
	
	  <div id="result-list"></div>
</div>
<script>
let map, marker;

const restaurants = [
    { name:'국밥집', lat:37.5665, lon:126.9780 },
    { name:'돈까스', lat:37.5560, lon:126.9223 },
    { name:'떡볶이', lat:37.5172, lon:127.0473 }
];

// ===== 검색 모드 전환 =====
function switchMode(mode) {
  document.getElementById("foodFilter").classList.toggle("hidden", mode !== "food");
  document.getElementById("locationFilter").classList.toggle("hidden", mode !== "location");

  document.getElementById("foodBtn").classList.toggle("active", mode === "food");
  document.getElementById("locBtn").classList.toggle("active", mode === "location");
}

function switchFoodTab(type, btn) {
	  document.getElementById("keywordTab").classList.toggle("hidden", type !== "keyword");
	  document.getElementById("categoryTab").classList.toggle("hidden", type !== "category");

	  const tabs = btn.parentElement.querySelectorAll(".tab-btn");
	  tabs.forEach(b => b.classList.remove("active"));
	  btn.classList.add("active");
	}
// ===== 위치 검색 탭 =====
function switchLocationTab(type, btn) {
	  const address = document.getElementById("addressSearch");
	  const map = document.getElementById("mapSearch");


	  if (type === "address") {
	    address.classList.remove("hidden");
	    map.classList.add("hidden");
	  } else {
	    address.classList.add("hidden");
	    map.classList.remove("hidden");
	    initMap();
	  }
  
  // 탭 active 처리
  const tabs = btn.parentElement.querySelectorAll(".tab-btn");
  tabs.forEach(b => b.classList.remove("active"));
  btn.classList.add("active");
}

// ===== 카테고리 데이터 =====
const categories = {
  "한식": {
    "면": ["라면", "국수"],
    "밥": ["비빔밥", "김치볶음밥"]
  },
  "양식": {
    "면": ["파스타"],
    "고기": ["스테이크"]
  },
  "중식": {
    "면": ["짜장면", "짬뽕"],
    "밥": ["볶음밥"]
  }
};

function FilteredFoodsbyCategory() {
    const ccSelect = document.getElementById('ccategorySelect');
    const fcSelect = document.getElementById('fcategorySelect');
    const fiSelect = document.getElementById('foodItemSelect');    
    
   
    const params = new URLSearchParams();
    params.append('cc', ccSelect.value);
    params.append('fc', fcSelect.value);

    fetch('foodCategoryfetch.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params.toString()
    })
    .then(response => response.text()) 
    .then(data => {
        fiSelect.innerHTML = data;
    })
    .catch(error => console.error('Error:', error));
}


function setActiveTab(button) {
	  const siblings = button.parentElement.querySelectorAll('.tab-btn');
	  siblings.forEach(b => b.classList.remove('active'));
	  button.classList.add('active');
	}
	
/* =========================
카카오 주소
========================= */
function openPostcode(){
 new daum.Postcode({
     oncomplete: data=>{
         const addr = data.roadAddress || data.jibunAddress || data.address;
         my_address.value = addr;
         runGeocode(addr);
     }
 }).open();
}
/* =========================
주소 단위 축소 + geocode
========================= */
const BASE = '<%=request.getContextPath()%>';
async function runGeocode(address){
	console.log('geocode address:', address);
 /* 🔥 주소 단위 축소 핵심 */
 const tokens = address.trim().split(/\s+/);

 const candidates = [];
 for(let i=tokens.length;i>=1;i--){
     candidates.push(tokens.slice(0,i).join(' '));
 }

 console.log('geocode 후보:', candidates);

 for(const q of candidates){
     try{
     	console.log('fetch:'+ q);
     	console.log('fetch:', BASE + '/api/geocode?q=' + encodeURIComponent(q));
         const res = await fetch(
        	 
             BASE + '/api/geocode?q=' + encodeURIComponent(q)
         );
         console.log('res:', res);
         if(!res.ok) continue;
        
         const data = await res.json();
         console.log('res2:', data);
         if(data.length){
             const lat = parseFloat(data[0].lat);
             const lon = parseFloat(data[0].lon);
         
             updateMap(lat,lon);
             calculateDistances(lat,lon);
         
             return;
         }
     }catch(e){
    	 
    	 console.log('error:', e);
     }
 }

 alert('주소를 찾을 수 없습니다. 지도에서 직접 선택하세요.');
 const btn_mapSearch = document.getElementById("btn_mapSearch");
 switchLocationTab('map',btn_mapSearch );
 initMap();
}
async function reverseGeocode(lat, lon){
    try{
        const res = await fetch(
            BASE + `/api/reverse?lat=\${lat}&lon=\${lon}`
        );
        if(!res.ok) return '';
        const data = await res.json();
        return data.display_name || '';
    }catch(e){
        return '';
    }
}

const debouncedReverse = debounce(async (lat,lon)=>{
    const addr = await reverseGeocode(lat,lon);
    if(addr){
    	
    }
}, 800);
/* =========================
지도
========================= */
function initMap(){
 if(map) return;
 map = L.map('map').setView([37.5665,126.9780],13);
 L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
 map.on('click',e=>{
 	const lat = e.latlng.lat;
     const lon = e.latlng.lng;
     updateMap(lat,lon);
     calculateDistances(lat,lon);
     
 
	 	 
     debouncedReverse(lat,lon);
 });
}
function updateMap(lat,lon){
 alert("lat: ", lat);
 document.getElementById("location_Lat").value = lat;
 document.getElementById("location_Lon").value = lon;
 alert("위도에 들어간 값: " + document.getElementById("location_Lat").value);
 if(!map){ initMap(); }
 map.setView([lat,lon],14);
 if(marker) map.removeLayer(marker);
 marker = L.marker([lat,lon]).addTo(map);
}

/* =========================
   거리 계산
========================= */
function calculateDistances(lat,lon){
    const list = document.getElementById('result-list');
    list.innerHTML='<h3>🍽 맛집</h3>';
    restaurants
        .map(r=>({...r, d:getDistance(lat,lon,r.lat,r.lon)}))
        .sort((a,b)=>a.d-b.d)
        .forEach(r=>{
            const p=document.createElement('p');
            p.innerText=`\${r.name} : \${r.d.toFixed(2)} km`;
            list.appendChild(p);
        });
}
//하버사인
function getDistance(a,b,c,d){
    const R=6371;
    const dLat=(c-a)*Math.PI/180;
    const dLon=(d-b)*Math.PI/180;
    const x=Math.sin(dLat/2)**2+
        Math.cos(a*Math.PI/180)*Math.cos(c*Math.PI/180)*
        Math.sin(dLon/2)**2;
    return R*2*Math.atan2(Math.sqrt(x),Math.sqrt(1-x));
}
/* =========================
debounce
========================= */
function debounce(fn, delay){
 let t;
 return (...args)=>{
     clearTimeout(t);
     t=setTimeout(()=>fn(...args),delay);
 };
}
</script>
