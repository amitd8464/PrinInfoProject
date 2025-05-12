<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html><head><title>Rep ▸ Admin Management</title><link rel="stylesheet" href="css/style.css"/></head><body>
<h1>Admin Management</h1>
<%
String act=request.getParameter("action");
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection c=DriverManager.getConnection(URL,USER,PASS)){
  if("add".equals(act)){
    try(PreparedStatement ps=c.prepareStatement("INSERT INTO Admin(username,password) VALUES(?,?)")){
      ps.setString(1,request.getParameter("username"));
      ps.setString(2,request.getParameter("password"));
      ps.executeUpdate();
    }
  }else if("delete".equals(act)){
    try(PreparedStatement ps=c.prepareStatement("DELETE FROM Admin WHERE id=?")){
      ps.setInt(1,Integer.parseInt(request.getParameter("id")));
      ps.executeUpdate();
    }
  }
 }}catch(Exception e){out.print("<p style='color:red;'>"+e.getMessage()+"</p>");}
%>
<table border="1" cellpadding="6"><thead><tr><th>ID</th><th>Username</th><th>Action</th></tr></thead><tbody>
<%
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection c=DriverManager.getConnection(URL,USER,PASS);
     PreparedStatement ps=c.prepareStatement("SELECT id,username FROM Admin ORDER BY id");
     ResultSet rs=ps.executeQuery()){while(rs.next()){ %>
<tr><td><%=rs.getInt(1)%></td><td><%=rs.getString(2)%></td>
<td><form method="post"><input type="hidden" name="action" value="delete"/><input type="hidden" name="id" value="<%=rs.getInt(1)%>"/><input type="submit" value="Delete" onclick="return confirm('Delete admin?');"/></form></td></tr>
<% }}}
catch(Exception e){out.print("<tr><td colspan='3' style='color:red;'>"+e.getMessage()+"</td></tr>");}
%>
</tbody></table>
<br/>
<h2>Add Admin</h2>
<form method="post"><input type="hidden" name="action" value="add"/>
Username <input name="username" required/> Password <input name="password" type="password" required/> <input type="submit" value="Add"/></form>
<br/><a href="representativeDashboard.jsp">&larr; Back</a>
</body></html>