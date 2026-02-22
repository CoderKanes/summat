<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.MenuDAO"%>
<%@ page import="sm.data.MenuDTO"%>
<%@ page import="sm.data.StoreDAO"%>
<%@ page import="sm.data.StoreDTO"%>
<%@ page import="sm.data.MenuGroupDTO"%>
<%@ page import="sm.util.FoodCategoryUtil"%>
<%@ page import="sm.data.FoodCommentDTO"%>
<%@ page import="sm.data.FoodCommentDAO"%>
<%@ page import="java.util.*"%>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/> 


<style>
#map { 
width:100%; 
height:400px; 
 margin:15px 0; }
</style>

<script>
	 //1️ 댓글 삭제 함수
function deleteComment(id, boardNum) {
    var pw = prompt("비밀번호를 입력하세요");
    if(pw != null) {
        location.href = "commentDelete.jsp?id=" + id 
                        + "&boardNum=" + boardNum 
                        + "&password=" + encodeURIComponent(pw);
    }
}

let map, marker;
let lat, lon;
function initMap(){
	 if(map) return;
	 map = L.map('map').setView([lat,lon],13);
	 L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
	}


window.addEventListener('DOMContentLoaded', () => {

});

		
</script>



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
			<jsp:param name="encodeMenuData" value='<%= java.net.URLEncoder.encode(menuDataString, "UTF-8") %>' />
		</jsp:include>
		
		<%if(sdto.getGeoCode()!=null){
			String[] geolatlon = sdto.getGeoCode().split(",");
			if(geolatlon.length==2){%>
			<script>
			lat = <%=geolatlon[0]%>;
			lon = <%=geolatlon[1]%>
			initMap();
			</script>
			<div id="map" style="border:1px solid #aaa; height:200px; margin-top:10px;">
	        	지도 영역 (API 연결 전)
	        </div>
			
		<%}} %>
	<%}%>
<h2>짧은 방문 후기</h2>


<h3>댓글 목록</h3>
<%
FoodCommentDAO cdao = new FoodCommentDAO(); 
List<FoodCommentDTO> comments = cdao.getFoodComments(menuId);
%>

<% for (FoodCommentDTO c : comments) { %>
    <div class="comment" style="border:1px solid #ccc; padding:5px; margin-bottom:5px;">
        <strong><%= c.getWriter() %></strong> : <%= c.getContent() %> <br>
        작성일 : <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(c.getCreatedDate()) %> <br>
        <!-- 삭제 버튼 추가 -->
        <a href="javascript:void(0);" onclick="deleteComment(<%= c.getId() %>, <%= menuId %>)">삭제</a>
    </div>
<% } %>


	<form action="commentWrite.jsp" method="post">
    
    <!-- 작성자 -->
    <input type="text" name="writer" placeholder="작성자" required>
    
    <!-- 비밀번호 -->
    <input type="text" name="password" placeholder="비밀번호" required><br>
    
    <!-- 댓글 내용 -->
    <textarea name="content" rows="4" cols="50" placeholder="댓글을 입력하세요" required></textarea>
    
    <!-- 게시글 번호 (숨김값) -->
    <input type="hidden" name="postId" value="<%=menuId%>">
    
    <!-- 등록 버튼 -->
    <button type="submit">댓글 작성</button>

<%
    // DAO 객체 생성
    FoodCommentDAO dao = new FoodCommentDAO();
    
    // 예시: 게시글 번호 1번의 댓글 가져오기
    
%>

</form>
	 
<%}%>