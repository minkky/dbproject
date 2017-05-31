<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<html>
<head>
<title></title>
<%
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	Class.forName(dbdriver);
	Connection myConn = null;

	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "db01";
	String passwd = "ss2";

	Statement stmt = null;
	String mySQL = null;
	ResultSet rs = null;

	String userID = request.getParameter("userID");
	String userPassword = request.getParameter("userPassword");

%>
</head>
<body>
<%
	try{
		myConn = DriverManager.getConnection(dburl, user, passwd);
		stmt = myConn.createStatement();
		mySQL = "select s_id from student where s_id='" + userID + "' and s_pwd='"+ userPassword +"'";
		rs = stmt.executeQuery(mySQL);
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<html>
<head>
<title></title>
<%
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	Class.forName(dbdriver);
	Connection myConn = null;

	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "db01";
	String passwd = "ss2";

	Statement stmt = null;
	String mySQL = null;
	ResultSet rs = null;

	String userID = request.getParameter("userID");
	String userPassword = request.getParameter("userPassword");
%>
</head>
<body>
<%
	try{
		myConn = DriverManager.getConnection(dburl, user, passwd);
		stmt = myConn.createStatement();
		mySQL = "select s_id from student where s_id='" + userID + "' and s_pwd='"+ userPassword +"'";
		rs = stmt.executeQuery(mySQL);

	}catch(SQLException e){
	    out.println(e);
	    e.printStackTrace();
	}finally{
		if (rs == null) {
			response.sendRedirect("login.jsp");
		}
		else {
			session.setAttribute("user", userID);
			response.sendRedirect("main.jsp");
		}
		stmt.close();
		myConn.close();
	}
%>
</body>
</html>
	}

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
</body>
</html>