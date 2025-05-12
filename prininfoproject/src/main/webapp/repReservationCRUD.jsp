<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html><head><title>Rep ▸ Reservation Management</title><link rel="stylesheet" href="css/style.css"/></head><body>
<h1>Reservation Management</h1>
<%
String action=request.getParameter("action");
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection conn=DriverManager.getConnection(URL,USER,PASS)){
  if("add".equals(action)){
    try(PreparedStatement ps=conn.prepareStatement("INSERT INTO Reservation(customer_id,flight_id,price,res_date) VALUES(?,?,?,?)")){
      ps.setInt(1,Integer.parseInt(request.getParameter("customer_id")));
      ps.setInt(2,Integer.parseInt(request.getParameter("flight_id")));
      ps.setBigDecimal(3,new java.math.BigDecimal(request.getParameter("price")));
      ps.setDate(4,java.sql.Date.valueOf(request.getParameter("res_date")));
      ps.executeUpdate();
    }
  }else if("delete".equals(action)){
    try(PreparedStatement ps=conn.prepareStatement("DELETE FROM Reservation WHERE id=?")){
      ps.setInt(1,Integer.parseInt(request.getParameter("id")));
      ps.executeUpdate();
    }
  }
 }
}catch(Exception e){out.print("<p style='color:red;'>"+e.getMessage()+"</p>");}
%>
<table border="1" cellpadding="6"><thead><tr><th>ID</th><th>Customer</th><th>Flight</th><th>Price</th><th>Date</th><th>Action</th></tr></thead><tbody>
<%
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection conn=DriverManager.getConnection(URL,USER,PASS);
     PreparedStatement ps=conn.prepareStatement("SELECT id, customer_id, flight_id, price, res_date FROM Reservation ORDER BY id DESC");
     ResultSet rs=ps.executeQuery()){
  while(rs.next()){ %>
<tr><td><%=rs.getInt(1)%></td><td><%=rs.getInt(2)%></td><td><%=rs.getInt(3)%></td><td><%=rs.getBigDecimal(4)%></td><td><%=rs.getDate(5)%></td>
<td><form style="display:inline" method="post"><input type="hidden" name="action" value="delete"/><input type="hidden" name="id" value="<%=rs.getInt(1)%>"/><input type="submit" value="Delete" onclick="return confirm('Delete this reservation?');"/></form></td></tr>
<% } }}catch(Exception e){out.print("<tr><td colspan='6' style='color:red;'>"+e.getMessage()+"</td></tr>");}
%>
</tbody></table>
<br/>
<h2>Add Reservation</h2>
<form method="post"><input type="hidden" name="action" value="add"/>
Customer ID <input type="number" name="customer_id" required /> Flight ID <input type="number" name="flight_id" required /> Price <input name="price" required /> Date <input type="date" name="res_date" required />
<input type="submit" value="Add"/></form>
<br/><a href="representativeDashboard.jsp">&larr; Back</a>
</body></html>