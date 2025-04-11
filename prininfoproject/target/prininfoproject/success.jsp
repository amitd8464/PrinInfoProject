<%
    if (session.getAttribute("user") == null) {
%>
    You are not logged in
    <br/>
    <a href="login.jsp">Please Login</a>
<%
    } else {
        String username = (String) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
%>
    Welcome <%= username %>
    <br/>
    Your role is: <%= role %>
    <a href="logout.jsp">Log out</a>
<%
    }
%>
