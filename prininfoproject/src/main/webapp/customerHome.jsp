<html>
<head>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-size: 24px;
            font-family: Arial, sans-serif;
            margin: 0;
        }

        .container {
            text-align: center;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            font-size: 20px;
            color: #0066cc;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
<%
    if (session.getAttribute("user") == null) {
%>
        You are not logged in
        <br/>
        <a href="login.jsp">Please Login</a>
<%
    } else {
        Integer user_id = (Integer) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
%>
        Welcome User ID: <%= user_id %><br/>
        Your role is: <%= role %><br/>

        <br>
        <a href="searchFlights.jsp">Search for a flight</a>
        <br>

        <%-- This will have an option to see past or future reservations --%>
        <a href="viewReservations.jsp">View your reservations</a> 
        <br>
        
        <a href="viewReservations.jsp">Need help? Submit a question or concern here</a>
        <br>
        <br>

        <a href="logout.jsp">Log out</a>
<%
    }
%>
    </div>
</body>
</html>
