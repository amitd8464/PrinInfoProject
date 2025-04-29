    <%@ page import ="java.sql.*" %>
    <%@ page import="java.util.*" %>
    <%@ page import="java.text.SimpleDateFormat, java.sql.Timestamp" %>

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
            <a href="customerHome.jsp">Home</a>
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
                    <input type="date" name="dep_date" required /><br/>
                </div>

                <div id="returnDateField" style="display:none;" required>
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
        
        <%
    String sortBy = request.getParameter("sort_by");
%>

        <form method="get" style="margin-bottom: 20px;">
            <label for="sort_by">Sort results by:</label>
            <select name="sort_by" id="sort_by" onchange="this.form.submit()">
                <option value="">-- Select --</option>
                <option value="price" <%= "price".equals(sortBy) ? "selected" : "" %>>Price</option>
                <option value="dep_time" <%= "dep_time".equals(sortBy) ? "selected" : "" %>>Take-off Time</option>
                <option value="arr_time" <%= "arr_time".equals(sortBy) ? "selected" : "" %>>Landing Time</option>
                <option value="duration" <%= "duration".equals(sortBy) ? "selected" : "" %>>Duration of Flight</option>
            </select>
        </form>


        <div id="flight_search_results_container">

    <%
        List<Map<String, Object>> departureFlights = (List<Map<String, Object>>) session.getAttribute("departure_results");
        List<Map<String, Object>> returnFlights = (List<Map<String, Object>>) session.getAttribute("return_results");

        Comparator<Map<String, Object>> comparator = null;

        if ("price".equals(sortBy)) {
            comparator = new Comparator<Map<String, Object>>() {
                public int compare(Map<String, Object> f1, Map<String, Object> f2) {
                    Double p1 = (Double) f1.get("price");
                    Double p2 = (Double) f2.get("price");
                    return p1.compareTo(p2);
                }
            };
        }
        else if ("dep_time".equals(sortBy)) {
            comparator = new Comparator<Map<String, Object>>() {
                public int compare(Map<String, Object> f1, Map<String, Object> f2) {
                    Timestamp t1 = (Timestamp) f1.get("dep_time");
                    Timestamp t2 = (Timestamp) f2.get("dep_time");
                    return t1.compareTo(t2);
                }
            };
        }
        else if ("arr_time".equals(sortBy)) {
            comparator = new Comparator<Map<String, Object>>() {
                public int compare(Map<String, Object> f1, Map<String, Object> f2) {
                    Timestamp a1 = (Timestamp) f1.get("arr_time");
                    Timestamp a2 = (Timestamp) f2.get("arr_time");
                    return a1.compareTo(a2);
                }
            };
        }
        else if ("duration".equals(sortBy)) {
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
        
        if (comparator != null) {
            if (departureFlights != null) {
                Collections.sort(departureFlights, comparator);
            }
            if (returnFlights != null) {
                Collections.sort(returnFlights, comparator);
            }
        }
        

        boolean hasDepartures = departureFlights != null && !departureFlights.isEmpty();
        boolean hasReturns = returnFlights != null && !returnFlights.isEmpty();

        SimpleDateFormat formatter = new SimpleDateFormat("EEE, MMM dd, yyyy, hh:mm a");

        
    %>

    <% if (hasDepartures) { %>
        <h3>Departures</h3>
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
                    <th>Flight Duration</th>
                    <th>Type</th>
                    <th>Aircraft</th>
                </tr>
            </thead>
            <tbody>
            <% for (Map<String, Object> flight : departureFlights) { 
                
                // making "duration_minutes" more readable

                Integer duration = (Integer) flight.get("duration_minutes");
                String durationDisplay = "";
                if (duration != null) {
                    int hours = duration / 60;
                    int minutes = duration % 60;
                    if (hours > 0) {
                        durationDisplay += hours + " h ";
                    }
                    durationDisplay += minutes + " min";
                } 
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
                    <td><%= flight.get("flight_type") %></td>
                    <td><%= flight.get("aircraft_id") %></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>

    <% if (hasReturns) { %>
        <h3>Return Flights</h3>
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
                    <th>Flight Duration</th>
                    <th>Type</th>
                    <th>Aircraft</th>
                </tr>
            </thead>
            <tbody>
            <% for (Map<String, Object> flight : returnFlights) {
                
                // making "duration_minutes" more readable

                Integer duration = (Integer) flight.get("duration_minutes");
                String durationDisplay = "";
                if (duration != null) {
                    int hours = duration / 60;
                    int minutes = duration % 60;
                    if (hours > 0) {
                        durationDisplay += hours + " h ";
                    }
                    durationDisplay += minutes + " min";
                }     
            
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
                    <td><%= flight.get("flight_type") %></td>
                    <td><%= flight.get("aircraft_id") %></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>

    <%
    
    %>


    <% if (!hasDepartures && !hasReturns) { %>
        <p>No flights found.</p>
    <% } %>

    </div>


    </body>
    </html>
