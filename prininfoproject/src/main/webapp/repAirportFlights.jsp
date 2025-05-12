<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.sql.*" %>
<%
HttpSession s = request.getSession(false);
if (s == null || !"Rep".equals(s.getAttribute("role"))) {
    response.sendRedirect("login.jsp"); return;
}
String code = request.getParameter("airport");      // 3‑letter code
if (code != null && code.length() == 3) {
  code = code.toUpperCase();
  Class.forName("com.mysql.jdbc.Driver");
  try (Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/Project","root","");
       Statement st = con.createStatement()) {

    ResultSet dep = st.executeQuery(
      "SELECT flight_number,airline_id,dest_airport,dep_time,arr_time "+
      "FROM Flight WHERE dep_airport='"+code+"'");
    out.println("<h3>Departures from "+code+"</h3>");
    out.println("<table border=1><tr><th>Flight</th><th>Destination</th>"+
                "<th>Dep Time</th><th>Arr Time</th></tr>");
    while (dep.next())
      out.println("<tr><td>"+dep.getString(2)+dep.getInt(1)+"</td><td>"+
                  dep.getString(3)+"</td><td>"+dep.getTimestamp(4)+"</td><td>"+
                  dep.getTimestamp(5)+"</td></tr>");
    if (!dep.first()) out.println("<tr><td colspan='4'>No departures.</td></tr>");
    dep.close();

    ResultSet arr = st.executeQuery(
      "SELECT flight_number,airline_id,dep_airport,dep_time,arr_time "+
      "FROM Flight WHERE dest_airport='"+code+"'");
    out.println("</table><h3>Arrivals at "+code+"</h3>");
    out.println("<table border=1><tr><th>Flight</th><th>Origin</th>"+
                "<th>Dep Time</th><th>Arr Time</th></tr>");
    while (arr.next())
      out.println("<tr><td>"+arr.getString(2)+arr.getInt(1)+"</td><td>"+
                  arr.getString(3)+"</td><td>"+arr.getTimestamp(4)+"</td><td>"+
                  arr.getTimestamp(5)+"</td></tr>");
    if (!arr.first()) out.println("<tr><td colspan='4'>No arrivals.</td></tr>");
    out.println("</table>");
    arr.close();
  }
}
%>
<form>
  <label>Airport Code: <input name="airport" maxlength="3" required></label>
  <button>Search</button>
</form>
<a href="representativeDashboard.jsp">← Back</a>