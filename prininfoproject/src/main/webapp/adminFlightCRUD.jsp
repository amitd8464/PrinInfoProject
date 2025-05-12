<%@ page import="java.sql.*" %>
<%
HttpSession ses = request.getSession(false);
if (ses == null || !"Admin".equals(ses.getAttribute("role"))) {
    response.sendRedirect("login.jsp"); return;
}
String action = request.getParameter("action");   // add | edit | delete
String id     = request.getParameter("id");       // e.g. AA1001
Class.forName("com.mysql.jdbc.Driver");
try (Connection c = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/Project","root","")) {
    Statement st = c.createStatement();
    if ("add".equals(action)) {
        String airline = id.substring(0,2);
        int    num     = Integer.parseInt(id.substring(2));
        st.executeUpdate(
          "INSERT INTO Flight VALUES ("+num+",'"+airline+
          "','JFK','LAX','Domestic','2025-12-01 10:00:00'," +
          "'2025-12-01 14:00:00','N123AA')");
        st.executeUpdate(
          "INSERT INTO DomesticFlight VALUES ("+num+",'"+airline+"')");
        out.println("Flight "+id+" added.");
    } else if ("edit".equals(action)) {
        String a = id.substring(0,2); int n = Integer.parseInt(id.substring(2));
        int rows = st.executeUpdate(
          "UPDATE Flight SET dep_time = DATE_ADD(dep_time,INTERVAL 1 HOUR) " +
          "WHERE flight_number="+n+" AND airline_id='"+a+"'");
        out.println(rows>0 ? "Flight updated." : "Flight not found.");
    } else if ("delete".equals(action)) {
        String a = id.substring(0,2); int n = Integer.parseInt(id.substring(2));
        st.executeUpdate("DELETE FROM Flight WHERE flight_number="+n+
                         " AND airline_id='"+a+"'");
        out.println("Flight "+id+" deleted.");
    }
}
%>
<a href="adminDashboard.jsp">← Back</a>