<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가게 등록</title>

<style>
body {
    font-family: Arial;
}

.container {
	min-width: 500px;
    width: 75%;
    margin: 20px auto;
    border: 3px solid #000;
    padding: 20px;
}

.row {
    margin-bottom: 15px;
}

label {
    display: inline-block;
    min-width: 120px;
}

input[type=text] {
    width: 300px;
    padding: 5px;
}

.menu-body {
    /* 최대 높이 설정 (원하는 높이로 조정하세요) */
    max-height: 450px; 
    
    /* 내용이 넘치면 세로 스크롤 생성, 아니면 숨김 */
    overflow-y: auto;
    
    /* 스크롤 시 부드럽게 움직이도록 설정 */
    scrollbar-gutter: stable; /* 스크롤바 생성 시 화면 밀림 방지 */
    
    /* 디자인을 위한 추가 설정 (선택사항) */
    border: 1px solid #ddd;
    padding: 15px;
    border-radius: 8px;
}
</style>
<%
	String menuDataParam = request.getParameter("menuData");
	String nameParam = request.getParameter("name");
	String addressParam = request.getParameter("address");
	String subaddressParam = request.getParameter("sub_address");
	String geoCodeParam = request.getParameter("geoCode");
	String phoneNumParam = request.getParameter("phoneNum");	
	if(nameParam==null){nameParam ="";}
	if(addressParam==null){addressParam ="";}
	if(subaddressParam==null){subaddressParam ="";}
	if(geoCodeParam==null){geoCodeParam ="";}
	if(phoneNumParam==null){phoneNumParam ="";}
	
	
%>


<script>
let menus = [];

/* 메뉴 등록 팝업 */
function openMenuPopup(index) {
    let url = 'menuPopup.jsp';
    if (index !== undefined) {
        url += '?index=' + index;
    }
    window.open(url, 'menuPopup', 'width=600,height=600');
}

/* 팝업에서 호출됨 */
function saveMenu(menu, index) {
	 console.log("저장받은 메뉴:", menu, "인덱스:", index);
    if (index === -1) {
        menus.push(menu);
    } else {
        menus[index] = menu;
    }
    renderMenus();
}

/* 썸네일 다시 그림 */
function renderMenus() {
    const list = document.getElementById('menuList');
    list.innerHTML = '';

    menus.forEach((m, i) => {
    	 console.log("렌더링 메뉴:", m);
    	 const div = document.createElement('div');
    	 div.className = 'menu-thumb';
    	 div.onclick = () => openMenuPopup(i);

    	 const img = document.createElement('img');
    	 img.src = (m.img && m.img.trim() !== '') ? m.img : 'noimage.png';
    	 img.alt = "메뉴 이미지";
    	 img.style.width = "100%";
    	 img.style.height = "100px";
    	 img.style.objectFit = "cover";

    	 const nameDiv = document.createElement('div');
    	 nameDiv.textContent = m.name;

    	 const priceDiv = document.createElement('div');
    	 priceDiv.textContent = m.price + "원";

    	 div.appendChild(img);
    	 div.appendChild(nameDiv);
    	 div.appendChild(priceDiv);

    	 list.appendChild(div);
    });

    const add = document.createElement('div');
    add.className = 'menu-thumb add-menu';
    add.onclick = () => openMenuPopup();
    add.innerText = '+';
    list.appendChild(add);
}

function editMenus() {	
	const name = document.getElementById('name').value;
	const address = document.getElementById('address').value;
	const sub_address = document.getElementById('sub_address').value;
	const geoCode = document.getElementById('geoCode').value;
	const phoneNum = document.getElementById('phoneNum').value;

	const params = new URLSearchParams();
	params.append('Edit', 'true');
    if (name) {
        params.append('name', name);
    }
    if (address) {
        params.append('address', address);
    }
    if (sub_address) {
        params.append('sub_address', sub_address);
    }
    if (geoCode) {
        params.append('geoCode', geoCode);
    }
    if (phoneNum) {
        params.append('phoneNum', phoneNum);
    }
    
	<%
	if(menuDataParam!=null)
	{ %>
		params.append('menuData', "<%=menuDataParam%>");
	<%
	}	
	%>


	window.location = '/summat/store/Menu.jsp?' + params.toString();
}
</script>
</head>

<body>
<form action="storeRegistPro.jsp" method="get">
	<div class="container">
	    <h2>가게 정보 등록</h2>
	
	    <div class="row">
	        <label>가게이름</label>
	        <input type="text" id="name" name="name" value="<%=nameParam%>" required>
	    </div>
	
	    <div class="row">
	        <label>가게주소</label>
	        <jsp:include page="/util/addressInput.jsp">
	        	<jsp:param name="address" value="<%=addressParam%>" />
	        	<jsp:param name="sub_address" value="<%=subaddressParam%>" />
	        	<jsp:param name="geoCode" value="<%=geoCodeParam%>" />
	        	<jsp:param name="address_required" value="true" />
	        </jsp:include>
	    </div>
	
	    <div class="row">
	        <label>전화번호</label>
	        <input type="text" id="phoneNum" name="phoneNum" value="<%=phoneNumParam%>" required>
	    </div>
	
	    <div class="menu-area">
	        <h3>메뉴  <button type="button" onclick="editMenus();">편집</button></h3>
	        <div class="menu-body">
	       	<jsp:include page="Menu.jsp"></jsp:include>
	       	</div>
	    </div>
	    
	    <input type="hidden" name="menuData" id="menuData" value="<%=menuDataParam%>">
	
	    <br>
	    
		<input type="submit" value ="등록신청">
	    <input type="button" value ="취소" onclick="location.href='/summat/main/main.jsp'">
	</div>
</form>
</body>
</html>
