<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="sm.data.MenuDAO"%>
<%@ page import="sm.data.MenuDTO"%>
<%@ page import="sm.data.StoreDAO"%>
<%@ page import="sm.data.StoreDTO"%>
<%@ page import="sm.util.FoodCategoryUtil"%>
<%@ page import="sm.data.FoodCommentDTO"%>
<%@ page import="sm.data.FoodCommentDAO"%>
<%@ page import="java.util.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴 상세</title>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>

<style>
/* ===== menuDetail page only ===== */

.menuDetail-container {
    max-width: 900px;
    margin: 20px auto;
    padding: 20px;
    background: #fff;
    border-radius: 10px;
    font-family: Arial, sans-serif;
    line-height: 1.6;
}

.menuDetail-title {
    margin-top: 30px;
    border-bottom: 2px solid #eee;
    padding-bottom: 5px;
}

.menuDetail-infoBox {
    background: #fafafa;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 20px;
}

.menuDetail-image {
    max-width: 300px;
    width: 100%;
    height: auto;
    border-radius: 8px;
    border: 1px solid #ddd;
    margin: 10px 0;
}

.menuDetail-comment {
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 6px;
    padding: 10px;
    margin-bottom: 10px;
}

.menuDetail-comment a {
    color: #c0392b;
    font-size: 0.9em;
    text-decoration: none;
}

.menuDetail-comment a:hover {
    text-decoration: underline;
}

.menuDetail-commentForm {
    margin-top: 20px;
    border-top: 2px solid #eee;
    padding-top: 15px;
}

.menuDetail-commentForm input,
.menuDetail-commentForm textarea {
    width: 100%;
    padding: 8px;
    margin-bottom: 8px;
    border-radius: 4px;
    border: 1px solid #ccc;
}

.menuDetail-commentForm button {
    padding: 8px 16px;
    background: #2c7be5;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.menuDetail-commentForm button:hover {
    background: #1a5dcc;
}

#menuDetail-map {
    width: 100%;
    height: 250px;
    margin-top: 10px;
    border-radius: 8px;
    border: 1px solid #ccc;
}

 .btn-back {
    background-color: #d2b48c;      /* 연한 브라운 (Tan) */
    color: #3B2F2F; 
    border: none;                   /* 테두리 제거로 더 깔끔하게 */
    padding: 12px 24px;             /* 클릭하기 편한 여백 */
    font-size: 15px;
    font-weight: 600;
    border-radius: 8px;            /* 알약 모양의 둥근 디자인 */
    cursor: pointer;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1); /* 입체감을 위한 그림자 */
    transition: background-color 0.3s, transform 0.2s;
  }

  /* 마우스를 올렸을 때 */
  .btn-back:hover {
    background-color: #c1a37a;      /* 살짝 더 진한 브라운 */
    transform: translateY(-2px);    /* 살짝 떠오르는 효과 */
  }

  /* 클릭했을 때 */
  .btn-back:active {
    background-color: #b09269;
    transform: translateY(0);       /* 원래 위치로 */
  }
</style>

<script>
/* ===== menuDetail JS ===== */
function menuDetailDeleteComment(id, menuId) {
    var pw = prompt("비밀번호를 입력하세요");
    if (pw != null) {
        location.href = "commentDelete.jsp?id=" + id
                      + "&boardNum=" + menuId
                      + "&password=" + encodeURIComponent(pw);
    }
}

let menuDetailMap, menuDetailLat, menuDetailLon;
function menuDetailInitMap() {
    if (menuDetailMap) return;
    menuDetailMap = L.map('menuDetail-map')
        .setView([menuDetailLat, menuDetailLon], 13);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png')
        .addTo(menuDetailMap);
}


function goBack() {
    // 이전 페이지의 URL을 가져옴
    const prevUrl = document.referrer;

    // URL에 'summat/main/main.jsp'가 포함되어 있는지 확인
    if (prevUrl.indexOf('/summat/main/main.jsp') !== -1) {
        location.href = '/summat/main/main.jsp'; // 홈으로 이동
    } else {
        location.href = '/summat/food/foodMain.jsp'; // 음식 메인으로 이동
    }
}


