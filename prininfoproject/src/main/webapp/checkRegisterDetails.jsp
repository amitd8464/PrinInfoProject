<%@ page import="java.sql.*" %>

<%
    Connection con = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");

        String sql = "INSERT INTO Users (email, username, password, first_name, last_name) VALUES (?, ?, ?, ?, ?)";
        ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ps.setString(2, username);
        ps.setString(3, password);
        ps.setString(4, firstname);
        ps.setString(5, lastname);

        ps.executeUpdate();

        String user_id_query = "SELECT user_id FROM Users WHERE username=?";
        ps = con.prepareStatement(user_id_query);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("user", rs.getInt("user_id"));
            response.sendRedirect("chooseRole.jsp");
        } else {
            // Handle error: user not found
            out.println("User registration failed. Please try again.");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        if (e.getErrorCode() == 1062) {
%>
            <script>
            alert('This username or email is already in use.');
            window.location.href = 'register.jsp';
            </script>
<%
        } else {
%>
            <script>
            alert('Database error occurred.');
            window.location.href = 'register.jsp';
            </script>
<%
        }
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
%>
        <script>
        alert('JDBC Driver not found.');
        window.location.href = 'register.jsp';
        </script>
<%
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (con != null) con.close(); } catch (Exception ignored) {}
    }
%>
