<%@ page import="javax.servlet.http.*,javax.servlet.*,java.util.*" %>
<%@ page contentType="application/json" %>

<%
    String travelClass = request.getParameter("travel_class");
    session.setAttribute("travel_class", travelClass);

    Map<String, Object> depFlight = (Map<String, Object>) session.getAttribute("selected_departure_flight");
    Map<String, Object> retFlight = (Map<String, Object>) session.getAttribute("selected_return_flight");

    double depPrice = (depFlight != null) ? (Double) depFlight.get("price") : 0;
    double retPrice = (retFlight != null) ? (Double) retFlight.get("price") : 0;

    double multiplier = "Business".equals(travelClass) ? 2.5 : "First".equals(travelClass) ? 5.0 : 1.0;

    double adjustedDep = depPrice * multiplier;
    double adjustedRet = retFlight != null ? retPrice * multiplier : 0;
    double total = adjustedDep + adjustedRet;

    session.setAttribute("final_price", total);

    out.print("{");
    out.print("\"adjustedDep\": " + String.format("%.2f", adjustedDep) + ",");
    out.print("\"adjustedRet\": " + String.format("%.2f", adjustedRet) + ",");
    out.print("\"total\": " + String.format("%.2f", total));
    out.print("}");
%>
