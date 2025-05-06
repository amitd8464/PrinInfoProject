<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Representative Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1  { margin-bottom: 10px; }
        .card { border: 1px solid #ccc; padding: 20px; margin: 12px 0; border-radius: 6px; }
        form, .card a { display: inline-block; margin-top: 8px; }
        label { display: block; margin-top: 6px; }
        input, select { padding: 4px 6px; }
        button { margin-top: 8px; }
    </style>
</head>
<body>

<%
    HttpSession s = request.getSession(false);
    if (s == null || !"Rep".equals(s.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<h1>Hello, Rep <%= s.getAttribute("user") %>!</h1>

<div class="card">
    <h3>Book or Edit Flight for Customer</h3>
    <form action="repReservationCRUD.jsp" method="GET">
        <label>Action:
            <select name="action">
                <option value="book">Book</option>
                <option value="edit">Edit</option>
            </select>
        </label>
        <label>Customer Username <input type="text" name="cust" required></label>
        <label>Flight # <input type="number" name="flight" required></label>
        <button type="submit">Proceed</button>
    </form>
</div>

<div class="card">
    <h3>Manage Aircraft, Airports & Flights</h3>
    <form action="repAdminCRUD.jsp" method="GET">
        <label>Entity:
            <select name="entity">
                <option value="aircraft">Aircraft</option>
                <option value="airport">Airport</option>
                <option value="flight">Flight</option>
            </select>
        </label>
        <label>Action:
            <select name="action">
                <option value="add">Add</option>
                <option value="edit">Edit</option>
                <option value="delete">Delete</option>
            </select>
        </label>
        <label>ID / Code <input type="text" name="id" required></label>
        <button type="submit">Go</button>
    </form>
</div>

<div class="card">
    <h3>Waiting List for a Flight</h3>
    <form action="repWaitingList.jsp" method="GET">
        <label>Flight # <input type="number" name="flight" required></label>
        <button type="submit">Retrieve</button>
    </form>
</div>

<div class="card">
    <h3>Flights at an Airport</h3>
    <form action="repAirportFlights.jsp" method="GET">
        <label>Airport Code <input type="text" name="airport" maxlength="3" required></label>
        <button type="submit">Search</button>
    </form>
</div>

<div class="card">
    <h3>Reply to User Questions</h3>
    <a href="repAnswerQuestions.jsp">Open Question Inbox</a>
</div>

<a href="logout.jsp">Logout</a>
</body>
</html>
