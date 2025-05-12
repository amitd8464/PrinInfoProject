<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html><head>
<title>Admin ▸ Top Customers</title>
<link rel="stylesheet" href="css/style.css"/>
</head><body>
<h1>Top 10 Customers by Spend</h1>
<table border="1" cellpadding="6"><thead><tr><th>Customer ID</th><th>Total Spent (USD)</th></tr></thead><tbody>
<%
try{Class.forName("com.mysql.cj.jdbc.Driver");
 String sql="SELECT customer_id, SUM(price) spent FROM Reservation GROUP BY customer_id ORDER BY spent DESC LIMIT 10";
 try(Connection c=DriverManager.getConnection(URL,USER,PASS);
     PreparedStatement ps=c.prepareStatement(sql);
     ResultSet rs=ps.executeQuery()){
  while(rs.next()){ %>
<tr><td><%=rs.getInt(1)%></td><td><%=rs.getBigDecimal(2)%></td></tr>
<% } }
}catch(Exception e){out.print("<tr><td colspan='2' style='color:red;'>"+e.getMessage()+"</td></tr>");}
%>
</tbody></table>
<br/><a href="adminDashboard.jsp">&larr; Back</a>
</body></html>