</script>

</head>
<body>

<%
int menuId = request.getParameter("menuId") != null
        ? Integer.parseInt(request.getParameter("menuId"))
        : -1;

MenuDAO mdao = new MenuDAO();
MenuDTO mdto = mdao.getFoodInfo(menuId);

StoreDTO sdto = null;
String menuDataString = "";

if (mdto != null) {
    StoreDAO sdao = new StoreDAO();
    sdto = sdao.GetStoreInfo(mdto.getStoreId());
    menuDataString = FoodCategoryUtil.generateMenuDataString(
            mdao.getMenuGroups(mdto.getStoreId()),
            mdao.getMenus(mdto.getStoreId()));
}
%>

<div class="menuDetail-container">

<% if (mdto == null) { %>
    <h2 class="menuDetail-title">잘못된 메뉴입니다.</h2>
<% } else { %>

    <h2 class="menuDetail-title">메뉴 정보</h2>
    <div class="menuDetail-infoBox">
        <strong>메뉴명</strong> : <%=mdto.getName()%><br>
        <img class="menuDetail-image"
             src="<%=mdto.getImage()%>" alt="메뉴 이미지"><br>
        <strong>가격</strong> : <%=mdto.getPrice()%>원
    </div>

    <h2 class="menuDetail-title">가게 정보</h2>
    <% if (sdto == null) { %>
        <div class="menuDetail-infoBox">
            가게 정보를 찾을 수 없습니다.
        </div>
    <% } else { %>
        <div class="menuDetail-infoBox">
            <strong>가게 이름</strong> : <%=sdto.getName()%><br>
			<strong>가게 주소</strong> : <%=sdto.getAddress()%><br>
			<strong>전화번호</strong> : <%=sdto.getPhone()%><br>
			<br>
            <strong>가게 메뉴</strong>
            <jsp:include page="/store/Menu.jsp">
                <jsp:param name="encodeMenuData"
                    value='<%= java.net.URLEncoder.encode(menuDataString, "UTF-8") %>' />
            </jsp:include>

            <% if (sdto.getGeoCode() != null) {
                String[] geo = sdto.getGeoCode().split(",");
                if (geo.length == 2) { %>
                    <script>
                        menuDetailLat = <%=geo[0]%>;
                        menuDetailLon = <%=geo[1]%>;
                        menuDetailInitMap();
                    </script>
                    <div id="menuDetail-map"></div>
            <% }} %>
        </div>
    <% } %>
	
	<button type="button" class="btn-back" onclick="goBack()">돌아가기</button>
	
    <h2 class="menuDetail-title">짧은 방문 후기</h2>

    <%
    FoodCommentDAO cdao = new FoodCommentDAO();
    List<FoodCommentDTO> comments = cdao.getFoodComments(menuId);
    %>

    <% for (FoodCommentDTO c : comments) { %>
        <div class="menuDetail-comment">
            <strong><%=c.getWriter()%></strong><br>
            <%=c.getContent()%><br>
            <small>
                <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm")
                    .format(c.getCreatedDate()) %>
            </small><br>
            <a href="javascript:void(0);"
               onclick="menuDetailDeleteComment(<%=c.getId()%>, <%=menuId%>)">
                삭제
            </a>
        </div>
    <% } %>

    <form class="menuDetail-commentForm"
          action="commentWrite.jsp" method="post">
        <input type="text" name="writer" placeholder="작성자" required>
        <input type="text" name="password" placeholder="비밀번호" required>
        <textarea name="content" rows="4"
                  placeholder="댓글을 입력하세요" required></textarea>
        <input type="hidden" name="postId" value="<%=menuId%>">
        <button type="submit">댓글 작성</button>
    </form>

<% } %>

</div>
</body>
</html>