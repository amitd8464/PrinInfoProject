<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %>

<%!
/**
 * Filters and sorts the given flight list in place.
 */
private void applyFilters(
        List<Map<String,Object>> list,
        String airlineFilter,
        int maxStops,
        java.util.Date takeoffAfterTime,
        Comparator<Map<String,Object>> comparator)
    throws Exception
{
    if (list == null) return;

    Iterator<Map<String,Object>> it = list.iterator();
    while (it.hasNext()) {
        Map<String,Object> f = it.next();
        try {
            // Airline filter
            String al = (String) f.get("airline_id");
            if (airlineFilter != null
                && !airlineFilter.isEmpty()
                && (al == null
                    || !al.toLowerCase().contains(airlineFilter.toLowerCase())))
            {
                it.remove();
                continue;
            }

            // Max stops filter
            /* if (maxStops != -1) {
                Integer stops = (Integer) f.get("num_stops");
                if (stops == null || stops > maxStops) {
                    it.remove();
                    continue;
                }
            } */

            // Take-off after filter
            if (takeoffAfterTime != null) {
                Timestamp depTs = (Timestamp) f.get("dep_time");
                SimpleDateFormat tf = new SimpleDateFormat("HH:mm");
                java.util.Date depParsed = tf.parse(tf.format(depTs));
                if (depParsed.before(takeoffAfterTime)) {
                    it.remove();
                    continue;
                }
            }
        } catch (Exception e) {
            it.remove();
        }
    }

    if (comparator != null) {
        Collections.sort(list, comparator);
    }
}
%>

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
        html, body {
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
        #criteriaForm {
            flex-direction: row;
        }
        #criteriaForm select, #criteriaForm input {
            margin: 0 20px;
        }
        h3.resultTitle {
            align-self: flex-start;
        }
        .resultTitleContainer {
            display: flex;
            width: 93vw;
            flex-direction: row;
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
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/prinInfo_project", "root", "");
        Statement st = con.createStatement();

        // Load airports
        ResultSet rs = st.executeQuery("SELECT airport_id FROM Airport");
        List<String> airportList = new ArrayList<String>();
        while (rs.next()) {
            airportList.add(rs.getString("airport_id"));
        }

        // Load airlines
        ResultSet airlineCodes = st.executeQuery("SELECT airline_id FROM Airline");
        List<String> airlineList = new ArrayList<String>();
        while (airlineCodes.next()) {
            airlineList.add(airlineCodes.getString("airline_id"));
        }

        if (session.getAttribute("user") == null) {
    %>
            <p>You are not logged in</p>
            <a href="login.jsp">Please Login</a>
    <%
        } else {
    %>
            <h2>Search Flights</h2>
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
                        <% for (String airport : airportList) { %>
                            <option value="<%= airport %>"><%= airport %></option>
                        <% } %>
                    </select><br/>

                    <label>Destination Airport:</label>
                    <select name="dest_airport" required>
                        <option value="" disabled selected>Select destination</option>
                        <% for (String airport : airportList) { %>
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
                var tripRadios = document.querySelectorAll('input[name="trip_type"]');
                var returnField = document.getElementById('returnDateField');
                for (var i = 0; i < tripRadios.length; i++) {
                    tripRadios[i].addEventListener('change', function() {
                        returnField.style.display = (this.value === 'roundtrip')
                                                   ? 'block'
                                                   : 'none';
                    });
                }
            </script>
    <%
        }
    %>
    </div>

    <%
        // --- LOAD RAW RESULTS ---
        List<Map<String,Object>> rawDepartureFlights =
            (List<Map<String,Object>>) session.getAttribute("raw_departure_results");
        List<Map<String,Object>> departureFlights =
            rawDepartureFlights != null
            ? new ArrayList<Map<String,Object>>(rawDepartureFlights)
            : null;

        List<Map<String,Object>> rawReturnFlights =
            (List<Map<String,Object>>) session.getAttribute("raw_return_flights");
        List<Map<String,Object>> returnFlights =
            rawReturnFlights != null
            ? new ArrayList<Map<String,Object>>(rawReturnFlights)
            : null;

        // --- COMMON FILTER & SORT PARAMS ---
        String sortBy        = request.getParameter("sort_by");
        String airlineFilter = request.getParameter("airline_filter");
        String maxStopsStr   = request.getParameter("max_stops");
        String takeoffAfter  = request.getParameter("takeoff_after");

        int maxStops = -1;
        if (maxStopsStr != null && !maxStopsStr.isEmpty()) {
            maxStops = Integer.parseInt(maxStopsStr);
        }

        java.util.Date takeoffAfterTime = null;
        if (takeoffAfter != null && !takeoffAfter.isEmpty()) {
            takeoffAfterTime = new SimpleDateFormat("HH:mm").parse(takeoffAfter);
        }

        Comparator<Map<String,Object>> comparator = null;
        if ("price".equals(sortBy)) {
            comparator = new Comparator<Map<String,Object>>() {
                public int compare(Map<String,Object> f1, Map<String,Object> f2) {
                    return ((Double) f1.get("price"))
                        .compareTo((Double) f2.get("price"));
                }
            };
        } else if ("dep_time".equals(sortBy)) {
            comparator = new Comparator<Map<String,Object>>() {
                public int compare(Map<String,Object> f1, Map<String,Object> f2) {
                    return ((Timestamp) f1.get("dep_time"))
                        .compareTo((Timestamp) f2.get("dep_time"));
                }
            };
        } else if ("arr_time".equals(sortBy)) {
            comparator = new Comparator<Map<String,Object>>() {
                public int compare(Map<String,Object> f1, Map<String,Object> f2) {
                    return ((Timestamp) f1.get("arr_time"))
                        .compareTo((Timestamp) f2.get("arr_time"));
                }
            };
        } else if ("duration".equals(sortBy)) {
            comparator = new Comparator<Map<String,Object>>() {
                public int compare(Map<String,Object> f1, Map<String,Object> f2) {
                    Integer d1 = (Integer) f1.get("duration_minutes");
                    Integer d2 = (Integer) f2.get("duration_minutes");
                    if (d1 == null && d2 == null) return 0;
                    if (d1 == null) return 1;
                    if (d2 == null) return -1;
                    return d1.compareTo(d2);
                }
            };
        }

        // APPLY TO BOTH LISTS
        applyFilters(departureFlights,
                     airlineFilter,
                     maxStops,
                     takeoffAfterTime,
                     comparator);
        applyFilters(returnFlights,
                     airlineFilter,
                     maxStops,
                     takeoffAfterTime,
                     comparator);

        boolean hasDepartures = (departureFlights != null
                                 && !departureFlights.isEmpty());
        boolean hasReturns    = (returnFlights    != null
                                 && !returnFlights.isEmpty());

        SimpleDateFormat formatter =
            new SimpleDateFormat("EEE, MMM dd, yyyy, hh:mm a");
    %>

    <!-- FILTER / SORT FORM -->
    <form id="criteriaForm" method="get" style="margin:20px 0;">
        <label for="sort_by">Sort By:</label>
        <select name="sort_by" onchange="this.form.submit()">
            <option value="">-- Select --</option>
            <option value="price"    <%= "price".equals(sortBy)    ? "selected":"" %>>
                Price
            </option>
            <option value="dep_time" <%= "dep_time".equals(sortBy) ? "selected":"" %>>
                Take-off Time
            </option>
            <option value="arr_time" <%= "arr_time".equals(sortBy) ? "selected":"" %>>
                Landing Time
            </option>
            <option value="duration"<%= "duration".equals(sortBy) ? "selected":"" %>>
                Duration
            </option>
        </select>

        <label for="airline_filter">Airline:</label>
        <select name="airline_filter" onchange="this.form.submit()">
            <option value="">-- Any --</option>
            <% for (String a : airlineList) { %>
                <option value="<%=a%>"
                  <%= a.equals(request.getParameter("airline_filter"))?"selected":"" %>>
                  <%=a%>
                </option>
            <% } %>
        </select>

        <!-- <label for="max_stops">Max Stops:</label>
        <select name="max_stops" onchange="this.form.submit()">
            <option value="">-- Any --</option>
            <option value="0" <%= "0".equals(maxStopsStr)?"selected":"" %>>
                Non-stop
            </option>
            <option value="1" <%= "1".equals(maxStopsStr)?"selected":"" %>>
                1 stop
            </option>
            <option value="2" <%= "2".equals(maxStopsStr)?"selected":"" %>>
                2+ stops
            </option>
        </select> -->

        <label for="takeoff_after">Take-off After:</label>
        <input type="time"
               name="takeoff_after"
               value="<%= takeoffAfter != null ? takeoffAfter : "" %>"
               onchange="this.form.submit()" />

        <input type="submit" value="Apply" />
    </form>

    <!-- DEPARTURES TABLE -->
    <div class="resultTitleContainer">
        <h3 class="resultTitle">Departures (please select one)</h3>
    </div>

    <% if (hasDepartures) { %>
        <table class="flights-table">
            <thead>
                <tr>
                    <th>Price</th><th>Flight #</th><th>Airline</th>
                    <th>Departure</th><th>Destination</th>
                    <th>Departure Time</th><th>Arrival Time</th>
                    <th>Duration</th><th>Stops</th>
                </tr>
            </thead>
            <tbody>
            <% for (Map<String,Object> f : departureFlights) {
                   Integer d = (Integer) f.get("duration_minutes");
                   String dur = (d == null)
                                ? ""
                                : (d/60 + " h " + d%60 + " min");
            %>
                <tr>
                    <td>$<%=f.get("price")%></td>
                    <td><%=f.get("flight_number")%></td>
                    <td><%=f.get("airline_id")%></td>
                    <td><%=f.get("dep_airport")%></td>
                    <td><%=f.get("dest_airport")%></td>
                    <td><%=formatter.format((Timestamp)f.get("dep_time"))%></td>
                    <td><%=formatter.format((Timestamp)f.get("arr_time"))%></td>
                    <td><%=dur%></td>
                    <td><%=f.get("num_stops")%></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p>No matching flights found.</p>
    <% } %>

    <!-- RETURNS TABLE -->
    <div class="resultTitleContainer">
        <h3 class="resultTitle">Returns (please select one)</h3>
    </div>
    <% if (hasReturns) { %>
        <table class="flights-table">
            <thead>
                <tr>
                    <th>Price</th><th>Flight #</th><th>Airline</th>
                    <th>Departure</th><th>Destination</th>
                    <th>Departure Time</th><th>Arrival Time</th>
                    <th>Duration</th><th>Stops</th>
                </tr>
            </thead>
            <tbody>
            <% for (Map<String,Object> f : returnFlights) {
                   Integer d = (Integer) f.get("duration_minutes");
                   String dur = (d == null)
                                ? ""
                                : (d/60 + " h " + d%60 + " min");
            %>
                <tr>
                    <td>$<%=f.get("price")%></td>
                    <td><%=f.get("flight_number")%></td>
                    <td><%=f.get("airline_id")%></td>
                    <td><%=f.get("dep_airport")%></td>
                    <td><%=f.get("dest_airport")%></td>
                    <td><%=formatter.format((Timestamp)f.get("dep_time"))%></td>
                    <td><%=formatter.format((Timestamp)f.get("arr_time"))%></td>
                    <td><%=dur%></td>
                    <td><%=f.get("num_stops")%></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p>No matching return flights found.</p>
    <% } %>

</body>
</html>
