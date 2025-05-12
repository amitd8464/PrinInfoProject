<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.sql.*" %>
<%
HttpSession s = request.getSession(false);
if (s == null || !"Rep".equals(s.getAttribute("role"))) {
    response.sendRedirect("login.jsp"); return;
}
String entity = request.getParameter("entity");  // aircraft | airport | flight
String action = request.getParameter("action");  // add | edit | delete
String id     = request.getParameter("id");      // primary key
if (entity != null && action != null && id != null) {
  Class.forName("com.mysql.jdbc.Driver");
  try (Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/Project","root","");
       Statement st = con.createStatement()) {

    if ("aircraft".equals(entity)) {
        if ("add".equals(action))
            st.executeUpdate("INSERT INTO Aircraft(aircraft_id,model,num_of_seats) "+
                             "VALUES('"+id+"','UNKNOWN',100)");
        else if ("edit".equals(action))
            st.executeUpdate("UPDATE Aircraft SET num_of_seats=num_of_seats+10 "+
                             "WHERE aircraft_id='"+id+"'");
        else
            st.executeUpdate("DELETE FROM Aircraft WHERE aircraft_id='"+id+"'");
    }
    else if ("airport".equals(entity)) {
        if ("add".equals(action))
            st.executeUpdate("INSERT INTO Airport(airport_id) VALUES('"+id.toUpperCase()+"')");
        else if ("delete".equals(action))
            st.executeUpdate("DELETE FROM Airport WHERE airport_id='"+id.toUpperCase()+"'");
    }
    else if ("flight".equals(entity)) {
        String airline = id.substring(0,2);
        int    num     = Integer.parseInt(id.substring(2));
        if ("add".equals(action)) {
            st.executeUpdate(
              "INSERT INTO Flight VALUES("+num+",'"+airline+"','JFK','LAX','Domestic',"+
              "'2025-12-01 08:00:00','2025-12-01 12:00:00','N123AA')");
            st.executeUpdate("INSERT INTO DomesticFlight VALUES("+num+",'"+airline+"')");
        } else if ("edit".equals(action)) {
            st.executeUpdate(
              "UPDATE Flight SET dep_time = DATE_SUB(dep_time,INTERVAL 15 MINUTE) "+
              "WHERE flight_number="+num+" AND airline_id='"+airline+"'");
        } else {
            st.executeUpdate(
              "DELETE FROM Flight WHERE flight_number="+num+" AND airline_id='"+airline+"'");
        }
    }
    out.println("<p style='color:green;'>Done.</p>");
  } catch (Exception e) {
    out.println("<p style='color:red;'>"+e.getMessage()+"</p>");
  }
}
%>
<form method="post">
  <label>Entity:
    <select name="entity">
      <option value="aircraft">Aircraft</option>
      <option value="airport">Airport</option>
      <option value="flight">Flight</option>
    </select>
  </label>
  <label>Action:
    <select name="action">
      <option value="add">Add</option>
      <option value="edit">Edit</option>
      <option value="delete">Delete</option>
    </select>
  </label>
  <label>ID: <input name="id" required></label>
  <button>Submit</button>
</form>
<a href="representativeDashboard.jsp">← Back</a>