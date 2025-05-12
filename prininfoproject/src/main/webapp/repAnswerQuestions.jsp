<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html><head><title>Rep ▸ Answer Questions</title><link rel="stylesheet" href="css/style.css"/></head><body>
<h1>Customer Questions</h1>
<%
String actQ=request.getParameter("action");
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection c=DriverManager.getConnection(URL,USER,PASS)){
  if("answer".equals(actQ)){
    try(PreparedStatement ps=c.prepareStatement("UPDATE Question SET answer=?, answered=1 WHERE id=?")){
      ps.setString(1,request.getParameter("answer"));
      ps.setInt(2,Integer.parseInt(request.getParameter("id")));
      ps.executeUpdate();
    }
  }
 }}catch(Exception e){out.print("<p style='color:red;'>"+e.getMessage()+"</p>");}
%>
<table border="1" cellpadding="6"><thead><tr><th>ID</th><th>Customer</th><th>Question</th><th>Answer</th></tr></thead><tbody>
<%
try{Class.forName("com.mysql.cj.jdbc.Driver");
 try(Connection c=DriverManager.getConnection(URL,USER,PASS);
     PreparedStatement ps=c.prepareStatement("SELECT id, customer_id, question, answer, answered FROM Question ORDER BY answered, id DESC");
     ResultSet rs=ps.executeQuery()){
  while(rs.next()){ boolean answered=rs.getBoolean("answered"); %>
<tr><td><%=rs.getInt("id")%></td><td><%=rs.getInt("customer_id")%></td><td><%=rs.getString("question")%></td><td>
<% if(answered){ %><%=rs.getString("answer")%><% }else{ %>
<form method="post" style="margin:0;">
 <input type="hidden" name="action" value="answer"/>
 <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>
 <input name="answer" placeholder="Type answer" required/><input type="submit" value="Send"/>
</form>
<% } %>
</td></tr>
<% } }}catch(Exception e){out.print("<tr><td colspan='4' style='color:red;'>"+e.getMessage()+"</td></tr>");}
%>
</tbody></table>
<br/><a href="representativeDashboard.jsp">&larr; Back</a>
</body></html>