/**
 * 
 */

const imageInput = document.getElementById("imageInput");


// =========================
// 업로드 처리 함수
// =========================
function handleFileUpload(file, source = "file") {
  
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
            
        } else {
            alert("업로드 실패: " + (data.error || "알 수 없음"));           
        }
    })
    .catch(err => {
        console.error(err);
        alert("서버 통신 오류");
    });
}

// =========================
// 파일 선택 이벤트
// =========================
imageInput.addEventListener("change", () => {
    [...imageInput.files].forEach(file => handleFileUpload(file, "file"));
    imageInput.value = "";
});
