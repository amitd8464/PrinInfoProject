<%@ page import ="java.sql.*" %>

<%
    // MySQL connection setup:
    Class.forName("com.mysql.jdbc.Driver");
    
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project","root",
    "");
    
    Statement st = con.createStatement();
    ResultSet rs;

    // Fetch parameters from request
    String email = request.getParameter("email");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    String firstname = request.getParameter("firstname");
    String lastname = request.getParameter("lastname");

    // Execute update statement and catch any errors
    try {
        String sql = "INSERT INTO User (email, username, password, first_name, last_name) "
           + "VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ps.setString(2, username);
        ps.setString(3, password);
        ps.setString(4, firstname);
        ps.setString(5, lastname);

        ps.executeUpdate();

        session.setAttribute("user", username);
        response.sendRedirect("chooseRole.html");
    }
    catch (SQLException e) {
        e.printStackTrace();
        System.out.println("Database error: " + e.getMessage());

        if (e.getErrorCode() == 1062) {
            
        out.println("<script>");
        out.println("alert('This username or email is already in use.');");
        out.println("window.location.href = 'register.html';");
        out.println("</script>");

    } else {
        // Handle other SQL errors similarly, or forward with a generic error message
        out.println("<script>");
        out.println("alert('Database error occurred.');");
        out.println("window.location.href = 'register.html';");
        out.println("</script>");
        /*
        This will be used when register.html -> register.jsp
        request.setAttribute("errorMsg", "Database error: " + e.getMessage());
        request.getRequestDispatcher("register.html").forward(request, response);
        */
    }
    }
%>