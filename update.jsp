<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>

<html>
<head>
<title>수강신청 사용자 정보 수정</title>
</head>
<body>
<%@ include file="top.jsp" %>
<%
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	Class.forName(dbdriver);
	Connection myConn = null;

	String dburl = "jdbc:oracle:thin:@localhost:1521:XE";
	String user = "db01";
	String passwd = "ss2";

	Statement stmt = null;
	String mySQL = null;
	ResultSet rs = null;

	String userAddr = "";
	String userPwd = "";
%>
<%
	if (session_id == null) { %>
		<script> 
			alert("로그인 후 사용하세요."); 
			location.href="login.jsp";  
		</script>
<%
	} else { 
		try{
			myConn = DriverManager.getConnection(dburl, user, passwd);
			stmt = myConn.createStatement();
			mySQL = "select s_addr, s_pwd from student where s_id='" + session_id + "'";
			rs = stmt.executeQuery(mySQL);
		}catch(SQLException e){
		    out.println(e);
		    e.printStackTrace();
		}finally{
			if (rs.next()) {
				userAddr = rs.getString("s_addr");
				userPwd = rs.getString("s_pwd");
	%>
				<form action="update_verify.jsp?id=<%=session_id%>" method="post">
				<table align="center">
				<tr>
				  <td>ID</td>
				  <td><input type="text" name="id" size="15" value=<%=session_id%> disabled></td>
				  <td>비밀번호</td>
				  <td><input type="password" name="password" size="10" value=<%=userPwd%>></td>
				</tr>
				<tr>
				  <td>주소</td>
				  <td colspan="3"><input type="text" name="address" size="50" value="<%=userAddr%>"></td>
				</tr>
				<tr>
				  <td colspan="4" align="center">
				  <input type="submit" value="수정 완료">
				  </td>
				</tr>
				</table>
				</form>
	<%
			}
			else {
	%>
				<script> 
					alert("세션이 종료되었습니다. 다시 로그인 해주세요."); 
					location.href="login.jsp";  
				</script>  
	<%
			}	
			stmt.close();
			myConn.close();
		}
	}
%>
</body>
</html>



