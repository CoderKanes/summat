<%@page import="oracle.sql.BOOLEAN"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="sm.data.MenuDTO" %>
<%@ page import="sm.data.MenuGroupDTO" %>
<%@ page import="sm.util.FoodCategoryUtil" %>

<%
	String editParam = request.getParameter("Edit");
	boolean bEditMode = false;
	if(editParam != null ){
		bEditMode = Boolean.parseBoolean(editParam);		
	}
List<FoodCategoryUtil.GroupViewData> viewDatas = null;
String menuData = request.getParameter("menuData");
if(menuData != null)
{	
	FoodCategoryUtil.MenuData data = FoodCategoryUtil.menuDataParse(menuData);	
	viewDatas = data.GetGroupViewDatas();
}

if(viewDatas==null || viewDatas.size() == 0){
	if(viewDatas==null)	{
		viewDatas = new ArrayList<FoodCategoryUtil.GroupViewData>();
	}
	FoodCategoryUtil.GroupViewData v = new FoodCategoryUtil.GroupViewData();
	v.group = new MenuGroupDTO();
	v.group.setNum(0);
	v.group.setOrderIdx(0);
	v.group.setName("메뉴");
	viewDatas.add(v);
}

//List<Group> groups = new ArrayList<>();

//Group g1 = new Group(1, "세트메뉴");
//g1.menus.add(new Menu(101, "불고기 세트", 12000, "https://picsum.photos/80?1"));
//g1.menus.add(new Menu(102, "제육 세트", 11000, "https://picsum.photos/80?2"));

//Group g2 = new Group(2, "단품");
//g2.menus.add(new Menu(201, "김치찌개", 8000, "https://picsum.photos/80?3"));

//groups.add(g1);
//groups.add(g2);
%>

<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<% if(bEditMode){ %>
<title>메뉴 편집</title>
<% }else{ %>
<title>메뉴</title>
<% }%>

<script	src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.2/Sortable.min.js"></script>

<style>
body {
	margin: 0;
	font-family: -apple-system;
	background: #f2f2f2
}

/* 상단 */
.header {
	position: sticky;
	top: 0;
	z-index: 10;
	background: #fff;
	padding: 14px 16px;
	border-bottom: 1px solid #ddd;
	display: flex;
	justify-content: space-between;
	align-items: center
}

.header b {
	font-size: 18px
}

.header button {
	margin-left: 8px
}

/* 그룹 레이아웃 */
.group-container {
	display: flex;
	flex-wrap: wrap;
	gap: 16px;
	padding: 16px
}

@media ( max-width :768px) {
	.group-container {
		flex-direction: column
	}
}

.group {
	background: #fff;
	border-radius: 14px;
	width: 320px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, .05);
	display: flex;
	flex-direction: column
}

@media ( max-width :768px) {
	.group {
		width: 100%
	}
}

.group.collapsed .menu-list {
	max-height: 0;
	opacity: 0
}

/* 그룹 헤더 */
.group-header {
	padding: 14px 16px;
	background: #fafafa;
	display: flex;
	justify-content: space-between;
	align-items: center;
	user-select: none;
}
.group-header-edit {
	padding: 14px 16px;
	background: #fafafa;
	display: flex;
	justify-content: space-between;
	align-items: center;
	user-select: none;
	cursor: grab
}

.group-title {
	font-weight: 700
}

.group-title.editing input {
	font-size: 16px;
	font-weight: 700;
	border: none;
	outline: none;
	background: #fffbe6;
	width: 100%
}

/* 메뉴 */
.menu-list {
	transition: .3s;
	overflow-y: auto
}

.menu {
	display: flex;
	align-items: center;
	border-top: 1px solid #eee
}

.drag-handle {
	padding: 14px;
	font-size: 20px;
	color: #999;
	cursor: grab
}

.menu-body {
	flex: 1;
	padding: 10px
}

.menu-name {
	font-weight: 600
}

.menu-price {
	font-size: 13px;
	color: #777
}

.menu-img {
	width: 52px;
	height: 52px;
	border-radius: 8px;
	object-fit: cover;
	margin-right: 10px
}
</style>
</head>

