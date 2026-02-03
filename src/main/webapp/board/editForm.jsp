<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.BoardDAO, sm.data.BoardDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 1. 파라미터로 전달된 글 번호 가져오기
    String idParam = request.getParameter("id");
    if(idParam == null || idParam.isEmpty()){
        out.println("수정할 글을 선택해주세요.");
        return;
    }
    int id = Integer.parseInt(idParam);

    // 2. DAO에서 글 정보 가져오기
    BoardDAO dao = new BoardDAO();
    BoardDTO post = dao.getPost(id); // 글 한 개 가져오기

    if(post == null){
        out.println("글 정보를 가져올 수 없습니다.");
        return;
    }
%>

<h2>게시글 수정</h2>
<form action="editPro.jsp" method="post">
    <!-- 글 번호 숨김 -->
    <input type="hidden" name="id" value="<%=post.getId()%>">

    <label>제목:</label><br>
    <input type="text" name="title" value="<%=post.getTitle()%>" size="60"><br><br>

    <label>내용:</label><br>
    <textarea name="content" rows="10" cols="60"><%=post.getContent()%></textarea><br><br>

    <label>작성자:</label> <%=post.getWriter()%><br>
	<%=new SimpleDateFormat("yyyy-MM-dd HH:mm").format(post.getRegDate())%>
	
    <input type="submit" value="수정하기">
    <input type="button" value="목록으로" onclick="location.href='list.jsp'">
</form>
