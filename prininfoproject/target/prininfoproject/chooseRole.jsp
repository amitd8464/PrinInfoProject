<!DOCTYPE html>
<html>

    <head>
        <title>Choose Role</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
    </head>

    <body>
        
        <form action="updateUserRole.jsp" method="POST">
            <label for="userRole">Choose a role:</label>
            <select name="role" id="role">
                <option value="Customer">Customer</option>
                <option value="Rep">Representative</option>
                <option value="Admin">Administrator</option>
            </select>
        
            <button type="submit">Submit</button>
        </form>

    </body>

</html>