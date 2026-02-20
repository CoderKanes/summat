<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="sm.data.StoreDAO"%>
<%@ page import="sm.data.StoreDTO"%>

<%
    String storeName = request.getParameter("storeName");

	StoreDAO dao = new StoreDAO();
	List<StoreDTO> stores = null;
	if(storeName != null || storeName.isEmpty()==false)
	{
		 stores = dao.GetStoresByName(storeName);
	}
	
	
    // 3. 필터링 및 HTML 생성
    StringBuilder resultHtml = new StringBuilder();
    if(stores!=null && stores.size()>0){
    	resultHtml.append("<select id='storeSelect' name='storeSelect' onchange='findMenus(this.value)'>");
	    for (StoreDTO store : stores) {
	        String name = store.getName();  
			
	        	String storeInfo ="<option value="+store.getId()+ ">" + store.getName() + "("+ store.getAddress() +")" + "</option>";
	            resultHtml.append(storeInfo);
	        }
	    resultHtml.append("</select>");
	}
    

    // 결과가 없을 때
    if (resultHtml.length() == 0) {
        out.print("<span style='color:#999;'>해당하는 가게를 찾지 못했습니다. <br />주소 혹은 찾아가는 방법을 알려주시면 도움이 됩니다.</span> <br /><input type='text' name='direct'>");
    }else{    	
    	out.print(resultHtml.toString());
    }
%>
