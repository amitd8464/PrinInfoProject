<%@ page import="java.sql.*" %>
<%
HttpSession ses=request.getSession(false);
if(ses==null||!"Admin".equals(ses.getAttribute("role"))){
   response.sendRedirect("login.jsp"); return;
}
String m=request.getParameter("month");  // YYYY-MM
if(m!=null){
  String[] ym=m.split("-"); String y=ym[0], mo=ym[1];
  Class.forName("com.mysql.jdbc.Driver");
  try(Connection con=DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/Project","root","");
      Statement st=con.createStatement();
      ResultSet rs = st.executeQuery(
        "SELECT SUM(total_fare+booking_fee) AS sales, COUNT(*) AS orders " +
        "FROM Reservation WHERE YEAR(booked_at)="+y+" AND MONTH(booked_at)="+mo)){
    if(rs.next()){
      out.println("<h3>"+m+" Sales</h3>");
      out.println("<p>Orders: "+rs.getInt("orders")+"</p>");
      out.println("<p>Total Revenue: $"+rs.getDouble("sales")+"</p>");
    }
  }
}
%>
<form method="get">
  <label>Month: <input type="month" name="month" required></label>
  <button>Show</button>
</form>
<a href="adminDashboard.jsp">← Back</a>