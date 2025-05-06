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

        int user_id = -1;
        if (session != null) {
            user_id = (Integer) session.getAttribute("user");
        } else {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = request.getParameter("role");
        out.println("Selected role: " + role);

        String update = "UPDATE Users SET role=? WHERE user_id=?";
        psUpdate = con.prepareStatement(update);
        psUpdate.setString(1, role);
        psUpdate.setInt(2, user_id);
        psUpdate.executeUpdate();

        session.setAttribute("role", role);
        if ("Customer".equals(role)){
            response.sendRedirect("customerHome.jsp");
        }
        else if ("Rep".equals(role)){
            response.sendRedirect("representativeDashboard.jsp");
        }
        else if ("Admin".equals(role)){
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
