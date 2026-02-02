/**
 * 
 */
const editor = document.getElementById("editor");
const imageInput = document.getElementById("imageInput");

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
        document.querySelectorAll("#editor img").forEach(i => i.style.border = "none");
        img.style.border = "2px solid black"; // 대표 이미지 표시
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