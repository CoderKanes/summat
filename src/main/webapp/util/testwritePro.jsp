<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.io.File"%>
<%@ page import="java.util.Enumeration"%>

<jsp:useBean id="dao" class="sm.data.PostDAO" />
	
<h1>file Pro</h1>

<%
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	%><h4> <%=content%></h4> <%
   
    // DB 저장
    //dao.testInsert(title, content);

    response.sendRedirect("testwriteResult.jsp");
	
%><script>
	alert("d");
</script><%
%>