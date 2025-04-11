<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession"%>

<%
    // MySQL connection setup:
    Class.forName("com.mysql.jdbc.Driver");
    
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project","root",
    "");
    
    Statement st = con.createStatement();
    ResultSet rs;

    // If the session already exists, you can retrieve attributes by name
    String username = null;
    if (session != null) {
        username = (String) session.getAttribute("user");
    }
    // otherwise, redirect user to login (session expired or somehow no longer exists)
    else{
        response.sendRedirect("login.html");
        return;
    }

    // Fetch parameter "role" from request 
    String role = request.getParameter("role");
    // Fetch parameter "user" from session 
    
    // First, query the user id based on username from current session:
    String query = "SELECT user_id FROM User WHERE username = ?";
    PreparedStatement ps = con.prepareStatement(query);
    ps.setString(1, username);
    rs = ps.executeQuery();
    long userId = -1;
    if (rs.next()) {
        userId = rs.getLong("user_id");
    }
    // user does not exist somehow, redirect to login
    else{
        response.sendRedirect("login.html");
    }

    // Execute update statement and catch any errors
    try {
        String update = "UPDATE User SET role=? WHERE user_id=?";
        PreparedStatement psUpdate = con.prepareStatement(update);
        psUpdate.setString(1, role);
        psUpdate.setLong(2, userId);
        psUpdate.executeUpdate();

        session.setAttribute("role", role);
        response.sendRedirect("success.jsp");
    }
    catch (SQLException e) {
        e.printStackTrace();
        System.out.println("Database error: " + e.getMessage());
    }
%>