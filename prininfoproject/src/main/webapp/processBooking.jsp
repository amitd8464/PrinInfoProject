<%@ page import="java.sql.*, java.util.*" %>

<%
    Map<String, Object> depFlight = (Map<String, Object>) session.getAttribute("selected_departure_flight");
    Map<String, Object> retFlight = (Map<String, Object>) session.getAttribute("selected_return_flight");
    
    Integer userIdObj = (Integer) session.getAttribute("user");
    int userId = userIdObj != null ? userIdObj.intValue() : -1;    

    boolean waitlistDep = "true".equals(request.getParameter("waitlistDep"));
    boolean waitlistRet = "true".equals(request.getParameter("waitlistRet"));

    Connection con = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

        // INSERT departure flight
        if (depFlight != null) {
            String depFlightNum = depFlight.get("flight_number").toString();
            if (waitlistDep) {
                ps = con.prepareStatement("INSERT INTO Waitlist (customer_id, flight_number) VALUES (?, ?)");
                ps.setInt(1, userId);
                ps.setString(2, depFlightNum);
                ps.executeUpdate();
            } else {
                ps = con.prepareStatement("INSERT INTO Reservation (customer_id, flight_number) VALUES (?, ?)");
                ps.setInt(1, userId);
                ps.setString(2, depFlightNum);
                ps.executeUpdate();
            }
        }

        // INSERT return flight
        if (retFlight != null) {
            String retFlightNum = retFlight.get("flight_number").toString();
            if (waitlistRet) {
                ps = con.prepareStatement("INSERT INTO Waitlist (user_id, flight_number) VALUES (?, ?)");
                ps.setInt(1, userId);
                ps.setString(2, retFlightNum);
                ps.executeUpdate();
            } else {
                ps = con.prepareStatement("INSERT INTO Reservation (user_id, flight_number) VALUES (?, ?)");
                ps.setInt(1, userId);
                ps.setString(2, retFlightNum);
                ps.executeUpdate();
            }
        }

        response.sendRedirect("customerReservations.jsp");

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
