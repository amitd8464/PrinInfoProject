<%@ page import="java.sql.*" %>
<%
HttpSession s=request.getSession(false);
if(s==null||!"Admin".equals(s.getAttribute("role"))){
    response.sendRedirect("login.jsp"); return;
}
String by=request.getParameter("by"), val=request.getParameter("value");
if(by!=null && val!=null){
  Class.forName("com.mysql.jdbc.Driver");
  try(Connection con=DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/Project","root","");
      Statement st=con.createStatement()){
    if("flight".equals(by)){
      int num=Integer.parseInt(val);
      ResultSet rs=st.executeQuery(
        "SELECT T.ticket_number,U.first_name,U.last_name,T.seat_number,"+
        "T.travel_class FROM Ticket T JOIN Reservation R ON T.reservation_id=R.reservation_id "+
        "JOIN Customer C ON R.customer_id=C.user_id JOIN User U ON C.user_id=U.user_id "+
        "WHERE T.flight_number="+num);
      out.println("<h3>Flight "+val+" Tickets</h3>");
      out.println("<table border=1><tr><th>#</th><th>Name</th><th>Seat</th><th>Class</th></tr>");
      while(rs.next()){
        out.println("<tr><td>"+rs.getString(1)+"</td><td>"+
                    rs.getString(2)+" "+rs.getString(3)+"</td><td>"+
                    rs.getString(4)+"</td><td>"+rs.getString(5)+"</td></tr>");
      }
      out.println("</table>"); rs.close();
    } else if("customer".equals(by)){
      ResultSet u=st.executeQuery(
        "SELECT user_id,first_name,last_name FROM User "+
        "WHERE username='"+val+"' OR email='"+val+"'");
      if(u.next()){
        int uid=u.getInt(1);
        String name=u.getString(2)+" "+u.getString(3);
        ResultSet rs=st.executeQuery(
          "SELECT R.reservation_id,T.flight_number,COUNT(*) AS t "+
          "FROM Reservation R JOIN Ticket T ON R.reservation_id=T.reservation_id "+
          "WHERE R.customer_id="+uid+" GROUP BY R.reservation_id");
        out.println("<h3>Reservations for "+name+"</h3>");
        out.println("<table border=1><tr><th>ID</th><th>Flight</th><th>Tickets</th></tr>");
        while(rs.next())
          out.println("<tr><td>"+rs.getInt(1)+"</td><td>"+rs.getInt(2)+"</td><td>"+rs.getInt(3)+"</td></tr>");
        out.println("</table>"); rs.close();
      } else out.println("Customer not found.");
      u.close();
    }
  }
}
%>
<form method="get">
  <select name="by">
    <option value="flight">Flight #</option>
    <option value="customer">Customer</option>
  </select>
  <input name="value" required>
  <button>Search</button>
</form>
<a href="adminDashboard.jsp">← Back</a>