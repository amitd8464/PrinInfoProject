<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.sql.*" %>
<%
HttpSession s = request.getSession(false);
if (s == null || !"Rep".equals(s.getAttribute("role"))) {
    response.sendRedirect("login.jsp"); return;
}
Class.forName("com.mysql.jdbc.Driver");
try (Connection con = DriverManager.getConnection(
      "jdbc:mysql://localhost:3306/Project","root","");
     Statement st = con.createStatement()) {

/* handle submission */
String ans = request.getParameter("answerText");
String qid = request.getParameter("questionId");
if (ans != null && qid != null) {
    ResultSet ru = st.executeQuery(
      "SELECT user_id FROM User WHERE username='"+s.getAttribute("user")+"'");
    ru.next(); int repId = ru.getInt(1); ru.close();
    st.executeUpdate(
      "INSERT INTO Answer(question_id,rep_id,response) "+
      "VALUES("+Integer.parseInt(qid)+","+repId+",'"+ans+"')");
    out.println("<p style='color:green;'>Answered question "+qid+".</p>");
}

/* list unanswered questions */
ResultSet qs = st.executeQuery(
  "SELECT Q.question_id,U.username,Q.message,Q.created_at "+
  "FROM Question Q LEFT JOIN Answer A ON Q.question_id=A.question_id "+
  "JOIN User U ON Q.customer_id=U.user_id WHERE A.answer_id IS NULL");

out.println("<h3>Unanswered Customer Questions</h3>");
out.println("<table border=1><tr><th>ID</th><th>User</th><th>Question</th>"+
            "<th>Time</th><th>Reply</th></tr>");
while (qs.next()) {
    int id = qs.getInt(1);
    out.println("<tr><td>"+id+"</td><td>"+qs.getString(2)+"</td><td>"+
                qs.getString(3)+"</td><td>"+qs.getTimestamp(4)+"</td><td>");
%>
<form method="post" style="display:inline;">
  <input type="hidden" name="questionId" value="<%= id %>">
  <input name="answerText" required>
  <button>Send</button>
</form>
</td></tr>
<%
}
out.println("</table>");
qs.close();
}
%>
<a href="representativeDashboard.jsp">← Back</a>