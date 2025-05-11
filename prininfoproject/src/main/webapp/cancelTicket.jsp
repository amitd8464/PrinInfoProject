<%@ page import="java.sql.*" %>
<%
    int ticket_number = Integer.parseInt(request.getParameter("ticket_number"));

    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

    // Step 1: Fetch reservation IDs before deleting the ticket
    int dep_res_id = -1;
    int ret_res_id = -1;

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

    // Step 2: Delete the ticket (ON DELETE CASCADE should trigger for reservations if IDs are valid)
    PreparedStatement deleteTicket = conn.prepareStatement(
        "DELETE FROM Ticket WHERE ticket_number = ?"
    );
    deleteTicket.setInt(1, ticket_number);
    deleteTicket.executeUpdate();
    deleteTicket.close();

    // Step 3: Fallback - clean up dangling reservations if FK was null or cascade didn’t apply
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

    // Done, redirect to view
    response.sendRedirect("customerReservations.jsp");
%>
