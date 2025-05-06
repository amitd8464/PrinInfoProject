<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1  { margin-bottom: 10px; }
        .card { border: 1px solid #ccc; padding: 20px; margin: 12px 0; border-radius: 6px; }
        .card h3 { margin-top: 0; }
        form, .card a { display: inline-block; margin-top: 8px; }
        label { display: block; margin-top: 6px; }
        input, select { padding: 4px 6px; }
        button { margin-top: 8px; }
    </style>
</head>
<body>

<%
    HttpSession s = request.getSession(false);
    if (s == null || !"Admin".equals(s.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<h1>Welcome, Admin <%= s.getAttribute("user") %>!</h1>

<div class="card">
    <h3>Add / Edit / Delete Customer or Representative</h3>
    <form action="adminUserCRUD.jsp" method="GET">
        <label>Action:
            <select name="action">
                <option value="add">Add</option>
                <option value="edit">Edit</option>
                <option value="delete">Delete</option>
            </select>
        </label>
        <label>User Role:
            <select name="role">
                <option value="Customer">Customer</option>
                <option value="Rep">Representative</option>
            </select>
        </label>
        <label>Username / ID <input type="text" name="key" required></label>
        <button type="submit">Submit</button>
    </form>
</div>

<div class="card">
    <h3>Monthly Sales Report</h3>
    <form action="adminMonthlySales.jsp" method="GET">
        <label>Month (YYYY-MM) <input type="month" name="month" required></label>
        <button type="submit">Generate</button>
    </form>
</div>

<div class="card">
    <h3>Reservation List</h3>
    <form action="adminReservationList.jsp" method="GET">
        <label>Search By:
            <select name="by">
                <option value="flight">Flight #</option>
                <option value="customer">Customer Name</option>
            </select>
        </label>
        <label>Value <input type="text" name="value" required></label>
        <button type="submit">Search</button>
    </form>
</div>

<div class="card">
    <h3>Revenue Summary</h3>
    <form action="adminRevenueSummary.jsp" method="GET">
        <label>Group By:
            <select name="group">
                <option value="flight">Flight</option>
                <option value="airline">Airline</option>
                <option value="customer">Customer</option>
            </select>
        </label>
        <button type="submit">View</button>
    </form>
</div>

<div class="card">
    <h3>Insights</h3>
    <a href="adminTopCustomer.jsp">🔍 Customer with Highest Revenue</a><br>
    <a href="adminActiveFlights.jsp">🔍 Most Active Flights (tickets sold)</a>
</div>

<a href="logout.jsp">Logout</a>
</body>
</html>
