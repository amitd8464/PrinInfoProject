<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html><head>
<title>Admin ▸ User Management</title>
<link rel="stylesheet" href="css/style.css"/>
</head><body>
<h1>User Management</h1>
<%
String act=request.getParameter("action");
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection c=DriverManager.getConnection(URL,USER,PASS)){
  if("add".equals(act)){
    try(PreparedStatement ps=c.prepareStatement("INSERT INTO User(username,password,role) VALUES(?,?,?)")){
      ps.setString(1,request.getParameter("username"));
      ps.setString(2,request.getParameter("password"));
      ps.setString(3,request.getParameter("role"));
      ps.executeUpdate();
    }
  }else if("delete".equals(act)){
    try(PreparedStatement ps=c.prepareStatement("DELETE FROM User WHERE id=?")){
      ps.setInt(1,Integer.parseInt(request.getParameter("id")));
      ps.executeUpdate();
    }
  }}
}catch(Exception e){out.print("<p style='color:red;'>"+e.getMessage()+"</p>");}
%>
<table border="1" cellpadding="6"><thead><tr><th>ID</th><th>Username</th><th>Role</th><th>Action</th></tr></thead><tbody>
<%
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection c=DriverManager.getConnection(URL,USER,PASS);
     PreparedStatement ps=c.prepareStatement("SELECT id,username,role FROM User ORDER BY id");
     ResultSet rs=ps.executeQuery()){while(rs.next()){ %>
<tr><td><%=rs.getInt(1)%></td><td><%=rs.getString(2)%></td><td><%=rs.getString(3)%></td>
<td><form method="post"><input type="hidden" name="action" value="delete"/><input type="hidden" name="id" value="<%=rs.getInt(1)%>"/><input type="submit" value="Delete" onclick="return confirm('Delete user?');"/></form></td></tr>
<% }}}
catch(Exception e){out.print("<tr><td colspan='4' style='color:red;'>"+e.getMessage()+"</td></tr>");}
%>
</tbody></table>
<br/>
<h2>Add User</h2>
<form method="post"><input type="hidden" name="action" value="add"/>
Username <input name="username" required/> Password <input name="password" required type="password"/> Role <select name="role"><option>ADMIN</option><option>REP</option><option>CUSTOMER</option></select>
<input type="submit" value="Add"/></form>
<br/><a href="adminDashboard.jsp">&larr; Back</a>
</body></html>