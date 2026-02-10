<%@page import="sm.data.FileDAO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.File"%>

<%--
    작성자 : 김용진
    내용 : postEdit.js에서의 Image file업로드 요청을 처리하기 위한 페이지.
--%>

<%
	
	FileDAO dao = new FileDAO();
	List<String> CleanupFiles = dao.getCleanupFileList();
	for(String fname : CleanupFiles)
	{
		File f = new File(fname);
		if(!f.delete()) {
		   System.out.println("파일 삭제 실패: " + f.getAbsolutePath());
		}
	}

    // 파일 저장 경로 (실제 경로로 수정 필요)
    String uploadPath = request.getRealPath("resources/upload");	
    int maxSize = 50 * 1024 * 1024; // 50MB 제한
    
    
    
    try {
        MultipartRequest multi = new MultipartRequest(request, uploadPath, maxSize, "UTF-8", new DefaultFileRenamePolicy());
        String fileName = multi.getFilesystemName("uploadFile");
        
        // 클라이언트에게 이미지 접근 URL 반환
        String fileUrl = request.getContextPath() + "/resources/upload/" + fileName;
        
    	dao.uploadTempFile(fileUrl);
        
        out.print("{\"url\": \"" + fileUrl + "\"}");
        
    } catch (Exception e) {
        out.print("{\"error\": \"" + e.getMessage() + "\"}");
    }
%>
