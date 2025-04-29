<%@ page import ="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    Class.forName("com.mysql.jdbc.Driver");
    
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project","root",
    "");
    
    Statement st = con.createStatement();
    ResultSet rs;
    PreparedStatement ps = con.prepareStatement("SELECT * FROM Users WHERE username = ? AND password = ?");
    ps.setString(1, username);
    ps.setString(2, password);
    rs = ps.executeQuery();


    if (rs.next()) {
        session.setAttribute("user", username); // the username will be stored in the session
        String role = rs.getString("role");
        session.setAttribute("role", role); // the username will be stored in the session

        if ("Customer".equals(role)){
            response.sendRedirect("customerHome.jsp");
        }
        else if ("Rep".equals(role)){
            response.sendRedirect("representativeDashboard.jsp");
        }
        else if ("Admin".equals(role)){
            response.sendRedirect("adminDashboard.jsp");
        }
    }
    else { %>
        <script>
            alert('Username or password is incorrect');
            window.location.href = 'login.jsp';
        </script> <%
    }
%>