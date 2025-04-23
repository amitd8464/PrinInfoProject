<%@ page import ="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    Class.forName("com.mysql.jdbc.Driver");
    
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project","root",
    "");
    
    Statement st = con.createStatement();
    ResultSet rs;
    rs = st.executeQuery("select * from Users where username='" + username + "' and password='" + password + "'");

    if (rs.next()) {
        session.setAttribute("user", username); // the username will be stored in the session
        String role = rs.getString("role");
        session.setAttribute("role", role); // the username will be stored in the session

        out.println("welcome " + username);
        out.println("<a href='logout.jsp'>Log out</a>");
        response.sendRedirect("success.jsp");
    }
    else {
        out.println("<script>");
        out.println("alert('Username or password is incorrect');");
        out.println("window.location.href = 'login.jsp';");
        out.println("</script>");
    }
%>