<%@ page import="java.sql.*" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat, java.sql.Timestamp" %>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        body {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            padding: 50px;
            font-size: 24px;
            font-family: Arial, sans-serif;
            margin: 0;
        }
        html, body{
            height: auto;
            min-height: 100%;
            overflow-y: auto;
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
        #criteriaForm{
            flex-direction: row;
        }
        #criteriaForm select, #criteriaForm input{
            margin-right: 20px;
            margin-left: 20px;
        }
    </style>
</head>

<body>
<div class="navbar">
    <a href="customerHome.jsp">Home</a>
    <a href="searchFlights.jsp">Search Flights</a>
    <a href="reservations.jsp">My Reservations</a>
    <a id="logout" href="logout.jsp">Log out</a>
</div>

<div class="container">
<%
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");
    Statement st = con.createStatement();

    ResultSet rs = st.executeQuery("SELECT airport_id from Airport");
    List<String> airportList = new ArrayList<String>();
    while (rs.next()) {
        airportList.add(rs.getString("airport_id"));
    }

    ResultSet airlineCodes = st.executeQuery("SELECT airline_id FROM Airline");
    List<String> airlineList = new ArrayList<String>();
    while (airlineCodes.next()) {
        airlineList.add(airlineCodes.getString("airline_id"));
    }

    if (session.getAttribute("user") == null) {
%>
        You are not logged in<br/>
        <a href="login.jsp">Please Login</a>
<%
    } else {
        String username = (String) session.getAttribute("user");
%>
        <h2>Search Flights</h2><br>

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
                <input type="date" name="dep_date" required /><br/>
            </div>

            <div id="returnDateField" style="display:none;">
                <label>Return Date:</label>
                <input type="date" name="return_date" /><br/>
            </div>

            <input type="submit" value="Search Flights"/>
        </form>

        <script>
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

<%
    List<Map<String, Object>> rawDepartureFlights = (List<Map<String, Object>>) session.getAttribute("raw_departure_results");
    List<Map<String, Object>> departureFlights = rawDepartureFlights != null ? new ArrayList<Map<String, Object>>(rawDepartureFlights) : null;

    String sortBy = request.getParameter("sort_by");
    String airlineFilter = request.getParameter("airline_filter");
    String maxStopsStr = request.getParameter("max_stops");
    String takeoffAfter = request.getParameter("takeoff_after");

    int maxStops = -1;
    if (maxStopsStr != null && !maxStopsStr.isEmpty()) {
        maxStops = Integer.parseInt(maxStopsStr);
    }

    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    java.util.Date takeoffAfterTime = null;
    if (takeoffAfter != null && !takeoffAfter.isEmpty()) {
        takeoffAfterTime = timeFormat.parse(takeoffAfter);
    }

    Comparator<Map<String, Object>> comparator = null;
    if ("price".equals(sortBy)) {
        comparator = new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> f1, Map<String, Object> f2) {
                return ((Double) f1.get("price")).compareTo((Double) f2.get("price"));
            }
        };
    } else if ("dep_time".equals(sortBy)) {
        comparator = new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> f1, Map<String, Object> f2) {
                return ((Timestamp) f1.get("dep_time")).compareTo((Timestamp) f2.get("dep_time"));
            }
        };
    } else if ("arr_time".equals(sortBy)) {
        comparator = new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> f1, Map<String, Object> f2) {
                return ((Timestamp) f1.get("arr_time")).compareTo((Timestamp) f2.get("arr_time"));
            }
        };
    } else if ("duration".equals(sortBy)) {
        comparator = new Comparator<Map<String, Object>>() {
            public int compare(Map<String, Object> f1, Map<String, Object> f2) {
                Integer d1 = (Integer) f1.get("duration_minutes");
                Integer d2 = (Integer) f2.get("duration_minutes");
                if (d1 == null && d2 == null) return 0;
                if (d1 == null) return 1;
                if (d2 == null) return -1;
                return d1.compareTo(d2);
            }
        };
    }

    if (departureFlights != null) {
        Iterator<Map<String, Object>> it = departureFlights.iterator();
        while (it.hasNext()) {
            Map<String, Object> flight = it.next();
            try {
                if (airlineFilter != null && !airlineFilter.isEmpty()) {
                    String airline = (String) flight.get("airline_id");
                    if (airline == null || !airline.toLowerCase().contains(airlineFilter.toLowerCase())) {
                        it.remove(); continue;
                    }
                }
                if (maxStops != -1) {
                    Integer stops = (Integer) flight.get("num_stops");
                    if (stops == null || stops > maxStops) {
                        it.remove(); continue;
                    }
                }
                if (takeoffAfterTime != null) {
                    Timestamp depTime = (Timestamp) flight.get("dep_time");
                    String timeStr = timeFormat.format(depTime);
                    java.util.Date depParsed = timeFormat.parse(timeStr);
                    if (depParsed.before(takeoffAfterTime)) {
                        it.remove(); continue;
                    }
                }
            } catch (Exception e) {
                it.remove();
            }
        }
        if (comparator != null) Collections.sort(departureFlights, comparator);
    }

    boolean hasDepartures = departureFlights != null && !departureFlights.isEmpty();
    SimpleDateFormat formatter = new SimpleDateFormat("EEE, MMM dd, yyyy, hh:mm a");
