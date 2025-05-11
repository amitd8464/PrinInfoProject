<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

    Integer userIdObj = (Integer) session.getAttribute("user");
    int user_id = (userIdObj != null) ? userIdObj : -1;

    List<Map<String, Object>> reservations = new ArrayList<Map<String, Object>>();
    List<Map<String, Object>> waitlist = new ArrayList<Map<String, Object>>();
    List<Map<String, Object>> tickets = new ArrayList<Map<String, Object>>();

    // Load Reservations
    PreparedStatement ps1 = conn.prepareStatement("SELECT reservation_id, flight_number, total_fare, booking_fee, booked_at FROM Reservation WHERE customer_id = ?");
    ps1.setInt(1, user_id);
    ResultSet rs1 = ps1.executeQuery();
    while (rs1.next()) {
        Map<String, Object> row = new HashMap<String, Object>();
        row.put("reservation_id", rs1.getInt("reservation_id"));
        row.put("flight_number", rs1.getInt("flight_number"));
        row.put("total_fare", rs1.getDouble("total_fare"));
        row.put("booking_fee", rs1.getDouble("booking_fee"));
        row.put("booked_at", rs1.getTimestamp("booked_at"));
        reservations.add(row);
    }

    // Load Waitlist
    PreparedStatement ps2 = conn.prepareStatement("SELECT waitlist_id, flight_number, request_time FROM WaitList WHERE customer_id = ?");
    ps2.setInt(1, user_id);
    ResultSet rs2 = ps2.executeQuery();
    while (rs2.next()) {
        Map<String, Object> row = new HashMap<String, Object>();
        row.put("waitlist_id", rs2.getInt("waitlist_id"));
        row.put("flight_number", rs2.getInt("flight_number"));
        row.put("request_time", rs2.getTimestamp("request_time"));
        waitlist.add(row);
    }

    // Load Tickets
    PreparedStatement psTicket = conn.prepareStatement(
        "SELECT t.ticket_number, t.dep_flight_number, t.ret_flight_number, " +
        "  (SELECT total_fare FROM Reservation WHERE customer_id = ? AND flight_number = t.dep_flight_number LIMIT 1) AS dep_fare, " +
        "  (SELECT booking_fee FROM Reservation WHERE customer_id = ? AND flight_number = t.dep_flight_number LIMIT 1) AS dep_fee, " +
        "  (SELECT booked_at FROM Reservation WHERE customer_id = ? AND flight_number = t.dep_flight_number LIMIT 1) AS dep_time, " +
        "  (SELECT total_fare FROM Reservation WHERE customer_id = ? AND flight_number = t.ret_flight_number LIMIT 1) AS ret_fare, " +
        "  (SELECT booking_fee FROM Reservation WHERE customer_id = ? AND flight_number = t.ret_flight_number LIMIT 1) AS ret_fee, " +
        "  (SELECT booked_at FROM Reservation WHERE customer_id = ? AND flight_number = t.ret_flight_number LIMIT 1) AS ret_time " +
        "FROM Ticket t WHERE t.passenger_id = ?"
    );

    for (int i = 1; i <= 7; i++) {
        psTicket.setInt(i, user_id);
    }


    ResultSet rsTicket = psTicket.executeQuery();
    while (rsTicket.next()) {
        Map<String, Object> ticket = new HashMap<String, Object>();
        ticket.put("ticket_number", rsTicket.getInt("ticket_number"));
        ticket.put("dep_flight_number", rsTicket.getInt("dep_flight_number"));
        ticket.put("ret_flight_number", rsTicket.getInt("ret_flight_number"));
        ticket.put("dep_fare", rsTicket.getObject("dep_fare"));
        ticket.put("dep_fee", rsTicket.getObject("dep_fee"));
        ticket.put("dep_time", rsTicket.getObject("dep_time"));
        ticket.put("ret_fare", rsTicket.getObject("ret_fare"));
        ticket.put("ret_fee", rsTicket.getObject("ret_fee"));
        ticket.put("ret_time", rsTicket.getObject("ret_time"));
        tickets.add(ticket);
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
        <div class="tab" id="tickets-tab" onclick="showTab('tickets')">Tickets</div>
    </div>

    <!-- Reservations Tab -->
    <div class="tab-content active" id="reservations">
        <% if (reservations.isEmpty()) { %>
            <p>No reservations found.</p>
        <% } else { %>
            <% for (Map<String, Object> res : reservations) { %>
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

    <!-- Waitlist Tab -->
    <div class="tab-content" id="waitlist">
        <% if (waitlist.isEmpty()) { %>
            <p>No waitlisted flights found.</p>
        <% } else { %>
            <% for (Map<String, Object> wl : waitlist) { %>
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

    <!-- Tickets Tab -->
    <div class="tab-content" id="tickets">
        <% if (tickets.isEmpty()) { %>
            <p>No tickets found.</p>
        <% } else { %>
            <% for (Map<String, Object> t : tickets) { %>
                <form action="viewTicket.jsp?ticket_number=<%= t.get("ticket_number") %>" method="post">
                    <div class="card">
                        <h3>Departure Flight</h3>
                        <strong>Flight:</strong> <%= t.get("dep_flight_number") %><br/>
                        <strong>Fare:</strong> $<%= t.get("dep_fare") != null ? t.get("dep_fare") : "N/A" %><br/>
                        <strong>Booking Fee:</strong> $<%= t.get("dep_fee") != null ? t.get("dep_fee") : "N/A" %><br/>
                        <strong>Booked At:</strong> <%= t.get("dep_time") != null ? t.get("dep_time") : "N/A" %><br/><br/>

                        <% if (t.get("ret_flight_number") != null) { %>
                            <h3>Return Flight</h3>
                            <strong>Flight:</strong> <%= t.get("ret_flight_number") %><br/>
                            <strong>Fare:</strong> $<%= t.get("ret_fare") != null ? t.get("ret_fare") : "N/A" %><br/>
                            <strong>Booking Fee:</strong> $<%= t.get("ret_fee") != null ? t.get("ret_fee") : "N/A" %><br/>
                            <strong>Booked At:</strong> <%= t.get("ret_time") != null ? t.get("ret_time") : "N/A" %><br/>
                        <% } %>

                        <button type="submit" style="padding: 14px 28px; font-size: 18px; background-color: #1877F2; color: white; border: none; border-radius: 10px; margin-top: 10px;">View Ticket</button>
                    </div>
                </form>
            <% } %>
        <% } %>
    </div>
</body>
</html>
