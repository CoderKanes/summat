<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String password = request.getParameter("password");
    boolean success = "1234".equals(password);
%>

{
  "success": <%= success %>
}
