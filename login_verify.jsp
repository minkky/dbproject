<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
Connection myConn = null;
Statement stmt = null;
String mySQL = null;
String dburl = "jdbc:oracle:thin:@localhost:8090:orcl";
String user = "1004";
String passwd = "1004";
String dbdriver = "oracle.jdbc.driver.OracleDriver";
Class.forName(dbdriver);
myConn = DriverManager.getConnection(dburl, user, passwd);
stmt = myConn.createStatement();

String userID = request.getParameter("userID");
String userPassword = request.getParameter("userPassword");

mySQL = "select s_id from student where s_id='" + userID + "' and s_pwd='"+ userPassword +"'";

ResultSet rs = stmt.executeQuery(mySQL);

if (rs == null) {
	out.println("location='login.jsp';");
}
else {
	out.println("script type=\"text/javascript\">");
	out.println("alert('User or password incorrect');");
	out.println("location='main.jsp';");
	out.println("</script>");
}
stmt.close();
myConn.close();
%>