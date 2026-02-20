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
    
    int totalCommentCount = dao.getPostCommentCount(postNum);
    
   
    Boolean isAuth = null;
	if (session != null) {
    	Object authAttr = session.getAttribute("authenticated");
    	isAuth = (authAttr instanceof Boolean) ? (Boolean) authAttr : null;
	}
	
	String sid= (String)session.getAttribute("sid");
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
.comment { display: flex; gap: 16px; margin-bottom: 24px; position: relative;}
.avatar {
  max-width: 40px; max-height: 40px; border-radius: 50%;
  background: #f0f0f0; flex-shrink: 0;
}
.comment-body { flex: 1; }
.comment-header { display: flex; align-items: center; gap: 8px; margin-bottom: 4px; }
.comment-user { font-size: 13px; font-weight: bold; color: #0f0f0f; }
.comment-date { font-size: 12px; color: #606060; }

.comment-text { font-size: 14px; line-height: 1.5; color: #0f0f0f; margin-bottom: 8px; word-break: break-all; }

/* 액션 버튼 (좋아요/싫어요/답글) */
.comment-actions { display: flex; align-items: center; gap: 16px; width: 100%; }
.comment-actions a {
  text-decoration: none; color: #606060; font-size: 12px;
  display: flex; align-items: center; gap: 4px;
}
.comment-actions a:hover { color: #0f0f0f; }
.

.comment-menu { cursor: pointer; color: #606060; padding: 0 4px; }

.comment-menu {
  cursor: pointer;
  color: #606060;
  padding: 0 6px;
  font-size: 18px;
  line-height: 1;
  user-select: none;
}

.comment-menu:hover {
  color: #0f0f0f;
}
.comment-dropdown {
  position: absolute;
  top: 28px;
  right: 0;
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  min-width: 80px;
  display: none;
  z-index: 20;
  overflow: hidden;
}

.comment-dropdown div {
  padding: 8px 12px;
  font-size: 13px;
  color: #0f0f0f;
  cursor: pointer;
}

.comment-dropdown div:hover {
  background: #f2f2f2;
}

.reply {
  margin-left: 5px;
  padding-left: 5px;
  border-left: 2px solid #eee;
}
.reply-form {
  margin-top: 12px;
  margin-left: 56px; /* 아바타 + 여백 기준 들여쓰기 */
  display: flex;
  flex-direction: column;
  gap: 8px;
}

/* 이름 / 비번 */
.reply-guest {
  display: flex;
  gap: 8px;
}

.reply-guest input {
  width: 140px;
  border: none;
  border-bottom: 1px solid #ccc;
  padding: 4px 0;
  font-size: 13px;
  outline: none;
}

.reply-guest input:focus {
  border-bottom: 2px solid #065fd4;
}

/* 답글 입력 + 버튼 */
.reply-input-row {
  display: flex;
  gap: 8px;
  align-items: center;
}

.reply-input {
  flex: 1;
  border: none;
  border-bottom: 1px solid #ccc;
  padding: 6px 0;
  font-size: 13px;
  outline: none;
}

.reply-input:focus {
  border-bottom: 2px solid #065fd4;
}

.reply-input-row button {
  background: #065fd4;
  color: #fff;
  border: none;
  padding: 6px 14px;
  border-radius: 16px;
  font-size: 12px;
  cursor: pointer;
}

.reply-input-row button:hover {
  background: #0556bf;
}
.reply-list {
  display: block; 
  margin-top: 12px;
  padding-left: 12px;
  border-left: 2px solid #eee;
}

/* 개별 답글 */
.reply-item {
  margin-bottom: 10px;
}

/* 답글 헤더 */
.reply-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
}

.reply-user {
  font-weight: 600;
  color: #0f0f0f;
}

.reply-date {
  font-size: 12px;
  color: #777;
}

/* 답글 내용 */
.reply-text {
  font-size: 14px;
  margin-top: 2px;
  line-height: 1.4;
}
</style>

<div class="comment-section">
  <div class="comment-count">댓글 <%=totalCommentCount%>개</div>

  <form method="post" action="postCommentPro.jsp" class="comment-form">
    <input type="hidden" name="returnUrl" value="<%=request.getRequestURL() + "?" + request.getQueryString()%>">	
    <input type="hidden" name="postNum" value="<%=postNum%>">
	
    <div class="comment-write">
      <%if(isAuth == null || !isAuth){ %>
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
      <%}else{ %>
       <input type="hidden" name="user_id" value="<%=sid%>">
      <%}%>
		
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
		  <a href="javascript:void(0)" onclick="commentLike(<%=c.getId()%>, 1, this)"> 👍 <span><%=c.getLikes()%></span>
		  </a> <a href="javascript:void(0)" onclick="commentLike(<%=c.getId()%>, -1, this)"> 👎 <span><%=c.getDislikes()%></span>
		  </a> <a href="javascript:void(0)"  onclick="toggleReplyForm(this)">답글</a>  
        </div>
                <div class="reply-form" style="display:none;">
		    <%if(isAuth == null || !isAuth){ %>
		    <div class="reply-guest">
			  <input type="text" class="reply-guest-name" placeholder="이름">
			  <input type="password" class="reply-guest-pw" placeholder="비밀번호">
			</div>
			<%}%>
			<div class="reply-input-row">
			  <input type="text" class="reply-input" placeholder="답글 입력">
			  <button onclick="submitReply(this, <%=c.getId()%>)">등록</button>
			</div>
		  </div>
		   <div class="reply-list">
		          <% 
			        List<PostCommentDTO> replies = c.getReplies();
			        if (replies != null) {
			          for (PostCommentDTO r : replies) {
			      %>
			
			      <div class="comment reply">
			        <div class="avatar small"></div>
			        <div class="comment-body">
			          <div class="comment-header">
			            <span class="comment-user">			             
			                @<%=r.getWriter()%>			             
			            </span>
			            <span class="comment-date"><%=r.getCreated_at()%></span>
			          </div>
			          <div class="comment-text"><%=r.getContent()%></div>
			        </div>
			      </div>

      <% } } %>
		  </div>
      </div>
      <%
		boolean showMenu = false;
        boolean isGuest= c.getUser_Id() == null && c.getGuestName() != null;
		if(isGuest)	{showMenu = true;} //게스트 글은 무조건 보임.
		else if (sid != null && c.getUser_Id() != null && sid.equals(c.getUser_Id())) { showMenu = true; } //회원글은 본인이 작성자일때만 보임.
	  %>
	  <% if (showMenu) { %>
      <div class="comment-menu" onclick="toggleCommentMenu(this)">⋮</div>
      <div class="comment-dropdown">
        <div onclick="editComment(this,<%=c.getId()%>, <%=isGuest%>)">수정</div>
        <div onclick="deleteComment(this,<%=c.getId()%>, <%=isGuest%>)">삭제</div>
   	  </div>
   	  <% } %>
    </div>
    <% } %>
  </div>
</div>

<script>
let ref_postNum = <%=postNum%>;
let ref_isAuth =<%=isAuth%>;
let ref_sid ='<%=sid%>';

function toggleCommentMenu(btn) {

  // 다른 열린 메뉴 닫기
  document.querySelectorAll('.comment-dropdown').forEach(menu => {
    if (menu !== btn.nextElementSibling) {
      menu.style.display = 'none';
    }
  });

  const dropdown = btn.nextElementSibling;
  dropdown.style.display =
    dropdown.style.display === 'block' ? 'none' : 'block';
}

// 바깥 클릭 시 닫기
document.addEventListener('click', e => {
  if (!e.target.closest('.comment-menu')) {
    document.querySelectorAll('.comment-dropdown')
      .forEach(menu => menu.style.display = 'none');
  }
});

function editComment(el, commentId, isGuest) {
	 const comment = el.closest('.comment');
	  const textEl = comment.querySelector('.comment-text');
	  const oldText = textEl.innerText;

	  const newText = prompt('댓글 수정', oldText);
	  if (newText === null) return;

	  if (!newText.trim()) {
	    alert('내용을 입력하세요');
	    return;
	  }

	  let body =
	    'id=' + encodeURIComponent(commentId) +
	    '&content=' + encodeURIComponent(newText);

	  if (isGuest) {
	    const pw = prompt('비밀번호를 입력하세요');
	    if (!pw) return;
	    body += '&pw=' + encodeURIComponent(pw);
	  }

	  fetch('postCommentUpdatePro.jsp', {
	    method: 'POST',
	    headers: {
	      'Content-Type': 'application/x-www-form-urlencoded'
	    },
	    body: body
	  })
	  .then(res => res.text())
	  .then(result => {
	    result = result.trim();

	    if (result === 'OK') {
	      textEl.innerText = newText; 
	      alert('수정되었습니다.');
	    } else if (result === 'PW_FAIL') {
	      alert('비밀번호가 틀렸습니다');
	    } else if (result === 'DENY') {
	      alert('수정 권한이 없습니다');
	    } else {
	      alert('수정 실패');
	    }
	  });
}

function deleteComment(el, commentId, isGuest) {

  if (!confirm('댓글을 삭제할까요?')) return;
  
  let body = 'id=' + encodeURIComponent(commentId);
  if (isGuest) {
	const pw = prompt('비밀번호를 입력하세요');
	if (!pw) return;
	body += '&pw=' + encodeURIComponent(pw);
  }	

  fetch('postCommentDeletePro.jsp', {
	    method: 'POST',
	    headers: {
	      'Content-Type': 'application/x-www-form-urlencoded'
	    },
	    body: body
	  })
	  .then(res => res.text())
	  .then(result => {
		result = result.trim();		  
	    if (result === 'OK') {
	      el.closest('.comment').remove(); 
	      alert('삭제되었습니다.');
	    } else if (result === 'PW_FAIL') {
	      alert('비밀번호가 틀렸습니다');
	    } else if (result === 'DENY') {
	      alert('삭제 권한이 없습니다');
	    } else {
	      alert('삭제 실패');
	    }
	  });
}

function commentLike(commentId, type, el) {
	if(ref_isAuth==null || ref_sid == 'null')
	{
		alert('좋아요/싫어요는 로그인 하셔야합니다.');
		return;
	}
	
	  fetch('postCommentLikePro.jsp', {
	    method: 'POST',
	    headers: {
	      'Content-Type': 'application/x-www-form-urlencoded'
	    },
	    body:
	      'id=' + commentId +
	      '&type=' + type
	  })
	  .then(res => res.text())
	  .then(result => {
	    result = result.trim();

	    if (result === 'OK') {
	      //const countSpan = el.querySelector('span');
	      //countSpan.innerText = parseInt(countSpan.innerText) + 1;
	    	 location.reload();
	    } else if (result === 'DUP') {
	      alert('이미 눌렀습니다');
	    } else {
	      alert('처리 실패');
	    }
	  });
	}

function toggleReplyForm(el) {
	  const comment = el.closest('.comment');
	  const form = comment.querySelector('.reply-form');
	  form.style.display = form.style.display === 'block' ? 'none' : 'block';
}

function submitReply(btn, parentId) {

	  const form = btn.closest('.reply-form');
	  const content = form.querySelector('.reply-input').value.trim();
	  if (!content) return;

	  let body =
	    'parentId=' + encodeURIComponent(parentId) +
	    '&postNum=' + encodeURIComponent(ref_postNum) +
	    '&content=' + encodeURIComponent(content);

	  // 🔹 게스트 정보가 있으면 같이 보냄
	  const guestNameEl = form.querySelector('.reply-guest-name');
	  const guestPwEl = form.querySelector('.reply-guest-pw');

	  if (guestNameEl && guestPwEl) {
	    const guestName = guestNameEl.value.trim();
	    const guestPw = guestPwEl.value;

	    if (!guestName || !guestPw) {
	      alert('이름과 비밀번호를 입력하세요');
	      return;
	    }

	    body +=
	      '&guestName=' + encodeURIComponent(guestName) +
	      '&guestPassword=' + encodeURIComponent(guestPw);
	  }

	  fetch('postCommentReplyPro.jsp', {
	    method: 'POST',
	    headers: {
	      'Content-Type': 'application/x-www-form-urlencoded'
	    },
	    body: body
	  })
	  .then(res => res.text())
	  .then(result => {
	    result = result.trim();
	    if (result === 'OK') {
	      location.reload(); // or 동적 append
	    } else {
	      alert('답글 실패');
	    }
	  });
}
</script>