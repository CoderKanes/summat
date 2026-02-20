/**
 * 
 */
const editor = document.getElementById("editor");
const imageInput = document.getElementById("imageInput");
const findStoreBtn = document.getElementById("findStoreBtn"); 

// =========================
// 커서 위치에 이미지 삽입
// =========================
function insertImageAtCursor(imgElement) {
	let sel = window.getSelection();
    if (!sel || !sel.rangeCount) return;
    
    let range = sel.getRangeAt(0);
    
    if (!editor.contains(range.commonAncestorContainer)) {
        editor.focus();

        range = document.createRange();
        range.selectNodeContents(editor);
        range.collapse(false);
 
        sel.removeAllRanges();
        sel.addRange(range);
    }
    
    range.deleteContents();
    range.insertNode(imgElement);
    range.setStartAfter(imgElement);
    range.collapse(true);
    sel.removeAllRanges();
    sel.addRange(range);
}

// =========================
// 공통 업로드 처리 함수
// =========================
function handleFileUpload(file, source = "file") {
    // 1. 임시 이미지 삽입
    const img = document.createElement("img");
    img.className = "preview uploading";
    img.src = "https://i.gifer.com"; // 로딩 스피너 / 빈 이미지
    insertImageAtCursor(img);

    // 2. 서버 업로드
    const formData = new FormData();
    formData.append("uploadFile", file);
    formData.append("source", source);

    fetch("/summat/util/imageUploadPro.jsp", {
        method: "POST",
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        if (data.url) {
            img.src = data.url;
            img.classList.remove("uploading");
            
            addThumbnailClick(img, data.url); 
            
        } else {
            alert("업로드 실패: " + (data.error || "알 수 없음"));
            img.remove();
        }
    })
    .catch(err => {
        console.error(err);
        alert("서버 통신 오류");
        img.remove();
    });
}

function addThumbnailClick(img, fileName) {
    img.addEventListener("click", () => {
        const thumbnailInput = document.getElementById("thumbnailImage");
        thumbnailInput.value = fileName;

        // 시각적 표시: 클릭한 이미지 테두리 강조
        //document.querySelectorAll("#editor img").forEach(i => i.style.border = "none");
        //img.style.border = "2px solid black"; // 대표 이미지 표시
    });
}

// =========================
// 붙여넣기 이벤트 (클립보드 이미지)
// =========================
editor.addEventListener("paste", e => {
    const items = e.clipboardData.items;

    for (const item of items) {
        if (item.type.startsWith("image/")) {
            e.preventDefault();
            const file = item.getAsFile();
            handleFileUpload(file, "clipboard");
        }
    }
});

// =========================
// 파일 선택 이벤트
// =========================
imageInput.addEventListener("change", () => {
    [...imageInput.files].forEach(file => handleFileUpload(file, "file"));
    imageInput.value = "";
});

// =========================
// form submit 전에 contenteditable 내용 hidden input에 넣기
// =========================
function beforeSubmit() {
    document.getElementById('content').value = editor.innerHTML;
    return true;
}

// =========================
// 가게찾기
// =========================
// 버튼 이벤트 리스너 등록 (onclick 대신 JS에서 처리)
if (findStoreBtn) {
	alert("1");
	findStoreBtn.addEventListener('click', () => {
    	window.openStoreSearchPopup();
		alert("2");
    });
}else{
	alert("3");
}

window.openStoreSearchPopup = function() {
    const url = 'storeSelectPopup.jsp';	    
    window.open(url, 'storeSelectPopup', 'width=600,height=600');
};

window.selectStore = function(storeId, Menus) {	
    const form = document.getElementById('writeForm');
	
    // 1. 기존 hidden input 삭제 (forEach 사용 가능)
    document.querySelectorAll('.selectStore-storeId-hidden, .selectStore-menuId-hidden')
            .forEach(el => el.parentNode.removeChild(el));
    
    // 2. storeId 추가
    const storeInput = document.createElement('input');
    storeInput.type = 'hidden';
    storeInput.name = 'storeId';
    storeInput.value = storeId;
    storeInput.className = 'selectStore-storeId-hidden';
    form.appendChild(storeInput);
    
    // 3. menus 추가
    if (Menus && Array.isArray(Menus)) {
        Menus.forEach(menuId => {
            const menuInput = document.createElement('input');
            menuInput.type = 'hidden';
            menuInput.name = 'menus';
            menuInput.value = menuId;
            menuInput.className = 'selectStore-menuId-hidden';
            form.appendChild(menuInput);
        });
    }
    
    // 4. 파라미터 준비
    const menuParams = Array.isArray(Menus) ? Menus.join(',') : Menus;

    // 5. 서버 통신 (Promise 방식)
    const fetchUrl = 'selectStoreInfoFetch.jsp?storeId=' + storeId + '&menus=' + menuParams;
    
    fetch(fetchUrl)
        .then(response => {
            if (response.ok) return response.text();
        })
        .then(resultText => {
            console.log("서버 응답:", resultText);
            const displayEl = document.getElementById('resultDisplay');
			alert("11");
            if (displayEl) {
                displayEl.innerText = resultText;
            }
        })
        .catch(error => {
            console.error('데이터를 가져오는데 실패했습니다:', error);
        });
};