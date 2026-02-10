<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String groupParam = request.getParameter("group");
    int group = (groupParam == null) ? -1 : Integer.parseInt(groupParam);
    
    String idParam = request.getParameter("menuId");
    int id = (idParam == null) ? -1 : Integer.parseInt(idParam);
        
    String menuName = "";
	String menuPrice = "";
	String menuImg ="";
			
    int updateId = id;
    if(updateId == -1)
    {
    	//updateId = MenuDAO.GetNewId();
    }else{
    	menuName = request.getParameter("menuName");
    	menuPrice = request.getParameter("menuPrice");
    	menuImg =request.getParameter("menuImg");
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴 등록</title>

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
    width: 80px;
}

img {
    width: 200px;
    height: 150px;
    border: 1px solid #000;
    object-fit: cover;
}
</style>

<script>
let group = <%= group %>;

function handleFileUpload(file, preview) {
	  
    const formData = new FormData();
    formData.append("uploadFile", file);
	
    let url = "";
    fetch("/summat/util/imageUploadPro.jsp", {
        method: "POST",
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        if (data.url) {          
        	preview.src = data.url;
        } else {
            alert("업로드 실패: " + (data.error || "알 수 없음"));           
        }
    })
    .catch(err => {
        console.error(err);
        alert("서버 통신 오류");
    });
    
    return url;
}


function previewImg(input) {
    handleFileUpload(input.files[0], document.getElementById('preview'));
}

function submitMenu() {
    const nameInput = document.getElementById('name');
    const priceInput = document.getElementById('price');
    const preview = document.getElementById('preview').src;

    const name = nameInput.value.trim();  // 공백 제거
    const price = priceInput.value.trim();

    // 1. 유효성 검사
    if (!name) {
        alert("메뉴명을 입력해 주세요.");
        nameInput.focus();
        return; // 함수 종료
    }

    if (!price || price <= 0) {
        alert("가격을 올바르게 입력해 주세요.");
        priceInput.focus();
        return; // 함수 종료
    }

    // 2. 데이터 구성
   
    const menu = {
        group: group,
        id: <%=updateId%>,
        name: name,
        price: price,
        img: (preview && !preview.endsWith('null') && !preview.endsWith('.jsp')) ? preview : 'noimage.png'
    };    
    menu.img = new URL(preview).pathname;
    
    // 3. 부모 창으로 데이터 전달 및 닫기
    window.opener.saveMenu(menu);
    window.close();
}
</script>
</head>

<body>
	<h3><%= (id == -1) ? "메뉴 등록" : "메뉴 수정" %></h3>
	
	<div class="row">
	    <label>메뉴명</label>
	    <input type="text" id="name" value="<%=menuName%>">
	</div>
	
	<div class="row">
	    <label>가격</label>
	    <input type="number" id="price" value="<%=menuPrice%>">
	</div>
	
	<div class="row">
	    <label>사진</label>
	    <input type="file" id="imageInput" onchange="previewImg(this)">
	</div>
	
	<img id="preview" src="<%=menuImg%>">
	
	<br><br>
	<button onclick="submitMenu()">완료</button>
	<button onclick="window.close()">취소</button>
</body>
	
</html>

