<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.Timestamp"%>
<%@ page import="java.util.*"%>
<%@ page import="sm.data.PostCommentDTO"%>
<%--
    작성자 : 김용진
    내용 : Post에 달린 댓글을 작성/표시하는 페이지
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

	List<PostCommentDTO> comments = dao.getPostComments(postNum);
    if (comments == null) comments = new ArrayList<>();
    
   
    Boolean isAuth = null;
	if (session != null) {
    	Object authAttr = session.getAttribute("authenticated");
    	isAuth = (authAttr instanceof Boolean) ? (Boolean) authAttr : null;
	}
%>

<style>
.comment-section { max-width: 800px; margin: 20px auto; font-family: sans-serif; }
.comment-count { font-weight: 600; font-size: 20px; margin-bottom: 24px; }

/* 댓글 작성 영역 */
.comment-form { margin-bottom: 32px; }
.comment-write { display: flex; flex-direction: column; gap: 12px; }

/* 비회원 정보 입력 (작성자, 비번) */
.comment-guest { display: flex; gap: 15px; }
.comment-guest .input-group { display: flex; align-items: center; gap: 8px; }
.comment-guest label { font-size: 14px; font-weight: bold; color: #606060; }
.comment-guest input {
  border: none;
  border-bottom: 1px solid #ccc;
  padding: 4px 0;
  width: 120px;
  outline: none;
  transition: border-color 0.2s;
}
.comment-guest input:focus { border-bottom: 2px solid #065fd4; }

/* 댓글 내용 입력 */
.comment-content { display: flex; align-items: flex-end; gap: 12px; }
.comment-content input[name="content"] {
  flex: 1;
  border: none;
  border-bottom: 1px solid #ccc;
  padding: 8px 0;
  outline: none;
  font-size: 14px;
  transition: border-color 0.2s;
}
.comment-content input[name="content"]:focus { border-bottom: 2px solid #065fd4; }
.comment-content input[type="submit"] {
  background: #065fd4;
  color: #fff;
  border: none;
  padding: 8px 16px;
  border-radius: 18px;
  cursor: pointer;
  font-weight: 500;
  font-size: 14px;
}
.comment-content input[type="submit"]:hover { background: #0556bf; }

/* 댓글 리스트 항목 */
.comment { display: flex; gap: 16px; margin-bottom: 24px; }
.avatar {
  width: 40px; height: 40px; border-radius: 50%;
  background: #f0f0f0; flex-shrink: 0;
}
.comment-body { flex: 1; }
.comment-header { display: flex; align-items: center; gap: 8px; margin-bottom: 4px; }
.comment-user { font-size: 13px; font-weight: bold; color: #0f0f0f; }
.comment-date { font-size: 12px; color: #606060; }

.comment-text { font-size: 14px; line-height: 1.5; color: #0f0f0f; margin-bottom: 8px; word-break: break-all; }

/* 액션 버튼 (좋아요/싫어요/답글) */
.comment-actions { display: flex; align-items: center; gap: 16px; }
.comment-actions a {
  text-decoration: none; color: #606060; font-size: 12px;
  display: flex; align-items: center; gap: 4px;
}
.comment-actions a:hover { color: #0f0f0f; }

.comment-menu { cursor: pointer; color: #606060; padding: 0 4px; }
</style>

<div class="comment-section">
  <div class="comment-count">댓글 <%=comments.size()%>개</div>

  <form method="post" action="postCommentPro.jsp" class="comment-form">
    <input type="hidden" name="returnUrl" value="<%=request.getRequestURL() + "?" + request.getQueryString()%>">	
    <input type="hidden" name="postNum" value="<%=postNum%>">
	
    <div class="comment-write">
      <% if(isAuth == null || !isAuth){ %>
      <div class="comment-guest">
        <div class="input-group">
          <label>작성자</label>
          <input type="text" name="guestName" required>
        </div>
        <div class="input-group">
          <label>비밀번호</label>
          <input type="password" name="guestPassword" required>
        </div>
      </div>
      <% } %>
		
      <div class="comment-content">
        <input type="text" name="content" placeholder="댓글 추가..." required>
        <input type="submit" value="댓글">
      </div>
    </div>
  </form>

  <div class="comment-list">
    <% for(PostCommentDTO c : comments){ %>
    <div class="comment">
      <div class="avatar"></div>
      <div class="comment-body">
        <div class="comment-header">
          <span class="comment-user">@<%=c.getWriter()%></span>
          <span class="comment-date"><%=c.getCreated_at()%></span>
        </div>
        <div class="comment-text"><%=c.getContent()%></div>
        <div class="comment-actions">
          <a href="#">👍 <%=c.getLikeCount()%></a>
          <a href="#">👎 <%=c.getDislikeCount()%></a>
          <a href="#">답글</a>
        </div>
      </div>
      <div class="comment-menu">⋮</div>
    </div>
    <% } %>
  </div>
</div>