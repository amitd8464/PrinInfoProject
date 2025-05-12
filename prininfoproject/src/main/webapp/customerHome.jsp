<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<html>
<head>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-size: 24px;
            font-family: Arial, sans-serif;
            margin: 0;
        }

        .container {
            text-align: center;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            font-size: 20px;
            color: #0066cc;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
<%
    if (session.getAttribute("user") == null) {
%>
        You are not logged in<br/>
        <a href="login.jsp">Please Login</a>
<%
    } else {
        Integer user_id = (Integer) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
%>
        Welcome User ID: <%= user_id %><br/>
        Your role is: <%= role %><br/>

        <br>
        <a href="searchFlights.jsp">Search for a flight</a><br>
        <a href="customerReservations.jsp">View your reservations</a><br>
        <a href="viewReservations.jsp">Need help? Submit a question or concern here</a><br><br>
        <a href="logout.jsp">Log out</a>
<%
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

        PreparedStatement psNotify = conn.prepareStatement(
            "SELECT flight_number FROM WaitList WHERE customer_id = ? AND notified = 1 LIMIT 1"
        );
        psNotify.setInt(1, user_id);
        ResultSet rsNotify = psNotify.executeQuery();

        if (rsNotify.next()) {
            int flightToBook = rsNotify.getInt("flight_number");

            // Fetch flight data to prepare selected_departure_flight
            PreparedStatement psFlight = conn.prepareStatement(
                "SELECT flight_number, airline_id, dep_airport, dest_airport, dep_time, arr_time, price, atCapacity FROM Flight WHERE flight_number = ?"
            );
            psFlight.setInt(1, flightToBook);
            ResultSet rsFlight = psFlight.executeQuery();

            if (rsFlight.next()) {
                Map selectedFlight = new HashMap();
                selectedFlight.put("flight_number", rsFlight.getInt("flight_number"));
                selectedFlight.put("airline_id", rsFlight.getString("airline_id"));
                selectedFlight.put("dep_airport", rsFlight.getString("dep_airport"));
                selectedFlight.put("dest_airport", rsFlight.getString("dest_airport"));
                selectedFlight.put("dep_time", rsFlight.getTimestamp("dep_time"));
                selectedFlight.put("arr_time", rsFlight.getTimestamp("arr_time"));
                selectedFlight.put("price", rsFlight.getDouble("price"));
                selectedFlight.put("atCapacity", rsFlight.getBoolean("atCapacity") ? 1 : 0);

                session.setAttribute("selected_departure_flight", selectedFlight);
                session.removeAttribute("selected_return_flight"); // if needed

                // Clear notified flag so user isn't re-alerted next time
                PreparedStatement clearNotif = conn.prepareStatement(
                    "UPDATE WaitList SET notified = 0 WHERE customer_id = ? AND flight_number = ?"
                );
                clearNotif.setInt(1, user_id);
                clearNotif.setInt(2, flightToBook);
                clearNotif.executeUpdate();
                clearNotif.close();

                rsFlight.close();
                psFlight.close();
                rsNotify.close();
                psNotify.close();
                conn.close();

                session.setAttribute("lastPage", "customerHome.jsp");
%>
<script>
    if(confirm("A seat has opened on your waitlisted flight. Would you like to book it now?")) {
        // Create a form to remove the waitlist entry before navigating
        const form = document.createElement("form");
        form.method = "POST";
        form.action = "removeWaitlistEntry.jsp";

        const flightInput = document.createElement("input");
        flightInput.type = "hidden";
        flightInput.name = "flight_number";
        flightInput.value = "<%= flightToBook %>";
        form.appendChild(flightInput);

        document.body.appendChild(form);
        form.submit();
    }
</script>
<%
            } else {
                rsFlight.close();
                psFlight.close();
            }
        } else {
            rsNotify.close();
            psNotify.close();
            conn.close();
        }
    }
%>
    </div>
</body>
</html>
