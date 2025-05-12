<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.sql.*" %>
<%
HttpSession s = request.getSession(false);
if (s == null || !"Rep".equals(s.getAttribute("role"))) {
    response.sendRedirect("login.jsp"); return;
}
String f = request.getParameter("flight");          // flight number
if (f != null) {
  Class.forName("com.mysql.jdbc.Driver");
  try (Connection c = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/Project","root","");
       Statement st = c.createStatement();
       ResultSet rs = st.executeQuery(
         "SELECT U.username,W.request_time "+
         "FROM WaitingList W JOIN Customer C ON W.customer_id=C.user_id "+
         "JOIN User U ON C.user_id=U.user_id "+
         "WHERE W.flight_number="+Integer.parseInt(f)+" ORDER BY W.request_time")) {
    out.println("<h3>Waiting List – Flight "+f+"</h3>");
    out.println("<table border=1><tr><th>User</th><th>Request Time</th></tr>");
    boolean empty = true;
    while (rs.next()) {
        empty = false;
        out.println("<tr><td>"+rs.getString(1)+"</td><td>"+rs.getTimestamp(2)+"</td></tr>");
    }
    if (empty) out.println("<tr><td colspan='2'>No entries.</td></tr>");
    out.println("</table>");
  }
}
%>
<form>
  <label>Flight #: <input name="flight" required></label>
  <button>Show</button>
</form>
<a href="representativeDashboard.jsp">← Back</a>