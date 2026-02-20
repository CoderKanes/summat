<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>주소 기반 가까운 맛집 찾기</title>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/> 
<style>	
body { font-family: Arial, sans-serif; padding: 20px; }
.tabs button { padding: 8px 14px; margin-right: 5px; cursor: pointer; }
.tabs button.active { background:#333; color:#fff; }
#map { width:100%; height:400px; display:none; margin:15px 0; }
</style>
</head>
<body>

<h2>📍 가까운 맛집 찾기</h2>

<div class="tabs">
    <button id="tab-kr" class="active" onclick="setMode('KR')">한국주소</button>
    <button id="tab-global" onclick="setMode('GLOBAL')">해외검색</button>
    <button id="tab-map" onclick="setMode('MAP')">지도 선택</button>
</div>

<div id="address-box">
    <input id="my_address" style="width:320px" placeholder="주소 입력" readonly>
    <button onclick="search()">검색</button>
</div>

<div id="map"></div>

<p id="resultTxt"></p>
<div id="result-list"></div>

<script>
/* =========================
   상태
========================= */
const BASE = '<%=request.getContextPath()%>';
let mode = 'KR';
let map, marker;

/* =========================
   샘플 맛집
========================= */
const restaurants = [
    { name:'국밥집', lat:37.5665, lon:126.9780 },
    { name:'돈까스', lat:37.5560, lon:126.9223 },
    { name:'떡볶이', lat:37.5172, lon:127.0473 }
];

/* =========================
   탭 전환
========================= */
function setMode(m){
    mode = m;
    document.querySelectorAll('.tabs button').forEach(b=>b.classList.remove('active'));
    document.getElementById(
        m==='KR'?'tab-kr':m==='GLOBAL'?'tab-global':'tab-map'
    ).classList.add('active');

    document.getElementById('map').style.display = (m==='MAP')?'block':'none';
    document.getElementById('address-box').style.display = (m==='MAP')?'none':'block';

    my_address.value='';
    my_address.readOnly = (m==='KR');
}

/* =========================
   검색
========================= */
function search(){
    if(mode==='KR') openPostcode();
    if(mode==='GLOBAL') runGeocode(my_address.value);
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
            const res = await fetch(
                BASE + '/api/geocode?q=' + encodeURIComponent(q)
            );
            if(!res.ok) continue;

            const data = await res.json();
            if(data.length){
                const lat = parseFloat(data[0].lat);
                const lon = parseFloat(data[0].lon);

                document.getElementById('resultTxt').innerText =
                    q + (q!==address ? ' (대략 위치)' : '') + ' 기준';

                updateMap(lat,lon);
                calculateDistances(lat,lon);
                return;
            }
        }catch(e){}
    }

    alert('주소를 찾을 수 없습니다. 지도에서 직접 선택하세요.');
    setMode('MAP');
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
        resultTxt.innerText = addr + ' 기준 (지도 선택)';
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
    if(!map){ setMode('MAP'); initMap(); }
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
</body>
</html>