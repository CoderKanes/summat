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
	String contextPath = request.getContextPath(); 
	for(String fileUrl  : CleanupFiles)
	{
		String relativePath = fileUrl.substring(contextPath.length());
		String realPath = request.getServletContext().getRealPath(relativePath); 
		if (realPath != null) {
			File f = new File(realPath);
		    if(f.exists() && f.delete()) {
                System.out.println("파일 삭제 성공: " + realPath);
            } else {
                System.out.println("파일 삭제 실패 (존재하지 않거나 권한 부족): " + realPath);
            }
		}
	}

    int maxSize = 50 * 1024 * 1024; // 50MB 제한

    // 파일 저장 경로 (실제 경로로 수정 필요)
    String uploadPath = request.getRealPath("resources/upload");	
    File uploadDir = new File(uploadPath);
    // 폴더 없으면 생성
    if (!uploadDir.exists()) {
        if (uploadDir.mkdirs()) {
            System.out.println("업로드 폴더 생성됨: " + uploadPath);
        } else {
            System.out.println("업로드 폴더 생성 실패");
            response.setContentType("application/json; charset=UTF-8");
            out.print("{\"error\":\"폴더 생성 실패\"}");
            return;
        }
    }
    
    
    try {
        MultipartRequest multi = new MultipartRequest(request, uploadPath, maxSize, "UTF-8", new DefaultFileRenamePolicy());
        String fileName = multi.getFilesystemName("uploadFile");
        
        if (fileName != null && !fileName.isEmpty()) {
            String fileUrl = request.getContextPath() + "/resources/upload/" + fileName;
            dao.uploadTempFile(fileUrl);
            
            // JSON 이스케이프 처리
            String safeUrl = fileUrl.replace("\\", "\\\\").replace("\"", "\\\"");
            out.print("{\"url\":\"" + safeUrl + "\"}");
        } else {
            out.print("{\"error\":\"파일명 없음\"}");
        }
        
    } catch (Exception e) {
        // 에러 메시지 안전화 (모든 특수문자 이스케이프)
        String safeError = e.getMessage()
            .replace("\\", "\\\\")    // 백슬래시 먼저 처리
            .replace("\"", "\\\"")    // 큰따옴표
            .replace("\r", "\\r")     // 캐리지 리턴
            .replace("\n", "\\n");    // 줄바꿈
        out.print("{\"error\":\"" + safeError + "\"}");
    }
%>
