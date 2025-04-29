<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession"%>

<%
    Connection con = null;
    PreparedStatement ps = null;
    PreparedStatement psUpdate = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

        String username = null;
        if (session != null) {
            username = (String) session.getAttribute("user");
        } else {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = request.getParameter("role");

        String query = "SELECT user_id FROM Users WHERE username = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, username);
        rs = ps.executeQuery();

        long userId = -1;
        if (rs.next()) {
            userId = rs.getLong("user_id");
        } else {
            response.sendRedirect("login.jsp");
            return;
        }

        String update = "UPDATE User SET role=? WHERE user_id=?";
        psUpdate = con.prepareStatement(update);
        psUpdate.setString(1, role);
        psUpdate.setLong(2, userId);
        psUpdate.executeUpdate();

        session.setAttribute("role", role);
        if (role == "Customer"){
            response.sendRedirect("customerHome.jsp");
        }
        else if (role == "Rep"){
            response.sendRedirect("representativeDashboard.jsp");
        }
        else if (role == "Admin"){
            response.sendRedirect("adminDashboard.jsp");
        }
        

    } catch (SQLException e) {
        e.printStackTrace();
%>
        <script>
        alert('Database error occurred.');
        window.location.href = 'chooseRole.jsp';
        </script>
<%
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
%>
        <script>
        alert('JDBC Driver not found.');
        window.location.href = 'chooseRole.jsp';
        </script>
<%
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (psUpdate != null) psUpdate.close(); } catch (Exception ignored) {}
        try { if (con != null) con.close(); } catch (Exception ignored) {}
    }
%>
