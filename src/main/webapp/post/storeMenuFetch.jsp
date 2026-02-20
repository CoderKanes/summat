<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="sm.data.MenuDAO"%>
<%@ page import="sm.data.MenuDTO"%>

<%
	int storeId= Integer.parseInt(request.getParameter("storeId"));

	MenuDAO dao = new MenuDAO();
	List<MenuDTO> menus = null;
	
	menus = dao.getMenus(storeId);
	
	
	//<input type="checkbox" id="opt-in">
    // HTML 생성
    StringBuilder resultHtml = new StringBuilder();
    if(menus!=null && menus.size()>0){
    	resultHtml.append("<label>메뉴 선택</label>");
	    for (MenuDTO menu : menus) {
	        int id = menu.getId(); 
	        String name = menu.getName();
	        resultHtml.append("<label><input type='checkbox' name='selectedMenu' value='")
            .append(id).append("'> ").append(name).append("</label> ");	     
	        }
	}
    

    // 결과가 없을 때
    if (resultHtml.length() == 0) {
        out.print("<span style='color:#999;'>해당하는 가게를 찾지 못했습니다. <br />주소 혹은 찾아가는 방법을 알려주시면 도움이 됩니다.</span> <br /><input type='text' name='direct'>");
    }else{    	
    	out.print(resultHtml.toString());
    }
%>
