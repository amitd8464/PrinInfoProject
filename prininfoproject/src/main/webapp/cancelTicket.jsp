<%@ page import="java.sql.*" %>
<%
    int ticket_number = Integer.parseInt(request.getParameter("ticket_number"));

    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

    Integer dep_res_id = -1;
    Integer ret_res_id = -1;

    // Step 1: Fetch reservation IDs
    PreparedStatement getResIds = conn.prepareStatement(
        "SELECT dep_reservation_id, return_reservation_id FROM Ticket WHERE ticket_number = ?"
    );
    getResIds.setInt(1, ticket_number);
    ResultSet rs = getResIds.executeQuery();
    if (rs.next()) {
        dep_res_id = rs.getInt("dep_reservation_id");
        ret_res_id = rs.getInt("return_reservation_id");
    }
    rs.close();
    getResIds.close();

    // Step 1.5: Get flight numbers from Reservation table
    int dep_flight_number = -1;
    int ret_flight_number = -1;

    PreparedStatement getFlightNumbers = conn.prepareStatement(
        "SELECT reservation_id, flight_number FROM Reservation WHERE reservation_id IN (?, ?)"
    );
    getFlightNumbers.setInt(1, dep_res_id);
    getFlightNumbers.setInt(2, ret_res_id);
    ResultSet rsFlights = getFlightNumbers.executeQuery();
    while (rsFlights.next()) {
        int resId = rsFlights.getInt("reservation_id");
        int flightNum = rsFlights.getInt("flight_number");

        if (resId == dep_res_id) dep_flight_number = flightNum;
        else if (resId == ret_res_id) ret_flight_number = flightNum;
    }
    rsFlights.close();
    getFlightNumbers.close();

    // Step 2: Get atCapacity status for both flights
    Boolean depWasAtCapacity = null;
    Boolean retWasAtCapacity = null;

    PreparedStatement ps = conn.prepareStatement(
        "SELECT r.reservation_id, f.atCapacity " +
        "FROM Reservation r JOIN Flight f ON r.flight_number = f.flight_number " +
        "WHERE r.reservation_id IN (?, ?)"
    );
    ps.setInt(1, dep_res_id);
    ps.setInt(2, ret_res_id);
    ResultSet rsCap = ps.executeQuery();
    while (rsCap.next()) {
        int resId = rsCap.getInt("reservation_id");
        boolean atCapacity = rsCap.getBoolean("atCapacity");

        if (resId == dep_res_id) depWasAtCapacity = atCapacity;
        else if (resId == ret_res_id) retWasAtCapacity = atCapacity;
    }
    rsCap.close();
    ps.close();

    // Step 3: Delete the ticket (should cascade delete reservations)
    PreparedStatement deleteTicket = conn.prepareStatement(
        "DELETE FROM Ticket WHERE ticket_number = ?"
    );
    deleteTicket.setInt(1, ticket_number);
    deleteTicket.executeUpdate();
    deleteTicket.close();

    // Step 4: Fallback cleanup in case cascade didn't remove reservations
    if (dep_res_id > 0) {
        PreparedStatement deleteDep = conn.prepareStatement(
            "DELETE FROM Reservation WHERE reservation_id = ?"
        );
        deleteDep.setInt(1, dep_res_id);
        deleteDep.executeUpdate();
        deleteDep.close();
    }

    if (ret_res_id > 0) {
        PreparedStatement deleteRet = conn.prepareStatement(
            "DELETE FROM Reservation WHERE reservation_id = ?"
        );
        deleteRet.setInt(1, ret_res_id);
        deleteRet.executeUpdate();
        deleteRet.close();
    }

    // Step 5: Notify users on waitlist for freed-up flights
    if (Boolean.TRUE.equals(depWasAtCapacity) && dep_flight_number > 0) {
        PreparedStatement notifyDep = conn.prepareStatement(
            "UPDATE WaitList SET notified = 1 WHERE flight_number = ? ORDER BY request_time ASC LIMIT 1"
        );
        notifyDep.setInt(1, dep_flight_number);
        notifyDep.executeUpdate();
        notifyDep.close();
    }

    if (Boolean.TRUE.equals(retWasAtCapacity) && ret_flight_number > 0) {
        PreparedStatement notifyRet = conn.prepareStatement(
            "UPDATE WaitList SET notified = 1 WHERE flight_number = ? ORDER BY request_time ASC LIMIT 1"
        );
        notifyRet.setInt(1, ret_flight_number);
        notifyRet.executeUpdate();
        notifyRet.close();
    }

    // Final step: redirect
    response.sendRedirect("customerReservations.jsp");
%>