<body>
	
	<% if(bEditMode){ %>
	<div class="header">
		<b>메뉴 편집</b>
		<div>
			<button onclick="resetEdit()">초기화</button>
			<button onclick="saveEdit()">편집완료</button>
		</div>
	</div>
	<% } %>

	<div class="group-container" id="groupList">

		<%
		for (FoodCategoryUtil.GroupViewData vdata : viewDatas) {
		%>
		<div class="group" data-group-id="<%=vdata.group.getNum()%>">
			<% if(bEditMode){%>
			<div class="group-header-edit" ondblclick="editGroupName(this)"				
				oncontextmenu="groupAction(event,this)">
			<% }else{%>
			<div class="group-header">
			<% } %>
				<span class="group-title"><%=vdata.group.getName()%></span>
				<% if(bEditMode){%>
				<button onclick="addMenu(this)">+ 메뉴</button>
				<% } %>
			</div>

			<div class="menu-list">
				<%
				for (MenuDTO m : vdata.menus) {
				%>
				<div class="menu" data-menu-id="<%=m.getId()%>">
					<% if(bEditMode){%>
					<div class="drag-handle">≡</div>					
					<div class="menu-body" onclick="menuEditAction(<%=m.getId()%>)">
					<% }else{ %>
					<div class="menu-body" onclick="menuClicked(<%=m.getId()%>)">
					<% } %>
						<div class="menu-name"><%=m.getName()%></div>
						<div class="menu-price"><%=m.getPrice()%>원</div>
					</div>
						<img class="menu-img" src="<%=m.getImage()%>">
					</div>
				<%
				}
				%>
				</div>
		</div>
		<%
		}
		%>

	</div>
	<% if(bEditMode){ %>
	<button style="margin: 16px" onclick="addGroup()">+ 그룹 추가</button>

	<form id="saveForm" method="post" action="storeRegist.jsp">
		<input type="hidden" name="menuData" id="menuData">
	</form>
	<%} %>

	<script>
/* ===== 상태 ===== */
let initialHTML = '';
let groupTimer=null;

window.onload=()=>{
  <% if(bEditMode){ %>
  initialHTML=document.getElementById('groupList').innerHTML;
  initMenuSortable();
  initGroupSortable();
  initNextGroupId();
  initNextMenuId();  
  <%}%>
};

/* ===== 메뉴 드래그 ===== */
function initMenuSortable(){
  document.querySelectorAll('.menu-list').forEach(list=>{
    Sortable.create(list,{
      group:'menus',
      handle:'.drag-handle',
      animation:150,
      scroll:true
    });
  });
}

/* ===== 그룹 드래그 ===== */
function initGroupSortable(){
  Sortable.create(document.getElementById('groupList'),{
    handle:'.group-header-edit',
    animation:200
  });
}

/* ===== 그룹명 수정 ===== */
function editGroupName(headerEl) {
  // 1. 헤더 내부에서 제목이 들어있는 span만 찾습니다.
  const titleSpan = headerEl.querySelector('.group-title');
  if (!titleSpan || headerEl.classList.contains('editing')) return;

  const oldName = titleSpan.innerText;
  headerEl.classList.add('editing');

  // 2. span 내부를 input으로 교체 (버튼은 건드리지 않음)
  titleSpan.innerHTML = `<input type="text" value="${oldName}" style="width:70%;">`;
  
  const input = titleSpan.querySelector('input');
  input.focus();
  input.select(); // 텍스트 전체 선택 (사용자 편의성)

  // 3. 완료 처리 함수
  const finish = () => {
    const newName = input.value.trim() || oldName;
    headerEl.classList.remove('editing');
    titleSpan.innerText = newName; // input을 제거하고 텍스트만 남김
  };

  input.onblur = finish;
  input.onkeydown = e => {
    if (e.key === 'Enter') finish();
    if (e.key === 'Escape') {
      headerEl.classList.remove('editing');
      titleSpan.innerText = oldName; // 원래대로 복구
    }
  };
}

/* ===== 그룹 삭제 ===== */
function groupAction(e,header){
  e.preventDefault();
  const g=header.closest('.group');
  if(g.querySelectorAll('.menu').length){
    alert('메뉴가 있는 그룹은 삭제 불가');
    return;
  }
  if(confirm('그룹 삭제?')) g.remove();
}

