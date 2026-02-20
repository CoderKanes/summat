<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>

<%
    // 예시 데이터 (DAO에서 가져와도 구조 동일)
    String[] cultureList = {"한식","일식","중식","양식","패스트푸드","분식","퓨전","기타"};
    String[] typeList = {"면류","밥류","국물/탕","빵","고기","해산물","튀김","기타"};
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음식 필터</title>

<style>
body {
  font-family: Arial, sans-serif;
}

/* 전체 래퍼 */
.filter-wrapper {
  width: 80%;
  margin: 0 auto;
}

/* 기준 영역 */
.criteria-row {
  display: flex;
  gap: 40px;
}

.criteria {
  flex: 1;
}

.criteria h4 {
  margin-bottom: 6px;
}

/* 옵션 박스 */
.option-box {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  max-height: 120px;
  overflow-y: auto;
  border: 1px solid #ddd;
  padding: 6px;
}

.option {
  padding: 6px 10px;
  border: 1px solid #ccc;
  cursor: pointer;
  font-size: 14px;
}

.option.active {
  background: #222;
  color: #fff;
  border-color: #222;
}

/* 결과 영역 */
.result-box {
  margin-top: 15px;
}

.result-list {
  border: 1px solid #ddd;
  max-height: 300px;
  overflow-y: auto;
  padding: 8px;
}

.result-item {
  padding: 6px;
  border-bottom: 1px solid #eee;
  cursor: pointer;
}

.result-item:hover {
  background: #f5f5f5;
}
</style>
</head>

<body>

<div class="filter-wrapper">

  <!-- 기준 선택 -->
  <div class="criteria-row">

    <div class="criteria">
      <h4>국가 기준</h4>
      <div class="option-box" id="cultureBox">
        <% for(String c : cultureList) { %>
          <div class="option" onclick="selectCulture('<%=c%>', this)"><%=c%></div>
        <% } %>
      </div>
    </div>

    <div class="criteria">
      <h4>음식 유형 기준</h4>
      <div class="option-box" id="typeBox">
        <% for(String t : typeList) { %>
          <div class="option" onclick="selectType('<%=t%>', this)"><%=t%></div>
        <% } %>
      </div>
    </div>

  </div>

  <hr>

  <!-- 결과 -->
  <div class="result-box">
    <h4>음식 목록</h4>
    <div id="resultList" class="result-list">
      1분류와 2분류를 선택하세요
    </div>
  </div>

</div>

<script>
let selectedCulture = null;
let selectedType = null;

// 공통 active 처리
function setActive(el) {
  const siblings = el.parentElement.querySelectorAll(".option");
  siblings.forEach(o => o.classList.remove("active"));
  el.classList.add("active");
}

function selectCulture(value, el) {
  selectedCulture = value;
  setActive(el);
  loadFood();
}

function selectType(value, el) {
  selectedType = value;
  setActive(el);
  loadFood();
}

// 결과 로딩
function loadFood() {
  if (!selectedCulture || !selectedType) {
    document.getElementById("resultList").innerText =
      "1분류와 2분류를 선택하세요";
    return;
  }

  // ▶ 실제로는 여기서 fetch로 DB 조회
  // fetch("getFilterFood.jsp?c="+selectedCulture+"&t="+selectedType)

  // 지금은 예시 데이터
  let html = "";
  for (let i = 1; i <= 8; i++) {
    html += "<div class='result-item'>" +
            selectedCulture + " / " + selectedType + " 음식 " + i +
            "</div>";
  }

  document.getElementById("resultList").innerHTML = html;
}
</script>

</body>
</html>