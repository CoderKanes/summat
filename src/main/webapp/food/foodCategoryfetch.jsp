<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="sm.data.MenuCategoryDAO"%>
<%@ page import="sm.data.FoodCategory"%>

<%
    // 1. 파라미터 받기
    String selectedCC = request.getParameter("cc");
    String selectedFC = request.getParameter("fc"); 

    System.out.println(selectedCC +  selectedFC);
    // 2. 가상의 데이터 (원래는 DB 조회)
    // 구조: 이름, 카테고리들...
   	List<FoodCategory> foodInfos= MenuCategoryDAO.getInstance().getFoodCategoryInfos();
    
    // 3. 필터링 및 HTML 생성
    StringBuilder resultHtml = new StringBuilder();
    if(selectedCC != null && selectedFC != null)
    {
	    for (FoodCategory food : foodInfos) {
	        String name = food.getName();
	
	        boolean matchesCC = true;
	        if(selectedCC != null && !selectedCC.isEmpty()) matchesCC =  food.getCultureCategories().contains(selectedCC);
	        
	        boolean matchesFC = true;        
	        if(selectedFC != null && !selectedFC.isEmpty()) matchesFC =  food.getFoodTypeCategories().contains(selectedFC);
	   
	
	        if (matchesCC && matchesFC) {
	        	
	        	if(resultHtml.isEmpty())
	        	{
	        		resultHtml.append("<option value=''>").append("미선택").append("</option>");
	        	}
	        	
	            resultHtml.append("<option value='")
	                      .append(name).append("'> ").append(name).append("</option>");
	        }
	    }
    }
    else
    {
    	resultHtml.append("<option value=''>").append("이전 카테고리 선택").append("</option>");
    }

    // 결과가 없을 때
    if (resultHtml.length() == 0) {
        out.print("<option value=>조건에 맞는 음식이 없습니다.</option>");
    }else if(resultHtml.length() != 0){    	
    	out.print(resultHtml.toString());
    }
    else {    
        out.print("<span style='color:#999;'>카테고리를 선택해주세요.</span>");
    }
%>
