<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String storeName="";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가게 찾기</title>

<style>
body {
    font-family: Arial;
    padding: 20px;
}

.row {
    margin-bottom: 15px;
}

label {
    display: inline-block;
    min-width: 80px;
}

img {
    width: 200px;
    height: 150px;
    border: 1px solid #000;
    object-fit: cover;
}
</style>

<script>	
function findStore() {
	const storeNameSearchEl = document.getElementById('storeNameSearch');
	const storeName = storeNameSearchEl.value;
      
	const params = new URLSearchParams();
	params.append('storeName', storeName);

	/* ---Created by fetch---
	//	<select id='storeSelect' name='storeSelect' onchange='findMenus(this.value)'> 
	//		<option value=storeId>storeName(storeAddress)</option>... *n 
	//	</select>
	*/
	fetch('storeSelectFetch.jsp', {
		method: 'POST',
		headers: {
			'Content-Type': 'application/x-www-form-urlencoded',
		},
		body: params.toString()
		})
      	.then(response => response.text()) 
      	.then(data => {
          document.getElementById('searchResult').innerHTML = data;
      })
      .catch(error => console.error('Error:', error));	
}

function findMenus(storeId) {
	const params = new URLSearchParams();
	params.append('storeId', storeId);

	fetch('storeMenuFetch.jsp', {
		method: 'POST',
		headers: {
			'Content-Type': 'application/x-www-form-urlencoded',
		},
		body: params.toString()
		})
      	.then(response => response.text()) 
      	.then(data => {
          document.getElementById('menuResult').innerHTML = data;
      })
      .catch(error => console.error('Error:', error));	
}

function submitMenu() {
    const storeSelect = document.getElementById('storeSelect');

    let storeId = storeSelect.value;
    
    const checkedMenus = Array.from(
    		  document.querySelectorAll('input[name="selectedMenu"]:checked')
    		).map(el => el.value);
  
    
    window.opener.selectStore(storeId, checkedMenus);
    window.close();
}

</script>
</head>

<body>
	<div class="row">
	    <label>가게명</label>
	    <input type="search" id="storeNameSearch" value="<%=storeName%>">
	    <input type="button" value="찾기" onclick="findStore()">
	</div>
	
	<div id="searchResult"></div>
	
	<div id="menuResult"></div>
	
	<br><br>
	<button onclick="submitMenu()">선택</button>
	<button onclick="window.close()">취소</button>
</body>
	
</html>

