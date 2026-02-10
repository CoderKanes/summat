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

			//다음과같은 형태로 넘어온다. 추후 Json같은 형태로 변화시키는게 타당함. 
			//G:::그룹번호:::정렬위치:::그룹명|||M:::소속그룹번호:::정렬위치:::메뉴아이디:::메뉴명:::가격:::이미지파일경로|||M:::소속그룹번호:::정렬위치:::메뉴아이디:::메뉴명:::가격:::이미지파일경로
			
			String RS = "\\|\\|\\|"; // 정규식 escape 주의
			String FS = ":::";
			for (String rec : menuDataParam.split(RS)) {
			    String[] c = rec.split(FS, -1);
			
			    if ("G".equals(c[0])) {
			    	MenuGroupDTO menuGroup_dto = new MenuGroupDTO();	
			    	menuGroup_dto.setStoreId(resultStroeId);
			    	menuGroup_dto.setNum(Integer.parseInt(c[1]));
			    	menuGroup_dto.setOrderIdx(Integer.parseInt(c[2]));
			    	menuGroup_dto.setName(c[3]);
			    	
			    	menu_dao.InsertMenuGroup(menuGroup_dto);
			
			    } else if ("M".equals(c[0])) {
			    	MenuDTO menu_dto = new MenuDTO();
			    	menu_dto.setStoreId(resultStroeId);
			    	menu_dto.setGroupNum(Integer.parseInt(c[1]));
			        menu_dto.setOrderIdx(Integer.parseInt(c[2]));
			        menu_dto.setId(Integer.parseInt(c[3]));
			        menu_dto.setName(c[4]);
			        menu_dto.setPrice(Integer.parseInt(c[5]));
			        menu_dto.setImage(c[6]);	
			        //menu_dto.setMenu_desc(desc);
			      
			        menu_dao.InsertMenu(menu_dto);
			        file_dao.updateFileStatus(menu_dto.getImage(), FileDAO.FileStatus.INUSE);
			    }
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