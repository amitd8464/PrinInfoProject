<%@ page import="java.sql.*" %>
<%
HttpSession ses = request.getSession(false);
if (ses == null || !"Admin".equals(ses.getAttribute("role"))) {
    response.sendRedirect("login.jsp"); return;
}
String action = request.getParameter("action");   // add | edit | delete
String key    = request.getParameter("key");      // username/email/id
String role   = request.getParameter("role");     // Customer | Rep
Class.forName("com.mysql.jdbc.Driver");
try (Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/Project","root","");
     Statement  st  = con.createStatement()) {

 if ("add".equals(action)) {
     String email = key;
     String user  = email.split("@")[0];
     st.executeUpdate(
       "INSERT INTO User(first_name,last_name,email,password_hash,role) " +
       "VALUES('New','User','"+email+"','pass','"+role+"')",
       Statement.RETURN_GENERATED_KEYS);
     ResultSet g = st.getGeneratedKeys(); g.next();
     int uid = g.getInt(1); g.close();
     if ("Customer".equals(role))
         st.executeUpdate("INSERT INTO Customer(user_id) VALUES("+uid+")");
     out.println("User "+user+" added as "+role+".");
 }
 else if ("edit".equals(action)) {
     String q = key.matches("\\d+") ?
         "SELECT user_id FROM User WHERE user_id="+key :
         "SELECT user_id FROM User WHERE username='"+key+"' OR email='"+key+"'";
     ResultSet r = st.executeQuery(q);
     if (r.next()) {
         int uid = r.getInt(1);
         st.executeUpdate("UPDATE User SET role='"+role+"' WHERE user_id="+uid);
         if ("Customer".equals(role))
             st.executeUpdate("INSERT IGNORE INTO Customer(user_id) VALUES("+uid+")");
         else
             st.executeUpdate("DELETE FROM Customer WHERE user_id="+uid);
         out.println("User updated.");
     } else out.println("User not found.");
     r.close();
 }
 else if ("delete".equals(action)) {
     int rows = st.executeUpdate(
       key.matches("\\d+") ?
         "DELETE FROM User WHERE user_id="+key :
         "DELETE FROM User WHERE username='"+key+"' OR email='"+key+"'");
     out.println(rows>0 ? "User deleted." : "User not found.");
 }
}
%>
<a href="adminDashboard.jsp">← Back</a>