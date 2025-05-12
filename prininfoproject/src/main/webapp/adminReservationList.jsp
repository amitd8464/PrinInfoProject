<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html><head>
<title>Admin ▸ Reservation List</title>
<link rel="stylesheet" href="css/style.css"/>
</head><body>
<h1>All Reservations</h1>
<table border="1" cellpadding="6"><thead><tr>
<th>ID</th><th>Customer</th><th>Flight</th><th>Price</th><th>Date</th>
</tr></thead><tbody>
<%
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection c=DriverManager.getConnection(URL,USER,PASS);
     PreparedStatement ps=c.prepareStatement("SELECT id, customer_id, flight_id, price, res_date FROM Reservation ORDER BY id DESC");
     ResultSet rs=ps.executeQuery()){
  while(rs.next()){ %>
<tr><td><%=rs.getInt(1)%></td><td><%=rs.getInt(2)%></td><td><%=rs.getInt(3)%></td><td><%=rs.getBigDecimal(4)%></td><td><%=rs.getDate(5)%></td></tr>
<% } }
}catch(Exception e){out.print("<tr><td colspan='5' style='color:red;'>"+e.getMessage()+"</td></tr>");}
%>
</tbody></table>
<br/><a href="adminDashboard.jsp">&larr; Back</a>
</body></html>