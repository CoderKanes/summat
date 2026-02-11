<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="sm.data.MenuCategoryDAO"%>
<%@ page import="sm.data.FoodCategory"%>

<%
    // 1. 파라미터 받기
    String selectedCC = request.getParameter("cc");
    String[] selectedFCs = request.getParameterValues("fcs[]"); 
    List<String> selectedFCList = (selectedFCs != null) ? Arrays.asList(selectedFCs) : new ArrayList<>();

    // 2. 가상의 데이터 (원래는 DB 조회)
    // 구조: 이름, 카테고리들...
   	List<FoodCategory> foodInfos= MenuCategoryDAO.getInstance().getFoodCategoryInfos();
    
    // 3. 필터링 및 HTML 생성
    StringBuilder resultHtml = new StringBuilder();
    for (FoodCategory food : foodInfos) {
        String name = food.getName();

        boolean matchesCC = true;
        if(selectedCC != null && !selectedCC.isEmpty()) matchesCC =  food.getCultureCategories().contains(selectedCC);
        boolean matchesFC = true;
        
        for (String fc : selectedFCList) {
            if (!food.getFoodTypeCategories().contains(fc)) {
                matchesFC = false;
                break;
            }
        }

        if (matchesCC && matchesFC) {
            resultHtml.append("<label><input type='checkbox' name='selectedFood' value='")
                      .append(name).append("'> ").append(name).append("</label> ");
        }
    }
	boolean HasFilter = (selectedCC != null && !selectedCC.isEmpty()) || selectedFCList.size() != 0;

    // 결과가 없을 때
    if (HasFilter && resultHtml.length() == 0) {
        out.print("<span style='color:#999;'>조건에 맞는 음식이 없습니다.</span> <br /><label><input type='checkbox' name='selectedFood' value='그 외'>그 외</label>");
    }else if(HasFilter && resultHtml.length() != 0){
    	resultHtml.append("<label><input type='checkbox' name='selectedFood' value='그 외'>그 외</label>");
    	out.print(resultHtml.toString());
    }
    else {    
        out.print("<span style='color:#999;'>카테고리를 선택해주세요.</span>");
    }
%>
