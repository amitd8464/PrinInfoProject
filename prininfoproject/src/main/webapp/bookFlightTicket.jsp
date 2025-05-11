<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%
  int depIndex = request.getParameter("selected_departure_index") != null && !request.getParameter("selected_departure_index").isEmpty()
      ? Integer.parseInt(request.getParameter("selected_departure_index"))
      : -1;

    int retIndex = request.getParameter("selected_return_index") != null && !request.getParameter("selected_return_index").isEmpty()
                  ? Integer.parseInt(request.getParameter("selected_return_index"))
                  : -1;

    List<Map<String, Object>> depFlights = (List<Map<String, Object>>) session.getAttribute("raw_departure_results");
    List<Map<String, Object>> retFlights = (List<Map<String, Object>>) session.getAttribute("raw_return_flights");

      Map<String, Object> selectedDepFlight = (depFlights != null && depIndex >= 0 && depIndex < depFlights.size())
      ? depFlights.get(depIndex)
      : null;  
      Map<String, Object> selectedRetFlight = (retFlights != null && retIndex >= 0 && retIndex < retFlights.size())
      ? retFlights.get(retIndex)
      : null;  

      session.setAttribute("selected_departure_flight", selectedDepFlight);

      if (selectedRetFlight != null) {
          session.setAttribute("selected_return_flight", selectedRetFlight);
      } else {
          session.removeAttribute("selected_return_flight");
      }
      

    Map<String, Object> depFlight = (Map<String, Object>) session.getAttribute("selected_departure_flight");
    Map<String, Object> retFlight = (Map<String, Object>) session.getAttribute("selected_return_flight");


    if (depFlight == null) {
        %>
            <p style="color: red;">No departure flight selected. Please go back and choose one.</p>
            <a href="searchFlights.jsp">Back to Search</a>
        <%
            return;
    }

    double depPrice = (Double) depFlight.get("price");
    double retPrice = (retFlight != null) ? (Double) retFlight.get("price") : 0;
    String travelClass = (String) session.getAttribute("travel_class");
    double multiplier = "Business".equals(travelClass) ? 2.5 : "First".equals(travelClass) ? 5.0 : 1.0;
  
    double adjustedDepPrice = depPrice * multiplier;
    double adjustedRetPrice = retPrice * multiplier;
    double total = adjustedDepPrice + adjustedRetPrice;
    session.setAttribute("final_price", total);
    
    double bookingFee = total * 0.15;
    session.setAttribute("booking_fee", bookingFee);



    // Format timestamps
    java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("EEE, MMM dd, yyyy hh:mm a");
%>

