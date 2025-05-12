<%@ page import="java.sql.*" %>
<%
HttpSession s=request.getSession(false);
if(s==null||!"Admin".equals(s.getAttribute("role"))){
    response.sendRedirect("login.jsp"); return;
}
String g=request.getParameter("group");  // flight | airline | customer
if(g!=null){
  Class.forName("com.mysql.jdbc.Driver");
  try(Connection con=DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/Project","root","");
      Statement st=con.createStatement()){
    out.println("<h3>Revenue by "+g+"</h3>");
    ResultSet rs=null;
    if("flight".equals(g)){
      rs=st.executeQuery(
        "SELECT flight_number,airline_id,COUNT(*) AS sold "+
        "FROM Ticket GROUP BY flight_number,airline_id ORDER BY sold DESC");
      out.println("<table border=1><tr><th>Flight</th><th>Tickets</th></tr>");
      while(rs.next())
        out.println("<tr><td>"+rs.getString(2)+rs.getInt(1)+"</td><td>"+rs.getInt(3)+"</td></tr>");
    }else if("airline".equals(g)){
      rs=st.executeQuery("SELECT airline_id,COUNT(*) AS sold FROM Ticket GROUP BY airline_id");
      out.println("<table border=1><tr><th>Airline</th><th>Tickets</th></tr>");
      while(rs.next())
        out.println("<tr><td>"+rs.getString(1)+"</td><td>"+rs.getInt(2)+"</td></tr>");
    }else if("customer".equals(g)){
      rs=st.executeQuery(
        "SELECT U.username,SUM(R.total_fare+R.booking_fee) AS spent "+
        "FROM Reservation R JOIN Customer C ON R.customer_id=C.user_id "+
        "JOIN User U ON C.user_id=U.user_id "+
        "GROUP BY R.customer_id ORDER BY spent DESC");
      out.println("<table border=1><tr><th>Customer</th><th>Spent</th></tr>");
      while(rs.next())
        out.println("<tr><td>"+rs.getString(1)+"</td><td>$"+rs.getDouble(2)+"</td></tr>");
    }
    out.println("</table>"); if(rs!=null)rs.close();
  }
}
%>
<form method="get">
  <select name="group">
    <option value="flight">Flight</option>
    <option value="airline">Airline</option>
    <option value="customer">Customer</option>
  </select>
  <button>Show</button>
</form>
<a href="adminDashboard.jsp">← Back</a>