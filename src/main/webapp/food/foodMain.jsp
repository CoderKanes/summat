<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ page import="sm.data.MenuDAO"%>
<%@ page import="sm.data.MenuDTO"%>
<%@ page import="sm.data.StoreDAO"%>
<%@ page import="sm.data.StoreDTO"%>
<%@ page import="java.util.*"%>

<!DOCTYPE html>
<html>
<head>
<title>맛집 리스트</title>

<style>
body {
	font-family: Arial, sans-serif;
	background: #f5f7fa;
}

.section {
	margin: 30px 20px;
}

.section-title {
	font-size: 20px;
	font-weight: bold;
	margin-bottom: 12px;
}

.card-container {
	display: flex;
	gap: 12px;
	overflow-x: auto;
	padding-bottom: 10px;
}

.food-card {
    width: 180px;       
    min-width: 180px;
    max-width: 180px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    overflow: hidden;
    flex-shrink: 0;
}

.food-card img {
	width: 100%;
	height: 130px;
	object-fit: cover;
}

.food-info {
	padding: 10px;
}

.food-name {
	font-size: 15px;
	font-weight: bold;
}
</style>
</head>
<body>

<%
	class Food{
		String name;
		String Image;
		
		Food(String n, String i){
			name = n; Image = i;
		};
		
		String getImage(){return Image;}
		String getName(){return name;}
	}

	MenuDAO mdao = new MenuDAO();
	List<MenuDTO> foodlist = mdao.getFoodInfos();
	
	StoreDAO sdao = new StoreDAO();
	Map<Integer, StoreDTO> storeMap = new HashMap<Integer, StoreDTO>();
	
	List<Food> foods = new ArrayList<Food>();
	for(MenuDTO dto : foodlist){
		
		StoreDTO sdto;
		if(storeMap.containsKey(dto.getStoreId())){
			sdto = storeMap.get(dto.getStoreId());
		}else{
			sdto = sdao.GetStoreInfo(dto.getStoreId());
			storeMap.put(dto.getStoreId(), sdto);
		}			
		
		String foodName = sdto==null? dto.getName() : dto.getName() +" ("+ sdto.getName()+")";
		Food f = new Food(foodName, dto.getImage());
		foods.add(f);
	}
	Map<String, List<Food>> foodMap = new HashMap<String, List<Food>>();
	foodMap.put("default", foods);
%>

	<%if (foodMap != null) {
		for (Map.Entry<String, List<Food>> entry : foodMap.entrySet()) { %>
			<div class="section">
				<div class="section-title"><%= entry.getKey() %></div>
				<div class="card-container">		
					<% for (Food food : entry.getValue()) { %>
					<div class="food-card">
						<img src="<%= food.getImage() %>">
						<div class="food-info">
							<div class="food-name"><%= food.getName() %></div>
						</div>
					</div>
					<% } %>		
				</div>
			</div>
	<% 	} 
	} 
	%>

</body>
</html>