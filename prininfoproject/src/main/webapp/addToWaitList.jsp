<%@ page import ="java.sql.*" %>
<%
    // DB connection setup

    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");
    
    Integer userIdObj = (Integer) session.getAttribute("user");
    int user_id = userIdObj != null ? userIdObj.intValue() : -1;

    int flight_number_toAdd = Integer.parseInt(request.getParameter("flight_number"));

    // Add the flight and user to WaitList

    PreparedStatement ps = conn.prepareStatement("INSERT IGNORE WaitList (customer_id, flight_number) VALUES (?, ?)");
    ps.setInt(1, user_id);
    ps.setInt(2, flight_number_toAdd);
    int result = ps.executeUpdate();

    // Redirect to reservations page:

    response.sendRedirect("customerReservations.jsp");

%>