<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sm.data.MenuCategoryDAO"%>
<%@ page import="java.util.Map"%>

<!DOCTYPE html>
<html>
<head>
    <title>메뉴 등록</title>
    <style>
        .section { margin-bottom: 20px; }
        .box { border: 1px solid #ccc; padding: 10px; }
        label { margin-right: 10px; display: inline-block; cursor: pointer; }
        #foodResult { min-height: 30px; }
    </style>
</head>
<body>

<%
	Map<String, Integer> cultureMap = MenuCategoryDAO.getInstance().getCultureCategoryMap();
	Map<String, Integer> typeMap = MenuCategoryDAO.getInstance().getFoodTypeMap();
	
	// {"한식", "일식", "중식","양식", "퓨전", "기타"};
    String[] CultureCategory = cultureMap.keySet().toArray(String[]::new);
  //{"면류", "밥류", "국물/탕","빵", "고기", "해산물","기타"};
    String[] FoodTypeCategory = typeMap.keySet().toArray(String[]::new);
%>

<form id="menuForm">
    <div class="section box">
        <label>국가 카테고리</label>
        <select id="CCSelect" name="cultureCategory">
            <option value="">선택하세요</option>
            <%for(String cc : CultureCategory){ %>
            <option value="<%=cc%>"><%=cc%></option>
            <%} %>
        </select>
    </div>

    <div class="section box">
        <label>음식 카테고리</label>
        <%for(String fc : FoodTypeCategory){ %>
        <label><input type="checkbox" name="foodType" value="<%=fc%>" class="filter-check"><%=fc%></label>
        <%} %>
    </div>

    <div class="section box">
        <label>음식 분류</label>
        <div id="foodResult">
            <span style="color:#999;">카테고리를 선택해주세요.</span>
        </div>
    </div>

    <button type="submit">최종 등록</button>
</form>

<script>
document.addEventListener('DOMContentLoaded', function() {
	  // 1. 함수 정의
    function fetchFilteredFoods() {
        const ccSelect = document.getElementById('CCSelect');
        const ccValue = ccSelect.value;
        
        // 체크박스 값 수집 (순수 JS 방식)
        const checkedBoxes = document.querySelectorAll('input[name="foodType"]:checked');
        const params = new URLSearchParams();
        params.append('cc', ccValue);
        
        checkedBoxes.forEach(cb => {
            // 서버에서 배열로 받기 위해 'fcs[]' 이름으로 추가
            params.append('fcs[]', cb.value);
        });

        // 2. fetch API 사용 (jQuery의 $.ajax 역할)
        fetch('menu_data_fetch.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        })
        .then(response => response.text()) // 서버 응답을 텍스트(HTML)로 변환
        .then(data => {
            // 3. 결과 div 갱신
            document.getElementById('foodResult').innerHTML = data;
        })
        .catch(error => console.error('Error:', error));
    }

    // 4. 이벤트 바인딩 (하나씩 걸어줘야 함)
    document.getElementById('CCSelect').addEventListener('change', fetchFilteredFoods);
    
    document.querySelectorAll('.filter-check').forEach(checkbox => {
        checkbox.addEventListener('change', fetchFilteredFoods);
    });
});
</script>

</body>
</html>
