<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>맛집 리뷰 작성</title>
<style>
#editor {
  border: 1px solid #ccc;
  min-height: 200px;
  padding: 10px;
}
img.preview {
  max-width: 100%;  /* 혹시 부모보다 커지지 않도록 안전장치 */
  width: auto;         /* 원본 크기 유지, 부모보다 커질 때만 줄어듦 */
  height: auto;     /* 비율 유지 */
  margin: 5px 5px 0 5px;  /* 위 , 오른쪽 , 아래 , 왼쪽 -  바닥은 글보다 떠보여서 0으로 */ 
}
.uploading { opacity: 0.5; filter: grayscale(1); }
</style>
</head>
<body>

<h1>맛집 리뷰 작성</h1>

<form action="testwritePro.jsp" method="post" onsubmit="return beforeSubmit();">
    제목: <input type="text" name="title" required><br><br>

    <div contenteditable="true" id="editor">
        여기에 글을 작성하세요...
    </div>
    <input type="hidden" name="content" id="content"><br>

    이미지 선택: <input type="file" id="imageInput" multiple accept="image/*"><br><br>

    <button type="submit">등록</button>
</form>
<script>
const editor = document.getElementById("editor");
const imageInput = document.getElementById("imageInput");

// =========================
// 커서 위치에 이미지 삽입
// =========================
function insertImageAtCursor(imgElement) {
    const sel = window.getSelection();
    if (!sel || !sel.rangeCount) return;
    const range = sel.getRangeAt(0);
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

    fetch("imageUploadPro.jsp", {
        method: "POST",
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        if (data.url) {
            img.src = data.url;
            img.classList.remove("uploading");
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
</script>

</body>
</html>
