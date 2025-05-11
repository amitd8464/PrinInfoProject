<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

    Integer userIdObj = (Integer) session.getAttribute("user");
    int user_id = (userIdObj != null) ? userIdObj : -1;

    List reservations = new ArrayList();
    List waitlist = new ArrayList();

    PreparedStatement ps1 = conn.prepareStatement("SELECT reservation_id, flight_number, total_fare, booking_fee, booked_at FROM Reservation WHERE customer_id = ?");
    ps1.setInt(1, user_id);
    ResultSet rs1 = ps1.executeQuery();
    while (rs1.next()) {
        Map row = new HashMap();
        row.put("reservation_id", new Integer(rs1.getInt("reservation_id")));
        row.put("flight_number", new Integer(rs1.getInt("flight_number")));
        row.put("total_fare", new Double(rs1.getDouble("total_fare")));
        row.put("booking_fee", new Double(rs1.getDouble("booking_fee")));
        row.put("booked_at", rs1.getTimestamp("booked_at"));
        reservations.add(row);
    }

    PreparedStatement ps2 = conn.prepareStatement("SELECT waitlist_id, flight_number, request_time FROM WaitList WHERE customer_id = ?");
    ps2.setInt(1, user_id);
    ResultSet rs2 = ps2.executeQuery();
    while (rs2.next()) {
        Map row = new HashMap();
        row.put("waitlist_id", new Integer(rs2.getInt("waitlist_id")));
        row.put("flight_number", new Integer(rs2.getInt("flight_number")));
        row.put("request_time", rs2.getTimestamp("request_time"));
        waitlist.add(row);
    }
%>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        body { font-family: Arial; padding: 20px; }
        .tab-container { display: flex; gap: 20px; margin-bottom: 20px; }
        .tab { cursor: pointer; padding: 10px 20px; border-radius: 6px; border: 1px solid #ccc; background-color: #f0f0f0; }
        .tab.active { background-color: #007bff; color: white; border-color: #007bff; }
        .card { padding: 15px; border: 1px solid #ccc; border-radius: 8px; margin-bottom: 10px; transition: 0.2s; }
        .card:hover { background-color: #f9f9f9; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
    </style>
    <script>
        function showTab(tabName) {
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            document.getElementById(tabName).classList.add('active');
            document.getElementById(tabName + '-tab').classList.add('active');
        }
    </script>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="tab-container">
        <div class="tab active" id="reservations-tab" onclick="showTab('reservations')">Reservations</div>
        <div class="tab" id="waitlist-tab" onclick="showTab('waitlist')">Waitlist</div>
    </div>

    <div class="tab-content active" id="reservations">
        <% if (reservations.isEmpty()) { %>
            <p>No reservations found.</p>
        <% } else { %>
            <% for (Iterator it = reservations.iterator(); it.hasNext(); ) {
                   Map res = (Map) it.next(); %>
                <form action="viewReservation.jsp?reservation_id=<%= res.get("reservation_id") %>" method="post">
                    <div class="card">
                        <strong>Flight:</strong> <%= res.get("flight_number") %><br/>
                        <strong>Total Fare:</strong> $<%= res.get("total_fare") %><br/>
                        <strong>Booking Fee:</strong> $<%= res.get("booking_fee") %><br/>
                        <strong>Booked At:</strong> <%= res.get("booked_at") %>
                        <button type="submit" style="padding: 14px 28px; font-size: 18px; background-color: #1877F2; color: white; border: none; border-radius: 10px; margin-left: 20px;">View Reservation</button>
                    </div>
                    
                </form>
            <% } %>
        <% } %>
    </div>

    <div class="tab-content" id="waitlist">
        <% if (waitlist.isEmpty()) { %>
            <p>No waitlisted flights found.</p>
        <% } else { %>
            <% for (Iterator it = waitlist.iterator(); it.hasNext(); ) {
                   Map wl = (Map) it.next(); %>
                <form action="viewWaitList.jsp?waitlist_id=<%= wl.get("waitlist_id") %>" method="post">
                    <div class="card">
                        <strong>Flight:</strong> <%= wl.get("flight_number") %><br/>
                        <strong>Requested At:</strong> <%= wl.get("request_time") %>
                        <button type="submit" style="padding: 14px 28px; font-size: 18px; background-color: #1877F2; color: white; border: none; border-radius: 10px; margin-left: 20px;">View Waitlist Request</button>
                    </div>
                </form>
            <% } %>
        <% } %>
    </div>
</body>
</html>
