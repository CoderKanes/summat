<%@page import="java.net.SecureCacheResponse"%>
<%@page import="java.util.List"%>
<%@page import="sm.data.StoreDAO"%>
<%@page import="sm.data.StoreDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가게관리페이지</title>
<style>  
	/* main.jsp와 어울리는 기본 스타일 */  
	.toolbar {
    display: flex;
    flex-wrap: nowrap;     /* 한 줄로 유지하다가 공간이 부족하면 줄바꿈 가능하게 하려면 wrap으로 바꿔도 됨 */
    align-items: center;
    gap: 12px;
    margin: 12px 0 20px;
    padding: 8px;
    border: 1px solid #e0e0e0;
    border-radius: 6px;
    background: #fff;
  }

  .toolbar .section {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 6px 10px;
    border-right: 1px solid #eee; /* 구분선 느낌 */
  }
  .toolbar .section:last-child {
    border-right: none;
  }

  .toolbar label {
    font-size: 14px;
  }

  .toolbar input[type="text"],
  .toolbar select {
    padding: 6px 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
  }

  .btn {
    padding: 8px 12px;
    border-radius: 4px;
    border: none;
    background: #2d7be6;
    color: #fff;
    cursor: pointer;
  }

  /* 필요시 반응형 처리: 좁아지면 두 영역이 자동으로 줄바꿈되도록 */
  @media (max-width: 900px) {
    .toolbar { flex-wrap: wrap; }
    .toolbar .section { border-right: none; padding-right: 0; padding-left: 0; }
  }
	body { font-family: Arial, sans-serif; color: #333; margin: 20px; background-color: #f8f8f8; }  
	h1 { font-size: 1.6rem; margin-bottom: 16px; }  
	.panel { background: #fff; border: 1px solid #ddd; border-radius: 6px; padding: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }  
	table { border-collapse: collapse; width: 100%; }  
	th, td { border: 1px solid #ddd; padding: 8px 12px; text-align: left; }  
	thead { background: #f0f2f5; }  
	tr:nth-child(even) { background: #fafafa; }  
	.note { font-size: 0.9rem; color: #666; margin-top: 12px; }  
	.no-data { padding: 12px; color: #666; }  
	/* 버튼 등 추가 요소가 필요하면 아래에 스타일 추가 */  
	.btn { display: inline-block; padding: 8px 12px; background: #2d7be6; color: #fff; border-radius: 4px; text-decoration: none; }  
</style> 
</head>
<body>
	<% 
		StoreDAO dao = new StoreDAO();
		List<StoreDTO> list = dao.GetAllStores();
	%>

	<h1>가게관리페이지</h1>

	<table>
		<thead>
			<tr>
				<th>Store Id</th>
				<th>Name</th>
				<th>Address</th>
				<th>Phone</th>
				<th>Status</th>
				<th>Created At</th>
			</tr>
		</thead>
		
		<tbody><%
			for(StoreDTO dto : list){%>
			<tr>
				<td><%=dto.getId()%></td>
				<td><%=dto.getName()%></td>
				<td><%=dto.getAddress()%></td>
				<td><%=dto.getPhone()%></td>
				<td><%=dto.getStatus()%></td>
				<td><%=dto.getCreated_at()%></td>
			</tr>
			<%
				}
			%>
		</tbody>
	</table>		
		
</body>
</html>