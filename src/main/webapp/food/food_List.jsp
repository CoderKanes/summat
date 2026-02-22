<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="sm.data.MenuCategoryDAO"%>
<%@ page import="sm.data.MenuDAO"%>
<%@ page import="sm.data.MenuDTO"%>
<%@ page import="sm.data.StoreDAO"%>
<%@ page import="sm.data.StoreDTO"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.URLDecoder" %>

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

	String encodeKeyword = request.getParameter("encodeKeyword");
	String keyword = request.getParameter("Keyword");
	String ccategory = request.getParameter("ccategory");
	String fcategory = request.getParameter("fcategory");
	String fooditem = request.getParameter("foodItem");
	Integer minPrice = request.getParameter("minPrice")!=null&&!request.getParameter("minPrice").isEmpty()? 
			Integer.parseInt(request.getParameter("minPrice")): null;
	Integer maxPrice = request.getParameter("maxPrice")!=null&&!request.getParameter("maxPrice").isEmpty()? 
			Integer.parseInt(request.getParameter("maxPrice")): null;
	Float location_Lat = request.getParameter("location_Lat")!=null&&!request.getParameter("location_Lat").isEmpty()? 
			Float.parseFloat(request.getParameter("location_Lat")): null;
	Float location_Lon = request.getParameter("location_Lon")!=null&&!request.getParameter("location_Lon").isEmpty()? 
			Float.parseFloat(request.getParameter("location_Lon")): null;
	
	if(encodeKeyword!=null){
		keyword = URLDecoder.decode(encodeKeyword, "UTF-8");	
	}
	
	Map< String, Integer> cultureMap = MenuCategoryDAO.getInstance().getCultureCategoryReverseMap();
	Map< String, Integer> foodtypeMap = MenuCategoryDAO.getInstance().getFoodTypeReverseMap();
	Map< String, Integer> foodItemMap = MenuCategoryDAO.getInstance().getFoodItemReverseMap();

	class FoodVeiwData{
		private int id;
		private String name;
		private String Image;
		
		FoodVeiwData(int id, String n, String i){
	this.id = id; name = n; Image = i;
		};
		int getId(){return id;}
		String getImage(){return Image;}
		String getName(){return name;}
	}

	MenuDAO mdao = new MenuDAO();
	//List<MenuDTO> foodlist = mdao.getFoodInfosWithStore();
	
	//String search, String ccategory, String fcategory, String fooditem,Integer minPrice, Integer maxPrice, Float myLat, Float myLon
	List<MenuDTO> foodlist = mdao.getFoodInfosFiltered(keyword, ccategory, fcategory,fooditem,minPrice,maxPrice,location_Lat,location_Lon);
	
	Map<String, List<FoodVeiwData>> foodMap = new HashMap<String, List<FoodVeiwData>>();
	
	
	boolean usingFoodItem = true;
	for(MenuDTO dto : foodlist){	
		
		// 0이면 승인나지 않은 가게이므로 continue인데, 지금은 가게승인 안되어서 일단 주석. 
		// if(sdto.getStatus() == 0) continue;
		
		if(keyword!=null){
			usingFoodItem = false;	
		}
		
	
		String foodName = dto.getStoreName()==null? dto.getName() : dto.getName() +" ("+ dto.getStoreName() +")";
		FoodVeiwData fvd = new FoodVeiwData(dto.getId(), foodName, dto.getImage());	
		if(dto.getCCategory_str() != null && cultureMap.get(dto.getCCategory_str()) != null)
		{		
			String ccatogory = dto.getCCategory_str();
			if(foodMap.containsKey(ccatogory))
			{				
				foodMap.get(ccatogory).add(fvd);
			}
			else
			{
				List<FoodVeiwData> list = new ArrayList<FoodVeiwData>();
				list.add(fvd);
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
						foodMap.get(fcatogory).add(fvd);
					}
					else
					{
						List<FoodVeiwData> list = new ArrayList<FoodVeiwData>();
						list.add(fvd);
						foodMap.put(fcatogory, list);
					}	
				}
			}
		}
		if(usingFoodItem && dto.getFoodItem_str() != null && foodItemMap.get(dto.getFoodItem_str()) != null)
		{
			String fItem = dto.getFoodItem_str();
			if(foodMap.containsKey(fItem))
			{				
				foodMap.get(fItem).add(fvd);
			}
			else
			{
				List<FoodVeiwData> list = new ArrayList<FoodVeiwData>();
				list.add(fvd);
				foodMap.put(fItem, list);
			}				
		}

		if ((dto.getCCategory_str() == null || cultureMap.get(dto.getCCategory_str()) == null) 
		&& (dto.getFCategory_str() == null || foodtypeMap.get(dto.getFCategory_str()) == null)
		&& (usingFoodItem && dto.getFoodItem_str() == null || foodItemMap.get(dto.getFoodItem_str()) == null)) 
		{
			if (foodMap.containsKey("분류없음")) {
				foodMap.get("분류없음").add(fvd);
			} else {
				List<FoodVeiwData> list = new ArrayList<FoodVeiwData>();
				list.add(fvd);
				foodMap.put("분류없음", list);
			}
		}
	}
%>
	<%if (foodMap != null && foodMap.size()>0) {
		for (Map.Entry<String, List<FoodVeiwData>> entry : foodMap.entrySet()) { %>
			<div class="section">
				<div class="section-title"><%= entry.getKey() %></div>
				<div class="card-container">		
					<% for (FoodVeiwData food : entry.getValue()) { %>
					<div class="food-card">
						<a href="/summat/food/foodView.jsp?menuId=<%=food.getId()%>"><img src="<%= food.getImage() %>"></a>
						<div class="food-info">
							<div class="food-name"><a href="/summat/food/foodView.jsp?menuId=<%=food.getId()%>"><%= food.getName() %></a></div>
						</div>
					</div>
					<% } %>		
				</div>
			</div>
	<% 	} 
	} else{
	%>	
		<h3>검색 결과가 없습니다.</h3>
	<%} %>

</body>
</html>