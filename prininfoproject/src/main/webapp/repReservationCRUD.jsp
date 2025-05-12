<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.sql.*" %>
<%
HttpSession ses = request.getSession(false);
if (ses == null || !"Rep".equals(ses.getAttribute("role"))) {
    response.sendRedirect("login.jsp"); return;
}

String action = request.getParameter("action");   // book | edit
String cust   = request.getParameter("cust");     // customer username
String flight = request.getParameter("flight");   // flight number

Class.forName("com.mysql.jdbc.Driver");
try (Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/Project","root","")) {

con.setAutoCommit(false);
Statement st = con.createStatement();

/* ---------- BOOK ---------- */
if ("book".equals(action) && cust != null && flight != null) {
    String pFirst = request.getParameter("passFirst");
    // first step – show form
    if (pFirst == null) {
%>
<h3>Book Flight <%= flight %> for <%= cust %></h3>
<form method="post">
  <input type="hidden" name="action" value="book">
  <input type="hidden" name="cust"   value="<%= cust %>">
  <input type="hidden" name="flight" value="<%= flight %>">
  <label>Passenger First Name: <input name="passFirst" required></label><br>
  <label>Passenger Last  Name: <input name="passLast"  required></label><br>
  <label>ID Number: <input name="passId"   required></label><br>
  <label>Class:
    <select name="class">
      <option>Economy</option><option>Business</option><option>First</option>
    </select>
  </label><br>
  <label>Departure Date: <input type="date" name="depDate" required></label><br>
  <label>Seat (optional): <input name="seat"></label><br>
  <button type="submit">Submit</button>
</form>
<%
    } else {
        try {
            /* locate customer */
            ResultSet ru = st.executeQuery(
              "SELECT user_id FROM User WHERE username='" + cust + "'");
            if (!ru.next()) { out.println("Customer not found."); return; }
            int uid = ru.getInt(1); ru.close();

            /* create reservation */
            st.executeUpdate(
              "INSERT INTO Reservation(customer_id,total_fare,booking_fee) " +
              "VALUES("+uid+",0,0)", Statement.RETURN_GENERATED_KEYS);
            ResultSet g = st.getGeneratedKeys(); g.next();
            int resId = g.getInt(1); g.close();

            /* create ticket */
            String seat = request.getParameter("seat");
            String insertT =
              "INSERT INTO Ticket(reservation_id,flight_number,airline_id,"+
              "seat_number,travel_class,departure_date,"+
              "passenger_first_name,passenger_last_name,passenger_id_number) "+
              "VALUES("+resId+","+Integer.parseInt(flight)+","+
              "(SELECT airline_id FROM Flight WHERE flight_number="+flight+"),"+
              (seat==null||seat.isEmpty()?"NULL":"'"+seat+"'")+","+
              "'"+request.getParameter("class")+"','"+
              request.getParameter("depDate")+"','"+
              pFirst+"','"+request.getParameter("passLast")+"','"+
              request.getParameter("passId")+"')";
            st.executeUpdate(insertT);
            con.commit();
            out.println("<p style='color:green;'>Reservation created (ID "+
                        resId+").</p>");
        } catch (Exception e) {
            con.rollback();
            out.println("<p style='color:red;'>Error: "+e.getMessage()+"</p>");
        }
    }

/* ---------- EDIT (SEAT CHANGE) ---------- */
} else if ("edit".equals(action) && cust != null && flight != null) {
    String newSeat = request.getParameter("newSeat");
    if (newSeat == null) {  // show minimal edit form
%>
<h3>Edit Reservation – Flight <%= flight %>, Customer <%= cust %></h3>
<form method="post">
  <input type="hidden" name="action" value="edit">
  <input type="hidden" name="cust"   value="<%= cust %>">
  <input type="hidden" name="flight" value="<%= flight %>">
  <label>New Seat: <input name="newSeat" required></label>
  <button>Update</button>
</form>
<%
    } else {
        ResultSet ru = st.executeQuery(
          "SELECT user_id FROM User WHERE username='"+cust+"'");
        if (ru.next()) {
            int uid = ru.getInt(1); ru.close();
            int rows = st.executeUpdate(
              "UPDATE Ticket T JOIN Reservation R ON T.reservation_id=R.reservation_id "+
              "SET seat_number='"+newSeat+"' "+
              "WHERE R.customer_id="+uid+" AND T.flight_number="+Integer.parseInt(flight));
            out.println(rows>0 ? "Seat updated." : "Reservation not found.");
        } else out.println("Customer not found.");
    }
}
st.close();
}
%>
<a href="representativeDashboard.jsp">← Back</a>