<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.MenuCategoryDAO"%>
<%@ page import="java.util.Map"%>
<html>
<head>
<title>음식 검색</title>
<style>
  .tabs button { margin-right: 10px; }
  .column { float: left; width: 30%; border: 1px solid #ddd; min-height: 200px; max-height: 200px; overflow-y: auto; padding: 10px; }
  .clear { clear: both; }
  li { cursor: pointer; }
</style>

<%
	Map<String, Integer> cultureMap = MenuCategoryDAO.getInstance().getCultureCategoryReverseMap();
	Map<String, Integer> typeMap = MenuCategoryDAO.getInstance().getFoodTypeReverseMap();
	
    String culturesJson = String.join("','", cultureMap.keySet());
    String typesJson = String.join("','", typeMap.keySet());
%>

<script>
const cultureList = ['<%= culturesJson %>'];
const typeList = ['<%= typesJson %>'];

function renderCategory(list) {
    var html = "<ul>";
    for (var i = 0; i < list.length; i++) {
        var item = list[i];
        // 문자열 더하기(+) 방식으로 변경
        html += "<li onclick=\"loadDish('" + item + "')\">" + item + "</li>";
    }
    html += "</ul>";
    
    document.getElementById("col1").innerHTML = html;
    document.getElementById("col2").innerHTML = "";
    document.getElementById("col3").innerHTML = "";
}

function loadCuisine() {
	renderCategory(cultureList);
}

function loadFoodType() {
	renderCategory(typeList);
}

function loadDish(parent) {
	var params = new URLSearchParams();
	params.append("category", parent);

	fetch("getFilterFood.jsp?" + params.toString())
		.then(function(response) { return response.text(); })
	    .then(function(data) {
	    	// 2. 서버가 보내준 <li> 태그 뭉치를 col2에 넣기
	    	document.getElementById("col2").innerHTML = "<ul>" + data + "</ul>";
	        document.getElementById("col3").innerHTML = ""; // 3단은 초기화
		})
	    .catch(function(error) {
	    	console.error("Error:", error);
	    });
}

function loadDetail(dish) {
  document.getElementById("col3").innerHTML = `
    <ul>
      <li>${dish} - 혼밥</li>
      <li>${dish} - 매운맛</li>
      <li>${dish} - 배달</li>
    </ul>`;
}
</script>
</head>

<body>

<h2>음식 검색</h2>

<!-- 상단 탭 -->
<div class="tabs">
  <button onclick="loadCuisine()">국가별</button>
  <button onclick="loadFoodType()">음식종류별</button>
</div>

<hr>

<!-- 3단 컬럼 -->
<div class="column" id="col1">대분류</div>
<div class="column" id="col2">대표 음식</div>
<div class="column" id="col3">세부 조건</div>

<div class="clear"></div>

</body>
</html>