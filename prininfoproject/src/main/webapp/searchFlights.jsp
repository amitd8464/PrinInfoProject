<%@ page import ="java.sql.*" %>
<%@ page import="java.util.*" %>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/style.css">

    <style>
        body {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            padding: 50px; /* ✅ Add px */
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
    <div class="navbar">
        <a href="home.jsp">Home</a>
        <a href="searchFlights.jsp">Search Flights</a>
        <a href="reservations.jsp">My Reservations</a>
        <a id="logout" href="logout.jsp">Log out</a>
    </div>

    <div class="container">
<%
    if (session.getAttribute("user") == null) {
%>
        You are not logged in
        <br/>
        <a href="login.jsp">Please Login</a>
<%
    } else {
        // Get session attributes:
        String username = (String) session.getAttribute("user");


        // Setup connection infrastructure
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");
        Statement st = con.createStatement();
        ResultSet rs = null;

        rs = st.executeQuery("SELECT airport_id from Airport");

        java.util.List<String> airportList = new java.util.ArrayList<String>();
        while (rs.next()) {
            airportList.add(rs.getString("airport_id"));
        }
    
%>


        Search Flights

        <br>
        <br>
        
        <form id="flight_search" action="executeFlightSearch.jsp">
            <div class="flight_options_container">
                <label>Trip Type:</label><br/>
                <input type="radio" name="trip_type" value="oneway" checked> One-Way<br/>
                <input type="radio" name="trip_type" value="roundtrip"> Round-Trip<br/>
                <input type="checkbox" name="flexible" value="true"> Flexible Dates (+/- 3 days)<br/><br/>
            </div>


            <div class="flight_options_container">
                <label>Departure Airport:</label>
                <select name="dep_airport" required>
                    <option value="" disabled selected>Select departure</option>
                    <% for(String airport : airportList) { %>
                        <option value="<%= airport %>"><%= airport %></option>
                    <% } %>
                </select><br/>

                <label>Destination Airport:</label>
                <select name="dest_airport" required>
                    <option value="" disabled selected>Select destination</option>
                    <% for(String airport : airportList) { %>
                        <option value="<%= airport %>"><%= airport %></option>
                    <% } %>
                </select><br/>

            </div>

            <div>
                <label>Departure Date:</label>
                <input type="date" name="dep_date" /><br/>
            </div>

            <div id="returnDateField" style="display:none;">
                <label>Return Date:</label>
                <input type="date" name="return_date" /><br/>
            </div>

            <input type="submit" value="Search Flights"/>
        </form>


        <script>
            // Show/hide return date based on trip type
            const tripRadios = document.querySelectorAll('input[name="trip_type"]');
            const returnField = document.getElementById('returnDateField');


            tripRadios.forEach(r => {
                r.addEventListener('change', () => {
                    returnField.style.display = (r.value === 'roundtrip') ? 'block' : 'none';
                });
            });
        </script>

<%
    }
%>
    </div>
    
    <%-- Search results --%>
    <div class="container">
        
        <%  List<Map<String, Object>> departureFlights = (List<Map<String, Object>>) session.getAttribute("departure_results");
            List<Map<String, Object>> returnFlights = (List<Map<String, Object>>) session.getAttribute("return_results");
            if (departureFlights != null && !departureFlights.isEmpty()) { %>
            <table class="flights-table">
                <thead>
                    <tr>
                        <th>Flight #</th>
                        <th>Airline</th>
                        <th>Departure</th>
                        <th>Destination</th>
                        <th>Departure Time</th>
                        <th>Arrival Time</th>
                        <th>Type</th>
                        <th>Aircraft</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> flight : departureFlights) { %>
                        <tr>
                            <td><%= flight.get("flight_number") %></td>
                            <td><%= flight.get("airline_id") %></td>
                            <td><%= flight.get("dep_airport") %></td>
                            <td><%= flight.get("dest_airport") %></td>
                            <td><%= flight.get("dep_time") %></td>
                            <td><%= flight.get("arr_time") %></td>
                            <td><%= flight.get("flight_type") %></td>
                            <td><%= flight.get("aircraft_id") %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        
        <% } else { %>
            <p>No flights found.</p>
        <% } %>

    </div>

</body>
</html>
