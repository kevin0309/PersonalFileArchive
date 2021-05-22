<%@page import="framework.jdbc.DBMng"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	DBMng db = new DBMng();
	String res = "";
	try {
		db.setQuery("show tables");
		db.execute();
		while (db.next()) {
			res += db.getString(1)+"<br>";
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		db.close();
	}
%>

<%=res %>
</body>
</html>