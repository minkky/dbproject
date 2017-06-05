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
	//String id = null, pw = null;

	Statement stmt = null;
	String mySQL = null;
	ResultSet rs = null;

	String userID = request.getParameter("userID");
	String userPassword = request.getParameter("userPassword");
	session.setAttribute("user", userID);
%>
</head>
<body>
<%
	try{
		myConn = DriverManager.getConnection(dburl, user, passwd);
		stmt = myConn.createStatement();
		mySQL = "select s_id, s_pwd from student where s_id='" + userID + "' and s_pwd='"+ userPassword +"'";
		rs = stmt.executeQuery(mySQL);

	}catch(SQLException e){
	    out.println(e);
	    e.printStackTrace();
	}finally{

		if (rs.next()) {
%>
			<script> 
				alert("로그인 성공!"); 
				location.href="main.jsp";  
			</script>
<%
		}
		else {
%>
			<script> 
				alert("아이디/패스워드를 확인하세요."); 
				location.href="login.jsp";  
			</script>  
<%
		}	
		stmt.close();
		myConn.close();
	}
%>
</body>
</html>