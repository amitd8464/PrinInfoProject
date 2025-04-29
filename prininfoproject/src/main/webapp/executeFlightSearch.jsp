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

        StringBuilder sql = new StringBuilder("SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ?");
        if (isFlexible) {
            sql.append(" AND DATE(dep_time) BETWEEN DATE_SUB(?, INTERVAL 3 DAY) AND DATE_ADD(?, INTERVAL 3 DAY)");
        } else {
            sql.append(" AND DATE(dep_time) = ?");
        }

        PreparedStatement stmt = conn.prepareStatement(sql.toString());

        int i = 1;
        stmt.setString(i++, depAirport);
        stmt.setString(i++, destAirport);
        stmt.setString(i++, depDate);
        if (isFlexible) {
            stmt.setString(i++, depDate);  // 4th param if flexible
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
            flight.put("price", rs.getDouble("price"));
            flight.put("duration_minutes", rs.getInt("duration_minutes"));
            departureFlights.add(flight);
        }

        // Store in session
        session.removeAttribute("departure_results");
        session.setAttribute("departure_results", departureFlights);
        

        // Next, we will query for returning flights if trip_type=="roundtrip"

        if ("roundtrip".equalsIgnoreCase(tripType)){
            sql = new StringBuilder("SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ?");
            if (isFlexible) {
                sql.append(" AND DATE(dep_time) BETWEEN DATE_SUB(?, INTERVAL 3 DAY) AND DATE_ADD(?, INTERVAL 3 DAY)");
            } else {
                sql.append(" AND DATE(dep_time) = ?");
            }

            stmt = conn.prepareStatement(sql.toString());

            i = 1;
            stmt.setString(i++, destAirport);
            stmt.setString(i++, depAirport);
            stmt.setString(i++, returnDate);
            if (isFlexible) {
                stmt.setString(i++, returnDate);  // 4th param if flexible
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
                flight.put("price", rs.getDouble("price"));
                flight.put("duration_minutes", rs.getInt("duration_minutes"));
                returnFlights.add(flight);
            }

            // Store in session
            session.removeAttribute("departure_results");
            session.removeAttribute("return_results");
            
            session.setAttribute("departure_results", departureFlights);
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
