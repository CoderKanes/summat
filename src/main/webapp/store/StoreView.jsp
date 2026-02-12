<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.StoreDAO" %>
<%@ page import="sm.data.StoreDTO" %>
<%@ page import="sm.data.MenuDAO" %>
<%@ page import="sm.data.MenuDTO" %>
<%@ page import="sm.data.MenuGroupDTO" %>
<%@ page import="sm.util.FoodCategoryUtil" %>
<%@ page import="java.util.List" %>

<%
	int storeId = -1; 
	if (request.getParameter("storeId") != null) {
		storeId = Integer.parseInt(request.getParameter("storeId"));
	} else {
		//잘못된 요청
	}
	

	String menuData = "";
	StoreDTO sdto = null;
	if(storeId!=-1) {
		StoreDAO sdao = new StoreDAO();
		sdto = sdao.GetStoreInfo(storeId);
		
		MenuDAO mdao = new MenuDAO();
		List<MenuGroupDTO> groups = mdao.getMenuGroups(storeId);
		List<MenuDTO> menus = mdao.getMenus(storeId);
		
		menuData = FoodCategoryUtil.generateMenuDataString(groups, menus);
		
		System.out.println("ddd=" + menuData);
	}
	

%>
<% if(sdto!=null){%>
	<h2><%=sdto.getName()%></h2>
	<h2><%=sdto.getAddress()%></h2>
	<h2><%=sdto.getPhone()%></h2>
<% } %>
	
 	<jsp:include page="Menu.jsp">
 		<jsp:param value="<%=menuData%>" name="menuData"/>
 	</jsp:include>