<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    Integer userIdObj = (Integer) session.getAttribute("user");
    int user_id = (userIdObj != null) ? userIdObj : -1;

    Integer flightToBook = (Integer) session.getAttribute("flight_to_book_from_waitlist");

    if (flightToBook != null) {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

        PreparedStatement ps = conn.prepareStatement("SELECT * FROM Flight WHERE flight_number = ?");
        ps.setInt(1, flightToBook);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Map<String, Object> selectedFlight = new HashMap<String, Object>();
            selectedFlight.put("flight_number", rs.getInt("flight_number"));
            selectedFlight.put("dep_time", rs.getTimestamp("dep_time"));
            selectedFlight.put("atCapacity", rs.getBoolean("atCapacity"));
            session.setAttribute("selected_departure_flight", selectedFlight);
            session.setAttribute("depAtCapacity", rs.getBoolean("atCapacity"));
        }

        rs.close();
        ps.close();
        conn.close();
    }
%>
<html>
<head>
    <title>Select Travel Class</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }

        select, button {
            padding: 10px;
            font-size: 16px;
            margin-top: 10px;
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Select Your Travel Class</h2>
        <form action="confirmBooking.jsp" method="post">
            <select name="travel_class" required>
                <option value="Economy">Economy</option>
                <option value="Business">Business</option>
                <option value="First">First</option>
            </select>
            <button type="submit">Continue</button>
        </form>
    </div>
</body>
</html>