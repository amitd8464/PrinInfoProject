<!DOCTYPE html>
<html>

    <head>
        <title>Choose Role</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <style>
            body, label, select {
                font-size: 28px;
            }

            button {
                font-size: 16px; /* Original/default size */
            }
        </style>
    </head>

    <body>
        
        <div class="page-container">
            <form action="updateUserRole.jsp" method="POST">
                <label for="userRole">Choose a role:</label>
                <select name="role" id="role">
                    <option value="Customer">Customer</option>
                    <option value="Rep">Representative</option>
                    <option value="Admin">Administrator</option>
                </select>
            
                <button type="submit">Submit</button>
            </form>
        </div>

    </body>

</html>
