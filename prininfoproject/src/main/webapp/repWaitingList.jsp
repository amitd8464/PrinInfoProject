<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html><head><title>Rep ▸ Waiting List</title><link rel="stylesheet" href="css/style.css"/></head><body>
<h1>Waiting List</h1>
<%
String actWL=request.getParameter("action");
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection conn=DriverManager.getConnection(URL,USER,PASS)){
  if("add".equals(actWL)){
    try(PreparedStatement ps=conn.prepareStatement("INSERT INTO WaitingList(customer_id,flight_id,request_time) VALUES(?,?,NOW())")){
      ps.setInt(1,Integer.parseInt(request.getParameter("customer_id")));
      ps.setInt(2,Integer.parseInt(request.getParameter("flight_id")));
      ps.executeUpdate();
    }
  }else if("delete".equals(actWL)){
    try(PreparedStatement ps=conn.prepareStatement("DELETE FROM WaitingList WHERE id=?")){
      ps.setInt(1,Integer.parseInt(request.getParameter("id")));
      ps.executeUpdate();
    }
  }
 }
}catch(Exception e){out.print("<p style='color:red;'>"+e.getMessage()+"</p>");}
%>
<table border="1" cellpadding="6"><thead><tr><th>ID</th><th>Customer</th><th>Flight</th><th>Request&nbsp;Time</th><th>Action</th></tr></thead><tbody>
<%
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection conn=DriverManager.getConnection(URL,USER,PASS);
     PreparedStatement ps=conn.prepareStatement("SELECT id, customer_id, flight_id, request_time FROM WaitingList ORDER BY request_time DESC");
     ResultSet rs=ps.executeQuery()){
  while(rs.next()){ %>
<tr><td><%=rs.getInt(1)%></td><td><%=rs.getInt(2)%></td><td><%=rs.getInt(3)%></td><td><%=rs.getTimestamp(4)%></td>
<td><form style="display:inline" method="post"><input type="hidden" name="action" value="delete"/><input type="hidden" name="id" value="<%=rs.getInt(1)%>"/><input type="submit" value="Remove" onclick="return confirm('Remove from waiting list?');"/></form></td></tr>
<% } }}catch(Exception e){out.print("<tr><td colspan='5' style='color:red;'>"+e.getMessage()+"</td></tr>");}
%>
</tbody></table>
<br/>
<h2>Add to Waiting List</h2>
<form method="post"><input type="hidden" name="action" value="add"/>
Customer ID <input type="number" name="customer_id" required /> Flight ID <input type="number" name="flight_id" required />
<input type="submit" value="Add"/></form>
<br/><a href="representativeDashboard.jsp">&larr; Back</a>
</body></html>
