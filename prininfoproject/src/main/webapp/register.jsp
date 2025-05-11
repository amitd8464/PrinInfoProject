<!DOCTYPE html>
<html>

<head>
    <title>Register Form</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>

<body>
    
    <div class="page-container">
        <div class="container">
            <form action="checkRegisterDetails.jsp">
                <label for="email">Email:</label><br>
                <input type="text" name="email" required><br>
    
                <label for="username">Username:</label><br>
                <input type="text" name="username" required><br>
                
                <label for="password">Password:</label><br>
                <input type="password" name="password" required><br>
    
                <br>
                
                <label for="firstname">First Name:</label><br>
                <input type="text" name="firstname"><br>
                
                <label for="lastname">Last Name:</label><br>
                <input type="text" name="lastname"><br>
    
                <input type="submit" value="Register">
            </form>
            <br>
            Already have an account? Login <a href='login.jsp'>here</a>
        </div>
    </div>

</body>

</html>