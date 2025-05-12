<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    List<Map<String, Object>> departureFlights = new ArrayList<Map<String, Object>>();
    List<Map<String, Object>> returnFlights    = new ArrayList<Map<String, Object>>();

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/prinInfo_project",
            "root", "");

        String tripType   = request.getParameter("trip_type");      // "oneway" or "roundtrip"
        String flexible   = request.getParameter("flexible");      // null or "true"
        String depAirport = request.getParameter("dep_airport");   // e.g. "JFK"
        String destAirport= request.getParameter("dest_airport");  // e.g. "LAX"
        String depDate    = request.getParameter("dep_date");      // "2025-04-23"
        String returnDate = request.getParameter("return_date");   // optional

        boolean isFlexible = "true".equalsIgnoreCase(flexible);

        // --- DEPARTURE query ---
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ?");
        if (isFlexible) {
            sql.append(" AND DATE(dep_time) BETWEEN ")
               .append("DATE_SUB(?, INTERVAL 3 DAY) AND DATE_ADD(?, INTERVAL 3 DAY)");
        } else {
            sql.append(" AND DATE(dep_time) = ?");
        }

        stmt = conn.prepareStatement(sql.toString());
        int idx = 1;
        stmt.setString(idx++, depAirport);
        stmt.setString(idx++, destAirport);
        stmt.setString(idx++, depDate);
        if (isFlexible) {
            stmt.setString(idx++, depDate);
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Map<String, Object> f = new HashMap<String, Object>();
            f.put("flight_number",   rs.getInt("flight_number"));
            f.put("airline_id",      rs.getString("airline_id"));
            f.put("dep_airport",     rs.getString("dep_airport"));
            f.put("dest_airport",    rs.getString("dest_airport"));
            f.put("dep_time",        rs.getTimestamp("dep_time"));
            f.put("arr_time",        rs.getTimestamp("arr_time"));
            f.put("flight_type",     rs.getString("flight_type"));
            f.put("aircraft_id",     rs.getString("aircraft_id"));
            f.put("price",           rs.getDouble("price"));
            f.put("duration_minutes",rs.getInt("duration_minutes"));
            f.put("atCapacity",rs.getInt("atCapacity"));
            departureFlights.add(f);
        }
        rs.close();
        stmt.close();

        // store departure results
        session.setAttribute("raw_departure_results", departureFlights);

        // clear any old return results if one-way
        if (!"roundtrip".equalsIgnoreCase(tripType)) {
            session.removeAttribute("raw_return_flights");
        }

        // --- RETURN query, only if round-trip ---
        if ("roundtrip".equalsIgnoreCase(tripType)) {
            StringBuilder retSql = new StringBuilder(
                "SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ?");
            if (isFlexible) {
                retSql.append(" AND DATE(dep_time) BETWEEN ")
                      .append("DATE_SUB(?, INTERVAL 3 DAY) AND DATE_ADD(?, INTERVAL 3 DAY)");
            } else {
                retSql.append(" AND DATE(dep_time) = ?");
            }

            stmt = conn.prepareStatement(retSql.toString());
            idx = 1;
            stmt.setString(idx++, destAirport);
            stmt.setString(idx++, depAirport);
            stmt.setString(idx++, returnDate);
            if (isFlexible) {
                stmt.setString(idx++, returnDate);
            }

            rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> f = new HashMap<String, Object>();
                f.put("flight_number",   rs.getInt("flight_number"));
                f.put("airline_id",      rs.getString("airline_id"));
                f.put("dep_airport",     rs.getString("dep_airport"));
                f.put("dest_airport",    rs.getString("dest_airport"));
                f.put("dep_time",        rs.getTimestamp("dep_time"));
                f.put("arr_time",        rs.getTimestamp("arr_time"));
                f.put("flight_type",     rs.getString("flight_type"));
                f.put("aircraft_id",     rs.getString("aircraft_id"));
                f.put("price",           rs.getDouble("price"));
                f.put("duration_minutes",rs.getInt("duration_minutes"));
                returnFlights.add(f);
            }
            rs.close();
            stmt.close();

            // store return results under the key searchFlights.jsp expects
            session.setAttribute("raw_return_flights", returnFlights);
        }

        // redirect back to your search page
        response.sendRedirect("searchFlights.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        // handle errors...
    } finally {
        try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
        try { if (conn  != null) conn.close();  } catch (Exception ignored) {}
    }
%>
