<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="sm.data.MenuCategoryDAO"%>
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
	Map< String, Integer> cultureMap = MenuCategoryDAO.getInstance().getCultureCategoryReverseMap();
	Map< String, Integer> foodtypeMap = MenuCategoryDAO.getInstance().getFoodTypeReverseMap();
	Map< String, Integer> foodItemMap = MenuCategoryDAO.getInstance().getFoodItemReverseMap();

	class FoodVeiwData{
		String name;
		String Image;
		
		FoodVeiwData(String n, String i){
	name = n; Image = i;
		};
		
		String getImage(){return Image;}
		String getName(){return name;}
	}

	MenuDAO mdao = new MenuDAO();
	List<MenuDTO> foodlist = mdao.getFoodInfos();
	
	StoreDAO sdao = new StoreDAO();
	Map<Integer, StoreDTO> storeMap = new HashMap<Integer, StoreDTO>();	
	Map<String, List<FoodVeiwData>> foodMap = new HashMap<String, List<FoodVeiwData>>();
		
	
	for(MenuDTO dto : foodlist){
		StoreDTO sdto;
		if(storeMap.containsKey(dto.getStoreId())){	
			sdto = storeMap.get(dto.getStoreId());
		}else{	
			sdto = sdao.GetStoreInfo(dto.getStoreId());	storeMap.put(dto.getStoreId(), sdto);
		}
		
		// 0이면 승인나지 않은 가게이므로 continue인데, 지금은 가게승인 안되어서 일단 주석. 
		// if(sdto.getStatus() == 0) continue;
	
		String foodName = sdto==null? dto.getName() : dto.getName() +" ("+ sdto.getName()+")";
		FoodVeiwData f = new FoodVeiwData(foodName, dto.getImage());	
		System.out.println(foodName + dto.getCCategory_str()  + dto.getFCategory_str() + dto.getFoodItem_str());
		if(dto.getCCategory_str() != null && cultureMap.get(dto.getCCategory_str()) != null)
		{		
			String ccatogory = dto.getCCategory_str();
			if(foodMap.containsKey(ccatogory))
			{				
				foodMap.get(ccatogory).add(f);
			}
			else
			{
				List<FoodVeiwData> list = new ArrayList<FoodVeiwData>();
				list.add(f);
				foodMap.put(ccatogory, list);
			}			
		}
		if(dto.getFCategory_str() != null){
			for(String FCategory_str : dto.getFCategory_str().split(","))
			{
				if(foodtypeMap.get(FCategory_str) != null)
				{		
					String fcatogory = FCategory_str;
					if(foodMap.containsKey(fcatogory))
					{				
						foodMap.get(fcatogory).add(f);
					}
					else
					{
						List<FoodVeiwData> list = new ArrayList<FoodVeiwData>();
						list.add(f);
						foodMap.put(fcatogory, list);
					}	
				}
			}
		}
		if(dto.getFoodItem_str() != null && foodItemMap.get(dto.getFoodItem_str()) != null)
		{
			String fItem = dto.getFoodItem_str();
			if(foodMap.containsKey(fItem))
			{				
				foodMap.get(fItem).add(f);
			}
			else
			{
				List<FoodVeiwData> list = new ArrayList<FoodVeiwData>();
				list.add(f);
				foodMap.put(fItem, list);
			}				
		}

		if ((dto.getCCategory_str() == null || cultureMap.get(dto.getCCategory_str()) == null) 
		&& (dto.getFCategory_str() == null || foodtypeMap.get(dto.getFCategory_str()) == null)
		&& (dto.getFoodItem_str() == null || foodItemMap.get(dto.getFoodItem_str()) == null)) 
		{
	if (foodMap.containsKey("분류없음")) {
		foodMap.get("분류없음").add(f);
	} else {
		List<FoodVeiwData> list = new ArrayList<FoodVeiwData>();
		list.add(f);
		foodMap.put("분류없음", list);
	}
		}
	}
%>

	<%if (foodMap != null) {
		for (Map.Entry<String, List<FoodVeiwData>> entry : foodMap.entrySet()) { %>
			<div class="section">
				<div class="section-title"><%= entry.getKey() %></div>
				<div class="card-container">		
					<% for (FoodVeiwData food : entry.getValue()) { %>
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