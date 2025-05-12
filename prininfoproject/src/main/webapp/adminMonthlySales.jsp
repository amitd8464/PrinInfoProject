<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html><head>
<title>Admin ▸ Monthly Sales</title>
<link rel="stylesheet" href="css/style.css"/>
</head><body>
<h1>Monthly Sales Summary</h1>
<table border="1" cellpadding="6"><thead><tr><th>Month</th><th>Total Sales (USD)</th><th>Reservations</th></tr></thead><tbody>
<%
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection c=DriverManager.getConnection(URL,USER,PASS);
     PreparedStatement ps=c.prepareStatement(
       "SELECT DATE_FORMAT(res_date,'%Y-%m') m, SUM(price) total, COUNT(*) cnt " +
       "FROM Reservation GROUP BY m ORDER BY m DESC");
     ResultSet rs=ps.executeQuery()){
  while(rs.next()){ %>
<tr><td><%=rs.getString("m")%></td><td><%=rs.getBigDecimal("total")%></td><td><%=rs.getInt("cnt")%></td></tr>
<% } }
}catch(Exception e){out.print("<tr><td colspan='3' style='color:red;'>"+e.getMessage()+"</td></tr>");}
%>
</tbody></table>
<br/><a href="adminDashboard.jsp">&larr; Back</a>
</body></html>
