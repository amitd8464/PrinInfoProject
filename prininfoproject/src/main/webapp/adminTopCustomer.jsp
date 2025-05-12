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
      "SELECT U.username,SUM(R.total_fare+R.booking_fee) AS spent "+
      "FROM Reservation R JOIN Customer C ON R.customer_id=C.user_id "+
      "JOIN User U ON C.user_id=U.user_id "+
      "GROUP BY R.customer_id ORDER BY spent DESC LIMIT 1")){
  if(rs.next()){
    out.println("<h3>Top Customer</h3>");
    out.println("<p>"+rs.getString(1)+" spent $"+rs.getDouble(2)+"</p>");
  } else out.println("No data.");
}
%>
<a href="adminDashboard.jsp">← Back</a>