%>

<form id="criteriaForm" method="get" style="margin: 20px 0;">
    <label for="sort_by">Sort By:</label>
    <select name="sort_by" onchange="this.form.submit()">
        <option value="">-- Select --</option>
        <option value="price" <%= "price".equals(sortBy) ? "selected" : "" %>>Price</option>
        <option value="dep_time" <%= "dep_time".equals(sortBy) ? "selected" : "" %>>Take-off Time</option>
        <option value="arr_time" <%= "arr_time".equals(sortBy) ? "selected" : "" %>>Landing Time</option>
        <option value="duration" <%= "duration".equals(sortBy) ? "selected" : "" %>>Duration</option>
    </select>

    <label for="airline_filter">Airline:</label>
    <select name="airline_filter">
        <option value="">-- Any --</option>
        <% for (String airline : airlineList) { %>
            <option value="<%= airline %>" <%= airline.equals(request.getParameter("airline_filter")) ? "selected" : "" %>><%= airline %></option>
        <% } %>
    </select>

    <label for="max_stops">Max Stops:</label>
    <select name="max_stops">
        <option value="">-- Any --</option>
        <option value="0" <%= "0".equals(maxStopsStr) ? "selected" : "" %>>Non-stop</option>
        <option value="1" <%= "1".equals(maxStopsStr) ? "selected" : "" %>>1 stop</option>
        <option value="2" <%= "2".equals(maxStopsStr) ? "selected" : "" %>>2+ stops</option>
    </select>

    <label for="takeoff_after">Take-off After:</label>
    <input type="time" name="takeoff_after" value="<%= takeoffAfter != null ? takeoffAfter : "" %>" />

    <input type="submit" value="Apply" />
</form>

<h3>Departures</h3>
<% if (hasDepartures) { %>    
    <table class="flights-table">
        <thead>
            <tr>
                <th>Price</th>
                <th>Flight #</th>
                <th>Airline</th>
                <th>Departure</th>
                <th>Destination</th>
                <th>Departure Time</th>
                <th>Arrival Time</th>
                <th>Duration</th>
                <th>Stops</th>
            </tr>
        </thead>
        <tbody>
            <% for (Map<String, Object> flight : departureFlights) {
                Integer duration = (Integer) flight.get("duration_minutes");
                String durationDisplay = (duration == null) ? "" : (duration / 60 + " h " + duration % 60 + " min");
            %>
                <tr>
                    <td>$<%= flight.get("price") %></td>
                    <td><%= flight.get("flight_number") %></td>
                    <td><%= flight.get("airline_id") %></td>
                    <td><%= flight.get("dep_airport") %></td>
                    <td><%= flight.get("dest_airport") %></td>
                    <td><%= formatter.format((Timestamp) flight.get("dep_time")) %></td>
                    <td><%= formatter.format((Timestamp) flight.get("arr_time")) %></td>
                    <td><%= durationDisplay %></td>
                    <td><%= flight.get("num_stops") %></td>
                </tr>
            <% } %>
        </tbody>
    </table>
<% } else { %>
    <p>No matching flights found.</p>
<% } %>

</body>
</html>
