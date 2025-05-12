<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
  <title>Representative Dashboard</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<h1>Representative Dashboard</h1>
<ul>
  <li><a href="repReservationCRUD.jsp">Reservation CRUD</a></li>
  <li><a href="repWaitingList.jsp">Waiting List</a></li>
  <li><a href="repAirportFlights.jsp">Airport Flights</a></li>
  <li><a href="repAdminCRUD.jsp">Manage Aircraft / Airport / Flights</a></li>
  <li><a href="repAnswerQuestions.jsp">Answer Customer Questions</a></li>
</ul>
<form action="logout.jsp" method="post"><button>Log out</button></form>
</body>
</html>