/* ===== 메뉴 액션 ===== */
function menuEditAction(id){
	var menuEl = document.querySelector('.menu[data-menu-id="' + id + '"]');
	if (!menuEl) return;
	var groupEl = menuEl.closest('.group');
	var groupId = groupEl ? groupEl.dataset.groupId : null;
	var nameEl = menuEl.querySelector('.menu-name');
	var priceEl = menuEl.querySelector('.menu-price');
	var imgEl = menuEl.querySelector('.menu-img');

	var menu = {
		id: id,
		name: nameEl ? nameEl.innerText.trim() : '',
		price: priceEl ? priceEl.innerText.replace('원','') : '',
		img: imgEl ? imgEl.getAttribute('src') : ''
	};
	
  const sel=prompt('1:수정  2:삭제');
  if(sel==='1'){
	  openMenuPopup(groupId, menu);
  }
  
  if(sel==='2') {
    if(confirm('삭제?')){
      document.querySelector(`[data-menu-id="${id}"]`).remove();
    }
  }
}

function menuClicked(id){
	
}

/* ===== 추가 ===== */

 let nextGroupId = 0;
 function initNextGroupId(){
	  document.querySelectorAll('.group[data-group-id]').forEach(el=>{
	    const id = parseInt(el.dataset.groupId, 10);
	    if(!isNaN(id) && id >= nextGroupId){
	    	nextGroupId = id + 1;
	    }
	  });
	}
 let nextMenuId = 0;
 function initNextMenuId(){
	  document.querySelectorAll('.menu[data-menu-id]').forEach(el=>{
	    const id = parseInt(el.dataset.menuId, 10);
	    if(!isNaN(id) && id >= nextMenuId){
	      nextMenuId = id + 1;
	    }
	  });
	}

function addGroup(){
  const name=prompt('그룹명');
  if(!name)return;
  const div=document.createElement('div');
  div.className='group';
  div.dataset.groupId = nextGroupId++;
  div.innerHTML = `
	    <div class="group-header-edit" ondblclick="editGroupName(this)">
	      <span class="group-title">` + name + `</span>
	      <button onclick="addMenu(this)">+ 메뉴</button>
	    </div>
	    <div class="menu-list"></div>`;
  document.getElementById('groupList').appendChild(div);
  initMenuSortable();
}
function addMenu(btn){
	const groupid = btn.closest('.group').dataset.groupId;
	openMenuPopup(groupid);
	return;
	
  //const name=prompt('메뉴명');
 // if(!name)return;
  const m=document.createElement('div');
  m.className='menu';
  m.innerHTML=`
    <div class="drag-handle">≡</div>
    <div class="menu-body" onclick="menuAction(77)">
      <div class="menu-name">${name}</div>
      <div class="menu-price">0원</div>
    </div>
    <img class="menu-img" src="https://picsum.photos/80">`;
  btn.closest('.group').querySelector('.menu-list').appendChild(m);
}

/* ===== 저장/초기화 ===== */
function resetEdit(){
  if(!confirm('초기화?'))return;
  document.getElementById('groupList').innerHTML=initialHTML;
  initMenuSortable();initGroupSortable();
}

