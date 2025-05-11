<%@ page import ="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.SQLIntegrityConstraintViolationException" %>
<%
  Integer userIdObj = (Integer) session.getAttribute("user");
  int user_id = userIdObj != null ? userIdObj.intValue() : -1;    

  Boolean depAtCapacity = (Boolean) session.getAttribute("depAtCapacity");
  Boolean retAtCapacity = (Boolean) session.getAttribute("retAtCapacity");

  Map<String, Object> depFlight = (Map<String, Object>) session.getAttribute("selected_departure_flight");
  int dep_flight_number = (Integer) depFlight.get("flight_number");
  Object depTimeObj = depFlight.get("dep_time");
  java.sql.Date dep_date = null;

  if (depTimeObj instanceof Timestamp) {
      dep_date = new java.sql.Date(((Timestamp) depTimeObj).getTime());
  } else if (depTimeObj instanceof java.util.Date) {
      dep_date = new java.sql.Date(((java.util.Date) depTimeObj).getTime());
  } else if (depTimeObj instanceof String) {
      dep_date = java.sql.Date.valueOf(((String) depTimeObj).split(" ")[0]);
  }

  Map<String, Object> retFlight = (Map<String, Object>) session.getAttribute("selected_return_flight");
  Integer ret_flight_number = null;
  java.sql.Date ret_date = null;
  if (retFlight != null){
      ret_flight_number = (Integer) retFlight.get("flight_number");
      Object retTimeObj = retFlight.get("dep_time");

      if (retTimeObj instanceof Timestamp) {
          ret_date = new java.sql.Date(((Timestamp) retTimeObj).getTime());
      } else if (retTimeObj instanceof java.util.Date) {
          ret_date = new java.sql.Date(((java.util.Date) retTimeObj).getTime());
      } else if (retTimeObj instanceof String) {
          ret_date = java.sql.Date.valueOf(((String) retTimeObj).split(" ")[0]);
      }
  }

  String travel_class = (String) session.getAttribute("travel_class");

  if (Boolean.FALSE.equals(depAtCapacity) && (retAtCapacity == null || Boolean.FALSE.equals(retAtCapacity))) {
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prinInfo_project", "root", "");

    double final_price = (Double) session.getAttribute("final_price");
    Double bookingFeeObj = (Double) session.getAttribute("booking_fee");
    double booking_fee = (bookingFeeObj != null) ? bookingFeeObj : 0.0;

    int dep_reservation_id = -1;
    // Check for existing dep reservation
    PreparedStatement checkDep = conn.prepareStatement(
        "SELECT reservation_id FROM Reservation WHERE customer_id = ? AND flight_number = ? LIMIT 1"
    );
    checkDep.setInt(1, user_id);
    checkDep.setInt(2, dep_flight_number);
    ResultSet depExists = checkDep.executeQuery();
    if (depExists.next()) {
        dep_reservation_id = depExists.getInt("reservation_id");

        // Show alert and redirect
        %>
        <script>
          alert("You have already reserved a seat for this departure flight.");
          window.location.href = "customerReservations.jsp";
        </script>
        <%
        return;
    } else {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO Reservation (customer_id, flight_number, total_fare, booking_fee) VALUES (?, ?, ?, ?)",
            Statement.RETURN_GENERATED_KEYS
        );
        ps.setInt(1, user_id);
        ps.setInt(2, dep_flight_number);
        ps.setDouble(3, final_price);
        ps.setDouble(4, booking_fee);

        int affectedRows = ps.executeUpdate();
        if (affectedRows > 0) {
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) dep_reservation_id = rs.getInt(1);
            rs.close();
        }
        ps.close();
    }
    checkDep.close();

    int ret_reservation_id = -1;
    if (retFlight != null) {
        PreparedStatement checkRet = conn.prepareStatement(
            "SELECT reservation_id FROM Reservation WHERE customer_id = ? AND flight_number = ? LIMIT 1"
        );
        checkRet.setInt(1, user_id);
        checkRet.setInt(2, ret_flight_number);
        ResultSet retExists = checkRet.executeQuery();
        if (retExists.next()) {
            ret_reservation_id = retExists.getInt("reservation_id");
            %>
            <script>
              alert("You have already reserved a seat for this return flight.");
              window.location.href = "customerReservations.jsp";
            </script>
            <%
            return;
        } else {
            PreparedStatement psRet = conn.prepareStatement(
                "INSERT INTO Reservation (customer_id, flight_number, total_fare, booking_fee) VALUES (?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            psRet.setInt(1, user_id);
            psRet.setInt(2, ret_flight_number);
            psRet.setDouble(3, final_price);
            psRet.setDouble(4, booking_fee);

            int affectedRowsRet = psRet.executeUpdate();
            if (affectedRowsRet > 0) {
                ResultSet rsRet = psRet.getGeneratedKeys();
                if (rsRet.next()) ret_reservation_id = rsRet.getInt(1);
                rsRet.close();
            }
            psRet.close();
        }
        checkRet.close();
    }

    // Fetch seat numbers for each flight
    Integer dep_seat_number = null;
    Integer ret_seat_number = null;

    PreparedStatement psDep = conn.prepareStatement(
        "SELECT COUNT(*) FROM Ticket WHERE dep_flight_number = ?"
    );
    psDep.setInt(1, dep_flight_number);
    ResultSet rsDep = psDep.executeQuery();
    if (rsDep.next()) dep_seat_number = rsDep.getInt(1) + 1;
    rsDep.close();
    psDep.close();

    if (ret_flight_number != null) {
        PreparedStatement psRet = conn.prepareStatement(
            "SELECT COUNT(*) FROM Ticket WHERE ret_flight_number = ?"
        );
        psRet.setInt(1, ret_flight_number);
        ResultSet rsRet = psRet.executeQuery();
        if (rsRet.next()) ret_seat_number = rsRet.getInt(1) + 1;
        rsRet.close();
        psRet.close();
    }

    // Get user info
    String passenger_first_name = null;
    String passenger_last_name = null;
    PreparedStatement psUser = conn.prepareStatement("SELECT first_name, last_name FROM Users WHERE user_id = ?");
    psUser.setInt(1, user_id);
    ResultSet rsUser = psUser.executeQuery();
    if (rsUser.next()) {
        passenger_first_name = rsUser.getString("first_name");
        passenger_last_name = rsUser.getString("last_name");
    }
    rsUser.close();
    psUser.close();

    // Create Ticket

    // First check if the ticket a
    PreparedStatement psTicket = conn.prepareStatement(
        "INSERT INTO Ticket (" +
        "travel_class, departure_date, return_date, passenger_first_name, passenger_last_name, " +
        "dep_flight_number, ret_flight_number, passenger_id, dep_reservation_id, return_reservation_id, " +
        "dep_seat_number, ret_seat_number) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    );

    psTicket.setString(1, travel_class);
    psTicket.setDate(2, dep_date);
    psTicket.setDate(3, ret_date);
    psTicket.setString(4, passenger_first_name);
    psTicket.setString(5, passenger_last_name);
    psTicket.setInt(6, dep_flight_number);
    if (ret_flight_number != null) psTicket.setInt(7, ret_flight_number);
    else psTicket.setNull(7, java.sql.Types.INTEGER);
    psTicket.setInt(8, user_id);
    psTicket.setInt(9, dep_reservation_id);
    if (ret_reservation_id != -1) psTicket.setInt(10, ret_reservation_id);
    else psTicket.setNull(10, java.sql.Types.INTEGER);
    psTicket.setInt(11, dep_seat_number);
    if (ret_seat_number != null) psTicket.setInt(12, ret_seat_number);
    else psTicket.setNull(12, java.sql.Types.INTEGER);

    try {
      psTicket.executeUpdate();
    } catch (SQLIntegrityConstraintViolationException e) {
        // Ticket already exists, safely ignore
    } catch (SQLException e) {
        e.printStackTrace(); // Log unexpected SQL errors
    }
  
    psTicket.close();

    response.sendRedirect("customerReservations.jsp");
  }

  if (depAtCapacity) {
%>
<script>
  if (confirm("Your selected departure flight is full! Would you like to be placed on a waitlist?")) {
    window.location.href = "addToWaitList.jsp?flight_number=<%= dep_flight_number %>";
  } else {
    window.location.href = 'searchFlights.jsp';
  }
</script>
<% } %>

<% if (Boolean.TRUE.equals(retAtCapacity)) { %>
<script>
  if (confirm("Your selected return flight is full! Would you like to be placed on a waitlist?")) {
    window.location.href = "addToWaitList.jsp?flight_number=<%= ret_flight_number %>";
  } else {
    window.location.href = 'searchFlights.jsp';
  }
</script>
<% } %>
