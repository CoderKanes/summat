<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%--
    작성자 : 김용진
    내용 : 작성된 Post의 전체 내용을 볼 수 있는 페이지.
--%>

<jsp:useBean id="dao" class="sm.data.PostDAO" />
<jsp:useBean id="dto" class="sm.data.PostDTO" />
<%

int postNum = -1;
if (request.getParameter("postNum") != null) {
	postNum = Integer.parseInt(request.getParameter("postNum"));
	
} else {
	//잘못된 요청
}

//조회수 컨트롤 by session
boolean addViewCount = false;

Set<Integer> readPosts = (Set<Integer>) session.getAttribute("readPosts"); //세션에서 "이미 읽은 게시글 리스트" 가져오기
if (readPosts == null) {
	readPosts = new HashSet<>();  //리스트가 없으면(첫 방문 시) 새로 생성
}
if (!readPosts.contains(postNum)) { //리스트에 현재 게시글 번호가 들어있는지 확인
	addViewCount = true;// 리스트에 없으면 조회수 증가 	
	
	//리스트에 현재 번호 추가 후 세션에 다시 저장
	readPosts.add(postNum); 
	session.setAttribute("readPosts", readPosts);
}

dto = dao.selectPost(postNum, addViewCount); 



String pageNumParam = request.getParameter("pageNum");

Boolean isAuth = null;
if (session != null) {
	Object authAttr = session.getAttribute("authenticated");
	isAuth = (authAttr instanceof Boolean) ? (Boolean) authAttr : null;
}

String sid= (String)session.getAttribute("sid");
boolean isOwner = sid!=null && sid.equals(dto.getUser_id());



%>

<link href="/summat/resources/css/style.css" rel="stylesheet" />
<link href="/summat/resources/css/post/postEdit.css" rel="stylesheet" />


<style>
.post-view-wrap {
	max-width: 100%;
	margin: 10px auto;
}

.post-view-card {
	width: 95%;
	padding: 32px;
}

.post-title {
	font-size: 26px;
	margin-bottom: 12px;
}

.post-meta {
	font-size: 14px;
	color: #777;
	margin-bottom: 24px;
	display: flex;
	gap: 12px;
}

.post-content {
	min-height: 260px;
	padding: 16px;
	line-height: 1.6;
	white-space: pre-wrap;
	border: 2px solid #eee;
	border-radius: 12px;
	background: #fff;
	word-break: break-word;
  	overflow-wrap: break-word;
}

/* 이미지 */
.post-content img {
	max-width: 100%;
	display: block;
	margin: 12px 0;
}

.post-actions {
	margin-top: 32px;
	display: flex;
	justify-content: flex-end;
	gap: 12px;
}
.post-error {
  max-width: 720px;
  margin: 80px auto;
  padding: 16px;
  color: #555;
  background: #fff;
  border: 2px solid #eee;
  border-radius: 12px;	
}

.post-error h2 {
  font-size: 22px;
  margin-bottom: 12px;
}

.post-error p {
  font-size: 15px;
  line-height: 1.6;
  margin-bottom: 24px;
}

.post-error-link {
  font-size: 14px;
  color: var(--point);
  text-decoration: none;
  font-weight: 600;
}

.post-error-link:hover {
  text-decoration: underline;
}

/* 추천 버튼 영역 */
.post-recommend-section {
    margin: 40px 0;
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
}

.recommend-btn {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: 80px;
    height: 80px;
    border: 2px solid #ddd;
    border-radius: 50%;
    background-color: #fff;
    cursor: pointer;
    transition: all 0.2s ease;
}

.recommend-btn:hover {
    border-color: #ffca28;
    background-color: #fffdf7;
    transform: translateY(-3px);
}

.recommend-btn:active {
    transform: scale(0.95);
}

.recommend-btn .icon {
    font-size: 24px;
    margin-bottom: 2px;
}

.recommend-btn .count {
    font-weight: bold;
    font-size: 16px;
    color: #333;
}

.recommend-label {
    font-size: 14px;
    color: #666;
    font-weight: 500;
}
</style>

<body>
	<jsp:include page="/main/topBar.jsp"></jsp:include>

	<div class="post-view-wrap">

		<%
		if (dto == null) {
		%>

		<div class="post-error">
			<h2>게시글을 찾을 수 없습니다</h2>
			<p>삭제되었거나 존재하지 않는 게시글입니다.</p>

			<a href="postMain.jsp" class="post-error-link"> ← 목록으로 돌아가기 </a>
		</div>

		<%
		} else {
		%>

		<div class="post-view-card">

			<!-- 제목 -->
			<h1 class="post-title"><%=dto.getTitle()%></h1>

			<!-- 메타 정보 -->
			<div class="post-meta">
				<span class="author"><%=dto.getUser_id()%></span> <span class="date"><%=dto.getCreated_at()%></span>
			</div>

			<!-- 내용 (editor 스타일 재사용) -->
			<div class="post-content"><%=dto.getContent()%></div>

			<div class="post-recommend-section">
			    <button type="button" class="recommend-btn" onclick="recommendPost(<%=postNum%>)">
			        <span class="icon">⭐</span>
			        <span class="count" id="recommendCount"><%=dto.getLikeCount()%></span> </button>
			    <span class="recommend-label">추천하기</span>
			</div>
			
			<!-- 하단 액션 -->
			<div class="post-actions">
				<%String AppendPageNumParam = pageNumParam==null?"":"pageNum="+pageNumParam; %>
				<a href="postMain.jsp?<%=AppendPageNumParam%>" class="btn btn-cancel">목록으로</a>
				<%if(isOwner){ %>
				<a href="postModify.jsp?postNum=<%=postNum%>&<%=AppendPageNumParam%>" class="btn btn-outline"
					data-password-check>수정</a>
				<a href="postDeletePro.jsp?postNum=<%=postNum%>&<%=AppendPageNumParam%>" class="btn btn-danger"
					data-password-check>삭제</a>
				<%} %>
				
			</div>		
			
			<jsp:include page="postComment.jsp"></jsp:include>

		</div>

		<%
		}
		%>

	</div>

	<script
		src="<%=request.getContextPath()%>/resources/js/CheckPassword.js"
		defer></script>
</body>

<script>
function recommendPost(postNum) {
    if(!confirm("이 글을 추천하시겠습니까?")) return;
    
 // 추천 처리를 담당할 JSP (또는 서블릿) 호출
    fetch('postRecommendPro.jsp?postNum=' + postNum)
        .then(response => response.json()) // 결과를 JSON으로 받기
        .then(data => {
            if (data.result === "success") {
                alert("추천되었습니다!");
                
                // 화면의 추천수 숫자를 즉시 업데이트 (선택 사항)
                const likeCountEl = document.getElementById("recommendCount");
                if (likeCountEl) {
                    likeCountEl.innerText = data.newLikeCount;
                }
            } else {
                alert(data.message || "이미 추천하셨거나 오류가 발생했습니다.");
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert("서버 통신 중 오류가 발생했습니다.");
        });

}
</script>