function saveEdit() {
	  const RS = '|||'; // record separator
	  const FS = ':::'; // field separator

	  let records = [];

	  // 1. 기존 그룹/메뉴 데이터 파싱 로직 (기존과 동일)
	  document.querySelectorAll('.group').forEach((groupEl, gOrder) => {
	    const groupId = groupEl.dataset.groupId || 0;
	    const groupName = groupEl.querySelector('.group-title')?.innerText.trim() || '';
	    records.push(['G', groupId, gOrder, groupName].join(FS));

	    groupEl.querySelectorAll('.menu').forEach((menuEl, mOrder) => {
	      const menuId = menuEl.dataset.menuId || 0;
	      const name = menuEl.querySelector('.menu-name')?.innerText.trim() || '';
	      const price = menuEl.querySelector('.menu-price')?.innerText.replace('원', '') || '0';
	      const img = menuEl.querySelector('.menu-img')?.getAttribute('src') || '';
	      const desc = menuEl.querySelector('.menu-desc')?.innerText.trim() || '';
	      const culture = menuEl.dataset.culture || '';
	      const foodTypes = menuEl.dataset.foodTypes || '';
	      const foodItem = menuEl.dataset.foodItem || '';
	      records.push(['M', groupId, mOrder, menuId, name, price, img, desc, culture, foodTypes, foodItem].join(FS));
	    });
	  });

	  //기존 파라미터 유지	  
	  const saveForm = document.getElementById('saveForm');
	  const urlParams = new URLSearchParams(window.location.search);

	  const excludeKeys = ['menuData', 'Edit', 'someOtherKey']; // 제외할 목록

	  urlParams.forEach((value, key) => {
	      if (!excludeKeys.includes(key)) {
	    	  let input = saveForm.querySelector(`input[name="${key}"]`);
		      if (!input) {
		        input = document.createElement('input');
		        input.type = 'hidden';
		        input.name = key;
		        saveForm.appendChild(input);
		      }
		      input.value = value;
	      }
	  });

	  // 새롭게 가공된 menuData 설정
	  document.getElementById('menuData').value = records.join(RS);
	  saveForm.submit();
	}
function append(form, name, value) {
	const input = document.createElement('input');
	input.type = 'hidden';
	input.name = name;
	input.value = value;
	form.appendChild(input);
}

/* 메뉴 등록 팝업 */
function openMenuPopup(groupid) {
	let url = 'menuPopup.jsp';
	if (groupid !== undefined) {
	    url += '?group=' + groupid;	       
	} 	    
	window.open(url, 'menuPopup', 'width=600,height=600');
}
function openMenuPopup(groupid, menu) {
    let url = 'menuPopup.jsp';
    if (groupid !== undefined) {
        url += '?group=' + groupid;
        if(menu !== undefined) {
            url += '&menuId=' + menu.id;
            url += '&menuName=' + menu.name;
            url += '&menuPrice=' + menu.price;
            if(menu.img){url += '&menuImg=' + menu.img;}        
        }
    } 
    
    window.open(url, 'menuPopup', 'width=600,height=600');
}

/* 팝업에서 호출됨 */
function saveMenu(menu) {

  if (!menu || !menu.name) return;
  
  if(menu.id === -1){
	    menu.id = nextMenuId++;
  }

  // 같은 menu-id 가진 기존 메뉴 찾기
  var menuEl = document.querySelector(
    '.menu[data-menu-id="' + menu.id + '"]'
  );

  // =========================
  //  이미 존재 → 수정
  // =========================
  if (menuEl) {

    var nameEl = menuEl.querySelector('.menu-name');
    var priceEl = menuEl.querySelector('.menu-price');
    var imgEl = menuEl.querySelector('.menu-img');

    if (nameEl) nameEl.innerText = menu.name;
    if (priceEl) priceEl.innerText = menu.price + '원';
    if (imgEl && menu.img) imgEl.setAttribute('src', menu.img);

    menuEl.dataset.culture = menu.cultureCategory || '';
    menuEl.dataset.foodTypes = menu.foodTypes || '';//JSON.stringify(menu.foodTypes || []);
    menuEl.dataset.foodItem = menu.foodItems || '';
    
    return;
  }

  // =========================
  //  없으면 → 신규 생성
  // =========================
  var m = document.createElement('div');
  m.className = 'menu';
  m.setAttribute('data-menu-id', menu.id);
  m.dataset.culture = menu.cultureCategory || '';
  m.dataset.foodTypes =  menu.foodTypes || '';//JSON.stringify(menu.foodTypes || []);
  m.dataset.foodItem = menu.foodItems || '';

  m.innerHTML =
    '<div class="drag-handle">≡</div>' +
    '<div class="menu-body" onclick="menuEditAction(' + menu.id + ')">' +
      '<div class="menu-name">' + menu.name + '</div>' +
      '<div class="menu-price">' + menu.price + '원</div>' +
    '</div>' +
    '<img class="menu-img" src="' + menu.img + '">';

  var groupEl = document.querySelector(
    '.group[data-group-id="' + menu.group + '"]'
  );
  if (!groupEl) return;

  groupEl.querySelector('.menu-list').appendChild(m);
}
</script>

</body>
</html>