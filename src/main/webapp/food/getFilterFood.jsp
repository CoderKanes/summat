<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sm.data.MenuCategoryDAO"%>
<%@ page import="sm.data.FoodCategory"%>
<%@ page import="java.util.List"%>
<%
    String category = request.getParameter("category");
    List<FoodCategory> allFoods = MenuCategoryDAO.getInstance().getFoodCategoryInfos();
    StringBuilder html = new StringBuilder();

    for (FoodCategory food : allFoods) {
        // 해당 음식이 선택한 카테고리(국가 혹은 타입)를 포함하고 있는지 확인
        if (food.getCultureCategories().contains(category) || 
            food.getFoodTypeCategories().contains(category)) {
            
            html.append("<li onclick=\"loadDetail('" + food.getName() + "')\">")
                .append(food.getName())
                .append("</li>");
        }
    }

    if (html.length() == 0) {
        out.print("<li>데이터가 없습니다.</li>");
    } else {
        out.print(html.toString());
    }
%>
