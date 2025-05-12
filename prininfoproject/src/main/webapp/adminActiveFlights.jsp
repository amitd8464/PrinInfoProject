<%@ page import="java.sql.*" %>
<%
HttpSession s=request.getSession(false);
if(s==null||!"Admin".equals(s.getAttribute("role"))){
    response.sendRedirect("login.jsp"); return;
}
Class.forName("com.mysql.jdbc.Driver");
try(Connection con=DriverManager.getConnection(
      "jdbc:mysql://localhost:3306/Project","root","");
    Statement st=con.createStatement();
    ResultSet rs=st.executeQuery(
      "SELECT flight_number,airline_id,COUNT(*) AS sold "+
      "FROM Ticket GROUP BY flight_number,airline_id "+
      "ORDER BY sold DESC LIMIT 3")){
  out.println("<h3>Most Active Flights</h3>");
  int rank=1;
  while(rs.next()){
    out.println(rank++ + ". "+rs.getString(2)+rs.getInt(1)+" → "+rs.getInt(3)+" tickets<br>");
  }
}
%>
<a href="adminDashboard.jsp">← Back</a>