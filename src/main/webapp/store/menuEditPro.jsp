<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>   
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.ArrayList"%>   
<%
System.out.println("Asdf");
for(Map.Entry<String, String[]> a: request.getParameterMap().entrySet())
{	
	for(String v : a.getValue())
	{
		System.out.println(a.getKey()+" -- "+v);
	}
}

class Menu {
	int group;
	int order;
	int id;
	String name;
	int price;
	String img;
}
class Group {
	int id;
	String name;
	int order;
	List<Menu> menus = new ArrayList<>();
}


String data = request.getParameter("menuData");

String RS = "\\|\\|\\|"; // 정규식 escape 주의
String FS = ":::";

Map<Integer, Group> groupMap = new LinkedHashMap<>();

for (String rec : data.split(RS)) {
    String[] c = rec.split(FS, -1);

    if ("G".equals(c[0])) {
        Group g = new Group();
        g.id = Integer.parseInt(c[1]);
        g.order = Integer.parseInt(c[2]);
        g.name = c[3];
        groupMap.put(g.id, g);

    } else if ("M".equals(c[0])) {
        Menu m = new Menu();
        m.group = Integer.parseInt(c[1]);
        m.order = Integer.parseInt(c[2]);
        m.id = Integer.parseInt(c[3]);
        m.name = c[4];
        m.price = Integer.parseInt(c[5]);
        m.img = c[6];

        groupMap.get(m.group).menus.add(m);
    }
}

%>