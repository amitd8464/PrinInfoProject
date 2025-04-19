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
        String username = (String) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
%>
        Welcome <%= username %><br/>
        Your role is: <%= role %><br/>
        <a href="logout.jsp">Log out</a>
<%
    }
%>
    </div>
</body>
</html>
