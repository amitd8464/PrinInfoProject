<%@ page import="java.sql.*" %>
<%
    Integer user_id = (Integer) session.getAttribute("user");
    int flight_number = Integer.parseInt(request.getParameter("flight_number"));

    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

    PreparedStatement ps = conn.prepareStatement(
        "DELETE FROM WaitList WHERE customer_id = ? AND flight_number = ?"
    );
    ps.setInt(1, user_id);
    ps.setInt(2, flight_number);
    ps.executeUpdate();
    ps.close();
    conn.close();

    // Redirect back to booking
    response.sendRedirect("bookFlightTicket.jsp");
%>
