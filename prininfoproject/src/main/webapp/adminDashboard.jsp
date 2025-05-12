<%@ page session="false" %>
<!DOCTYPE html>  
<html>  
<head>  
    <title>AdminDashboard</title>  
    <link rel="stylesheet" href="css/style.css">  
</head>  
<body>  
    <h1>AdminDashboard</h1>  
    <ul>  
        <li><a href="adminFlightCRUD.jsp">Manage Flights</a></li>  <!-- 修正方括号 -->
        <li><a href="adminUserCRUD.jsp">Manage Users</a></li>  
        <li><a href="adminMonthlySales.jsp">Monthly Sales</a></li>  
        <li><a href="adminReservationList.jsp">Reservation Search</a></li>  
        <li><a href="adminRevenuesSummary.jsp">Revenue Summary</a></li>  
        <li><a href="adminTopCustomer.jsp">Top Customer</a></li>  
        <li><a href="adminActiveFlights.jsp">Most Active Flights</a></li>  
    </ul>  
    <form action="logout.jsp" method="post">  <!-- 修正未闭合的 form 标签 -->
        <button type="submit">Logout</button>  
    </form>  
</body>  
</html>  