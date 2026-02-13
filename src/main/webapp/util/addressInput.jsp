<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/> 

<style>
    /* 전체 컨테이너 너비 설정 */
    #address-box {
        width: 100%;
        max-width: 450px; /* 원하는 전체 너비로 조절하세요 */
        display: flex;
        flex-direction: column;
        gap: 6px; /* 위아래 칸 사이 간격 */
    }

    /* 첫 번째 줄 (주소 입력 + 버튼) */
    .address-row {
     	padding: 10px 0px 0px 0px;
     	display: flex;
        width: 100%;
    }

</style>


<% 
String addressParam = request.getParameter("address");
if(addressParam==null){addressParam ="";}
String sub_addressParam = request.getParameter("sub_address");
if(sub_addressParam==null){sub_addressParam ="";}
String geoCodeParam = request.getParameter("geoCode");
if(geoCodeParam==null){geoCodeParam ="";}
boolean address_required = "true".equals(request.getParameter("address_required"));

%>

<div class="tabs">
    <select onchange="setMode(this.value)">
    <option value="USINGAPI">주소찾기</option>
    <option value="FULLTEXT">직접입력</option>
	</select>
</div>
<div id="address-box">	

    <!-- 첫 번째 줄: 주소 입력 + 검색 -->
    <div class="address-row">
        <input type="text" id="address" name="address" onchange="runGeocode(this.value)" placeholder="주소 입력" onclick="search();"
        	value="<%=addressParam%>" <%if(address_required){%>required<%}%>>
    </div>

    <!-- 두 번째 줄: 상세주소 -->
    <input type="text" id="sub_address" name="sub_address" value="<%=sub_addressParam%>" placeholder="상세주소">
    
    <input type="hidden" id="geoCode" name="geoCode"  value="<%=geoCodeParam%>">
</div>

<script>
/* =========================
   상태
========================= */
const BASE = '<%=request.getContextPath()%>';
let mode = 'USINGAPI';

/* =========================
   탭 전환
========================= */
function setMode(m){
    mode = m;
    const isApi = (m === 'USINGAPI');
    document.getElementById('sub_address').style.display = (m==='USINGAPI')?'block':'none';
    document.getElementById('address-box').style.display = 'block';
    address.value='';
    document.getElementById('address').value='';
    document.getElementById('address').onclick = (m === 'USINGAPI') ? search : null;  
}

/* =========================
   검색
========================= */
function search(){
    if(mode==='USINGAPI') openPostcode();
    if(mode==='FULLTEXT') runGeocode(address.value);
}

/* =========================
   카카오 주소
========================= */
function openPostcode(){
    new daum.Postcode({
        oncomplete: data=>{
            const addr = data.roadAddress || data.jibunAddress || data.address;
            address.value = addr;
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

  				let result = lat+','+lon;
                console.log('geocode lat:', lat);
                console.log('geocode lon:', lon);
                console.log('geocode result:', result);
                document.getElementById('geoCode').value = result;
                return;
            }
        }catch(e){}
    }

    console.log('좌표찾기 실패');
}
</script>