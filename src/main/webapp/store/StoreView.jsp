<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.StoreDAO" %>
<%@ page import="sm.data.StoreDTO" %>
<%@ page import="sm.data.MenuDAO" %>
<%@ page import="sm.data.MenuDTO" %>
<%@ page import="sm.data.MenuGroupDTO" %>
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
		
		//generate menuData format; 
		//G:::그룹번호:::정렬위치:::그룹명|||M:::소속그룹번호:::정렬위치:::메뉴아이디:::메뉴명:::가격:::이미지파일경로|||M:::소속그룹번호:::정렬위치:::메뉴아이디:::메뉴명:::가격:::이미지파일경로
		for(int i = 0; i < groups.size(); ++i)
		{
			MenuGroupDTO gdto = groups.get(i);
			if(i!=0)
			{
				menuData += "|||";
			}
		
			menuData += "G:::"+gdto.getNum()+":::"+gdto.getOrderIdx()+":::"+gdto.getName(); 
			
			for(int j = 0; j < menus.size(); ++j)
			{
				MenuDTO mdto = menus.get(j);
				if(mdto.getGroupNum() == gdto.getNum())	{
					menuData += "|||M:::"+mdto.getGroupNum()+":::"+mdto.getOrderIdx()+":::"+mdto.getId()+":::"+mdto.getName()+":::"+mdto.getPrice()+":::"+mdto.getImage();
				}
			}
		}
		
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