<html>
<head>
    <title>Review Your Flights</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        .flight-box {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            /* margin-bottom: 30px; */
            margin-left: 20px;
            background-color: #fff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
        h2 {
            color: #1877F2;
            margin-left: 20px;
        }
        .label {
            font-weight: bold;
        }
        .travel-class-group {
            display: flex;
            gap: 12px;
            margin-top: 30px;
            margin-bottom: 50px;
            margin-left: 20px;
        }

        .travel-class-option input[type="radio"] {
            display: none;
        }

        .travel-class-option label {
            padding: 10px 20px;
            border: 1px solid #ccc;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            background-color: #f2f2f2;
            transition: all 0.2s ease;
        }

        .travel-class-option input[type="radio"]:checked + label {
            background-color: #1877F2;
            color: white;
            border-color: #1877F2;
            font-weight: bold;
        }

        .price-highlight {
            font-size: 30px;
            /* font-weight: bold; */
            color: #333;
            margin-top: 10px;
        }
        .price-info-text{
          font-size: 24px;
        }

    </style>
</head>
<body>
  <jsp:include page="navbar.jsp" />
  <div class="page-container">
    <div class="container">
      <h1>Flight Details</h1>
  
    <h2>Departure Flight</h2>
    <div class="flight-box">
        <p><span class="label">Flight #:</span> <%= depFlight.get("flight_number") %></p>
        <p><span class="label">Airline:</span> <%= depFlight.get("airline_id") %></p>
        <p><span class="label">From:</span> <%= depFlight.get("dep_airport") %> &nbsp; → &nbsp;
           <span class="label">To:</span> <%= depFlight.get("dest_airport") %></p>
        <p><span class="label">Departure Time:</span> <%= formatter.format((Timestamp)depFlight.get("dep_time")) %></p>
        <p><span class="label">Arrival Time:</span> <%= formatter.format((Timestamp)depFlight.get("arr_time")) %></p>
      
        <p class="price-highlight"><span class="label">Price:</span> <span class="depPrice">$<%= String.format("%.2f", adjustedDepPrice) %></span></p>
    </div>

<% if (retFlight != null) { %>
    <h2>Return Flight</h2>
    <div class="flight-box">
        <p><span class="label">Flight #:</span> <%= retFlight.get("flight_number") %></p>
        <p><span class="label">Airline:</span> <%= retFlight.get("airline_id") %></p>
        <p><span class="label">From:</span> <%= retFlight.get("dep_airport") %> &nbsp; → &nbsp;
           <span class="label">To:</span> <%= retFlight.get("dest_airport") %></p>
        <p><span class="label">Departure Time:</span> <%= formatter.format((Timestamp)retFlight.get("dep_time")) %></p>
        <p><span class="label">Arrival Time:</span> <%= formatter.format((Timestamp)retFlight.get("arr_time")) %></p>

        <% if (retFlight != null) { %>
          <p class="price-highlight"><span class="label">Price:</span> <span class="retPrice">$<%= String.format("%.2f", adjustedRetPrice) %></span></p>
        <% } %>  
    </div>
<% } %>

<h2>Select Travel Class</h2>
<form method="post" style="margin-bottom: 30px;">
  <div class="travel-class-group">
    <div class="travel-class-option">
      <input type="radio" name="travel_class" id="class_economy" value="Economy"
            <%= "Economy".equals(session.getAttribute("travel_class")) ? "checked" : "" %>
            onchange="updateClassSelection('Economy')">
      <label for="class_economy">Economy</label>
    </div>
    <div class="travel-class-option">
      <input type="radio" name="travel_class" id="class_business" value="Business"
            <%= "Business".equals(session.getAttribute("travel_class")) ? "checked" : "" %>
            onchange="updateClassSelection('Business')">
      <label for="class_business">Business</label>
    </div>
    <div class="travel-class-option">
      <input type="radio" name="travel_class" id="class_first" value="First"
            <%= "First".equals(session.getAttribute("travel_class")) ? "checked" : "" %>
            onchange="updateClassSelection('First')">
      <label for="class_first">First</label>
    </div>
  </div>
</form>


<div style="margin-left: 20px; margin-top: 10px; font-size: 34x;">
  <p class="price-info-text">Departure: <span class="depPrice">$<%= String.format("%.2f", adjustedDepPrice) %></span></p>
  <% if (retFlight != null) { %>
      <p class="price-info-text">Return: <span class="retPrice">$<%= String.format("%.2f", adjustedRetPrice) %></span></p>
  <% } %>
  <hr/>
  <p class="price-info-text" style="font-weight: bold;">Total: <span id="finalPrice">$<%= String.format("%.2f", total) %></span></p>
</div>



<!-- You can add a form here to confirm booking -->
<form action="confirmBooking.jsp" method="post">
    <%
    %>
    <button type="submit" style="padding: 14px 28px; font-size: 18px; background-color: #1877F2; color: white; border: none; border-radius: 10px; margin-left: 20px;">Confirm Booking</button>
</form>

<%
    
    if (depFlight != null && depFlight.get("atCapacity") != null) {
        session.setAttribute("depAtCapacity", Boolean.FALSE);
    }
    if (retFlight != null){
        session.setAttribute("retAtCapacity", Boolean.FALSE);
    }


%>

  <!-- console.log(<%= depFlight %>) -->

  <script>
    
    function updateClassSelection(travelClass) {
      fetch('setTravelClass.jsp', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `travel_class=${travelClass}`
      })
      .then(res => res.json())
      .then(data => {
        // Update all depPrice elements
        Array.from(document.getElementsByClassName("depPrice")).forEach(el => {
          el.textContent = `$${parseFloat(data.adjustedDep).toFixed(2)}`;
        });

        // Update retPrice elements if they exist
        Array.from(document.getElementsByClassName("retPrice")).forEach(el => {
          el.textContent = `$${parseFloat(data.adjustedRet).toFixed(2)}`;
        });

        // Update finalPrice
        document.getElementById("finalPrice").textContent = `$${parseFloat(data.total).toFixed(2)}`;
      })
      .catch(() => alert("Failed to update travel class prices."));
    }
  
  </script>
    </div>
  </div>
</body>


</html>
