<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.MenuDAO"%>
<%@ page import="sm.data.MenuDTO"%>
<%@ page import="sm.data.StoreDAO"%>
<%@ page import="sm.data.StoreDTO"%>
<%@ page import="sm.data.MenuGroupDTO"%>
<%@ page import="sm.util.FoodCategoryUtil"%>

<%@ page import="java.util.*"%>

<%
int menuId = request.getParameter("menuId")!=null? Integer.parseInt(request.getParameter("menuId")) : -1;
int storeId = -1;
String menuDataString ="";

MenuDAO mdao = new MenuDAO();
MenuDTO mdto = mdao.getFoodInfo(menuId);

StoreDAO sdao = new StoreDAO();
StoreDTO sdto = null;

if(mdto!=null){ 
	storeId = mdto.getStoreId();	
	sdto = sdao.GetStoreInfo(storeId);	
	menuDataString = FoodCategoryUtil.generateMenuDataString(mdao.getMenuGroups(storeId), mdao.getMenus(storeId));
}
%>

<%if(mdto == null){ %>
	<h2>잘못된 메뉴입니다.</h2>
<%}else{ %>

<h2>메뉴정보</h2>

메뉴명 : <%=mdto.getName()%> <br />
<img src="<%=mdto.getImage()%>"/> <br />
가격 : <%=mdto.getPrice()%> <br />

<h2>가게정보</h2>
	<%if(sdto == null){ %>
		<h2>가게정보를 찾을수 없습니다.</h2>
	<%}else{ %>		
	가게이름 : <%=sdto.getName()%> <br />
	
	가게메뉴
		<jsp:include page="/store/Menu.jsp">
			<jsp:param name="menuData" value="<%=menuDataString%>" />
		</jsp:include>
	<%}%>
<h2>짧은 방문 후기</h2>
	댓글
<%}%>