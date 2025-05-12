<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html><head>
<title>Admin ▸ Revenue Summary</title>
<link rel="stylesheet" href="css/style.css"/>
</head><body>
<h1>Revenue by Route</h1>
<table border="1" cellpadding="6"><thead><tr><th>Origin</th><th>Destination</th><th>Revenue (USD)</th></tr></thead><tbody>
<%
try{Class.forName("com.mysql.cj.jdbc.Driver");
 String sql="SELECT f.origin, f.dest, SUM(r.price) revenue " +
            "FROM Flight f JOIN Reservation r ON r.flight_id=f.id " +
            "GROUP BY f.origin, f.dest ORDER BY revenue DESC";
 try(Connection c=DriverManager.getConnection(URL,USER,PASS);
     PreparedStatement ps=c.prepareStatement(sql);
     ResultSet rs=ps.executeQuery()){
  while(rs.next()){ %>
<tr><td><%=rs.getString(1)%></td><td><%=rs.getString(2)%></td><td><%=rs.getBigDecimal(3)%></td></tr>
<% } }
}catch(Exception e){out.print("<tr><td colspan='3' style='color:red;'>"+e.getMessage()+"</td></tr>");}
%>
</tbody></table>
<br/><a href="adminDashboard.jsp">&larr; Back</a>
</body></html>