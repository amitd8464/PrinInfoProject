<!DOCTYPE html>
<html>

<head>
    <title>Login Form</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>

<body>
    
    <form action="checkLoginDetails.jsp">
        <label for="username">Username:</label><br>
        <input type="text" name="username" required><br>
        
        <label for="password">Password:</label><br>
        <input type="password" name="password" required><br>

        <input type="submit" value="Login">
    </form>

    <small>Don't have an account? Register <a href='register.jsp'>here</a></small>

</body>

</html>