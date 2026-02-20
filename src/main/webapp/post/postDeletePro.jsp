<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sm.data.FileDAO" %>
<%@ page import="sm.data.PostDTO" %>
<%@ page import="sm.util.HTMLUtil" %>
<%@ page import="java.util.List" %>
    
<%--
    작성자 : 김용진
    내용 : Post삭제 요청을 처리하는 페이지
--%>


<jsp:useBean id="dao" class="sm.data.PostDAO" />
<jsp:useBean id="dto" class="sm.data.PostDTO" />
<jsp:setProperty property="*" name="dto" />
	
<h1>post Delete Pro</h1>

<%
	boolean deleteResult = false;

	boolean authenticated = "true".equals(request.getParameter("checkAuthenticated"));
	int postNum = -1;
	if(authenticated)
	{	
		if(request.getParameter("postNum") !=null){
			postNum = Integer.parseInt(request.getParameter("postNum"));
			
			//첨부 file먼저 UnUsed - 직접 삭제로 할지는 추후 결정.
			FileDAO fdao = new FileDAO();
			PostDTO beforeDTO = dao.selectPost(dto.getPostNum());
			if(beforeDTO !=null){		
				List<String> imageFiles = HTMLUtil.extractAllImgSrc(beforeDTO.getContent());
				for(String fname : imageFiles)
				{
					fdao.updateFileStatus(fname, FileDAO.FileStatus.UNUSED);
				}		
			}
			//post 삭제
			deleteResult = dao.deletePost(postNum);
		}else{
			//잘못된 요청
		}		
	}else{
		%>
			alert("비밀번호 인증에 실패했습니다.");	
			history.go(-1);
		<%
	}
		
	String pageNumParam = request.getParameter("pageNum");
	
	 if(deleteResult == false && postNum != -1){		 
		response.sendRedirect("postView.jsp?postNum="+postNum+"&pageNum="+pageNumParam);
	}else{
		response.sendRedirect("postMain.jsp?pageNum="+pageNumParam);
	}
%>