<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    Connection con = null;
    PreparedStatement ps = null;

    List<Map<String, Object>> departureFlights = new ArrayList<Map<String, Object>>();
    List<Map<String, Object>> returnFlights = new ArrayList<Map<String, Object>>();



    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

        String tripType = request.getParameter("trip_type");             // "oneway" or "roundtrip"
        String flexible = request.getParameter("flexible");             // null or "true"
        String depAirport = request.getParameter("dep_airport");        // e.g. "JFK"
        String destAirport = request.getParameter("dest_airport");      // e.g. "LAX"
        String depDate = request.getParameter("dep_date");              // "2025-04-23"
        String returnDate = request.getParameter("return_date");        // optional

        boolean isFlexible = "true".equalsIgnoreCase(flexible);

        // First, SQL query for departing flights

        String sql = "SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ?";

        if (isFlexible) {
            sql += " AND DATE(dep_time) BETWEEN DATE_SUB(?, INTERVAL 3 DAY) AND DATE_ADD(?, INTERVAL 3 DAY)";
        } else {
            sql += " AND DATE(dep_time) = ?";
        }

        if (tripType == "roundtrip"){
            sql += " AND DATE(dep_time) BETWEEN DATE_SUB(?, INTERVAL 3 DAY) AND DATE_ADD(?, INTERVAL 3 DAY)";
        }

        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, depAirport);
        stmt.setString(2, destAirport);
        if (isFlexible) {
            stmt.setString(3, depDate);
            stmt.setString(4, depDate);
        } else {
            stmt.setString(3, depDate);
        }

        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> flight = new HashMap<String, Object>();
            flight.put("flight_number", rs.getInt("flight_number"));
            flight.put("airline_id", rs.getString("airline_id"));
            flight.put("dep_airport", rs.getString("dep_airport"));
            flight.put("dest_airport", rs.getString("dest_airport"));
            flight.put("dep_time", rs.getTimestamp("dep_time"));
            flight.put("arr_time", rs.getTimestamp("arr_time"));
            flight.put("flight_type", rs.getString("flight_type"));
            flight.put("aircraft_id", rs.getString("aircraft_id"));
            departureFlights.add(flight);
        }

        // Store in session
        session.setAttribute("departure_results", departureFlights);
        

        // Next, we will query for returning flights if trip_type=="roundtrip"

        if (tripType=="roundtrip"){
            sql = "SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ?";

            if (isFlexible) {
                sql += " AND DATE(dep_time) BETWEEN DATE_SUB(?, INTERVAL 3 DAY) AND DATE_ADD(?, INTERVAL 3 DAY)";
            } else {
                sql += " AND DATE(dep_time) = ?";
            }

            sql += " AND DATE(dep_time) = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, destAirport);
            stmt.setString(2, depAirport);

            if (isFlexible) {
                stmt.setString(3, returnDate);
                stmt.setString(4, returnDate);
            } else {
                stmt.setString(3, returnDate);
            }
            
            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> flight = new HashMap<String, Object>();
                flight.put("flight_number", rs.getInt("flight_number"));
                flight.put("airline_id", rs.getString("airline_id"));
                flight.put("dep_airport", rs.getString("dep_airport"));
                flight.put("dest_airport", rs.getString("dest_airport"));
                flight.put("dep_time", rs.getTimestamp("dep_time"));
                flight.put("arr_time", rs.getTimestamp("arr_time"));
                flight.put("flight_type", rs.getString("flight_type"));
                flight.put("aircraft_id", rs.getString("aircraft_id"));
                returnFlights.add(flight);
            }

            // Store in session
            session.setAttribute("return_results", returnFlights);
        }

        
        response.sendRedirect("searchFlights.jsp");

    } catch (SQLException e) {
        e.printStackTrace();
        if (e.getErrorCode() == 1062) {
%>
            <script>
            alert('This username or email is already in use.');
            window.location.href = 'register.jsp';
            </script>
<%
        } else {
%>
            <script>
            alert('Database error occurred.');
            window.location.href = 'register.jsp';
            </script>
<%
        }
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
%>
        <script>
        alert('JDBC Driver not found.');
        window.location.href = 'register.jsp';
        </script>
<%
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (con != null) con.close(); } catch (Exception ignored) {}
    }
%>
