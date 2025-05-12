<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin ▸ Active Flights</title>
    <link rel="stylesheet" href="css/style.css" />
</head>
<body>
<h1>Active Flights</h1>
<table border="1" cellpadding="6">
  <thead>
    <tr><th>No</th><th>Origin</th><th>Destination</th><th>Depart</th><th>Arrive</th><th>Status</th></tr>
  </thead>
  <tbody>
<%
final String URL  = "jdbc:mysql://localhost:3306/prinInfo_project?useSSL=false&serverTimezone=UTC";
final String USER = "root";
final String PASS = "";
try {
  Class.forName("com.mysql.cj.jdbc.Driver");
  try(Connection c=DriverManager.getConnection(URL,USER,PASS);
      PreparedStatement ps=c.prepareStatement("SELECT flight_no, origin, dest, depart_time, arrive_time, status FROM Flight WHERE depart_time>NOW() ORDER BY depart_time");
      ResultSet rs=ps.executeQuery()){
    while(rs.next()){
%>
<tr>
 <td><%=rs.getString(1)%></td>
 <td><%=rs.getString(2)%></td>
 <td><%=rs.getString(3)%></td>
 <td><%=rs.getTimestamp(4)%></td>
 <td><%=rs.getTimestamp(5)%></td>
 <td><%=rs.getString(6)%></td>
</tr>
<%
    }
  }
}catch(Exception e){out.print("<tr><td colspan='6' style='color:red;'>"+e.getMessage()+"</td></tr>");}
%>
  </tbody>
</table>
<br/><a href="adminDashboard.jsp">&larr; Back</a>
</body></html>