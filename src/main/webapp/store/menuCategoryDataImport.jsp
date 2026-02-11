<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="sm.util.FoodCategoryUtil" %>

<%
	String relativePath = "/resources/csv/FoodCategory.csv";
	String absolutePath = request.getServletContext().getRealPath(relativePath);

	FoodCategoryUtil a = new FoodCategoryUtil();

	//a.loadCsv(absolutePath);
%>