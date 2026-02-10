<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
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
	dto = dao.selectPost(postNum);
} else {
	//잘못된 요청
}
%>

<link href="/summat/resources/css/style.css" rel="stylesheet" />
<link href="/summat/resources/css/post/postEdit.css" rel="stylesheet" />


<style>
.post-view-wrap {
	max-width: 900px;
	margin: 40px auto;
}

.post-view-card {
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
</style>

<body>
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

			<!-- 하단 액션 -->
			<div class="post-actions">
				<a href="postMain.jsp" class="btn btn-cancel">목록으로</a>

			
				<a href="postModify.jsp?postNum=<%=postNum%>" class="btn btn-outline"
					data-password-check>수정</a>
				<a href="postDeletePro.jsp?postNum=<%=postNum%>" class="btn btn-danger"
					data-password-check>삭제</a>
				
			</div>

		</div>

		<%
		}
		%>

	</div>

	<script
		src="<%=request.getContextPath()%>/resources/js/CheckPassword.js"
		defer></script>
</body>
