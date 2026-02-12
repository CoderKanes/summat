<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="sm.data.StoreDAO" %>
<%@ page import="sm.data.StoreDTO" %>
<%@ page import="sm.data.MenuDAO" %>
<%@ page import="sm.data.MenuDTO" %>
<%@ page import="sm.data.MenuGroupDTO" %>
<%@ page import="sm.data.FileDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="sm.util.HTMLUtil" %>
<%@ page import="sm.util.FoodCategoryUtil" %>
    
<%
    // DB 저장
    StoreDAO store_dao = new StoreDAO();
	StoreDTO store_dto = new StoreDTO();	
	
	//required params	
	store_dto.setName(request.getParameter("name"));
	store_dto.setPhone(request.getParameter("address"));
	store_dto.setAddress(request.getParameter("phoneNum"));	
	
	int resultStroeId = store_dao.InsertStore(store_dto);
	if(resultStroeId != -1)	{
		String menuDataParam = request.getParameter("menuData");
		if(menuDataParam!=null)	{
			MenuDAO menu_dao = new MenuDAO();	
			FileDAO file_dao = new FileDAO();

			FoodCategoryUtil.MenuData data = FoodCategoryUtil.menuDataParse(menuDataParam, resultStroeId);
			
			for(MenuGroupDTO groupdto : data.groupDTOs)
			{
				menu_dao.InsertMenuGroup(groupdto);
			}
			
			for(MenuDTO menudto : data.menuDTOs)
			{
				menu_dao.InsertMenu(menudto);
				file_dao.updateFileStatus(menudto.getImage(), FileDAO.FileStatus.INUSE);
			}			
		}
	}	
%>

<h1>스토어 등록 진행 페이지</h1>
<script>
<%if(resultStroeId == -1){%>
	alert("등록실패. 나중에 다시시도해 주세요.");
<%}else{%>
	alert("등록완료. 관리자 승인후 게재됩니다.");
<%}%>
location.href = '/summat/sm/main.jsp';
</script>