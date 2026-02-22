<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="sm.data.StoreDAO, sm.data.StoreDTO, sm.data.MenuDAO, sm.data.MenuDTO" %>
<%
    int storeId = -1;
	
	try {
		storeId = Integer.parseInt(request.getParameter("storeId"));	   
	} catch (NumberFormatException ex)
	{
	   
	}
	


    String menusParam = request.getParameter("menus"); 
    
    StringBuilder sb = new StringBuilder();
    
    // 가게 정보 조회
    StoreDAO sdao = new StoreDAO();
    StoreDTO sdto = (storeId != -1)?sdao.GetStoreInfo(storeId) : null;
    if(sdto != null) {
        sb.append("방문하신 가게 : ").append(sdto.getName());
    }

    // 메뉴 정보 조회
    if(menusParam != null && !menusParam.isEmpty()) {
        String[] menuIds = menusParam.split(",");
        MenuDAO mdao = new MenuDAO();
        sb.append("\n리뷰 메뉴 : "); // 구분자로 줄바꿈 사용
        
        for(int i=0; i < menuIds.length; i++) {
            MenuDTO mdto = mdao.getFoodInfo(Integer.parseInt(menuIds[i]));
            sb.append(mdto.getName());
            if(i < menuIds.length - 1) sb.append(", ");
        }
    }
    out.print(sb.toString());
%>