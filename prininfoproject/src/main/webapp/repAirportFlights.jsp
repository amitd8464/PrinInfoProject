<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html><head><title>Rep ▸ Airport Flights</title><link rel="stylesheet" href="css/style.css"/></head><body>
<h1>Airport Flights</h1>
<form method="get">
  Airport Code: <input name="code" maxlength="3" required value="<%=request.getParameter("code")!=null?request.getParameter("code"):""%>"/>
  <input type="submit" value="Search"/>
</form>
<%
String code=request.getParameter("code");
if(code!=null && !code.isEmpty()){
%>
<h2>Flights at <%=code.toUpperCase()%></h2>
<table border="1" cellpadding="6"><thead><tr><th>No</th><th>Origin</th><th>Dest</th><th>Depart</th><th>Arrive</th><th>Status</th></tr></thead><tbody>
<%
 try{Class.forName("com.mysql.cj.jdbc.Driver");
     Connection c=DriverManager.getConnection(URL,USER,PASS);
     PreparedStatement ps=c.prepareStatement("SELECT flight_no, origin, dest, depart_time, arrive_time, status FROM Flight WHERE origin=? OR dest=? ORDER BY depart_time DESC");
     ps.setString(1,code.toUpperCase());
     ps.setString(2,code.toUpperCase());
     ResultSet rs=ps.executeQuery();
     while(rs.next()){ %>
<tr><td><%=rs.getString(1)%></td><td><%=rs.getString(2)%></td><td><%=rs.getString(3)%></td><td><%=rs.getTimestamp(4)%></td><td><%=rs.getTimestamp(5)%></td><td><%=rs.getString(6)%></td></tr>
<% } rs.close(); ps.close(); c.close();
 }catch(Exception e){out.print("<tr><td colspan='6' style='color:red;'>"+e.getMessage()+"</td></tr>");}
%>
</tbody></table>
<% } %>
<br/><a href="representativeDashboard.jsp">&larr; Back</a>
</body></html>