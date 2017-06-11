<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<style type="text/css">
	* {
		font-family: ppi;
	}
</style>
<html>
<head>
	<title>수강신청 사용자 정보 수정</title>
	<link rel='stylesheet' href='./dbDesign.css' />
</head>
<body>
<%@ include file="top.jsp" %>
<%
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	Class.forName(dbdriver);
	Connection myConn = null;

	//minji 
	//String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String dburl = "jdbc:oracle:thin:@localhost:1521:XE";	
	String user = "db01";
	String passwd = "ss2";

	Statement stmt = null;	Statement p_stmt = null;
	String mySQL = null;	String pSQL = null;
	ResultSet rs = null; 	ResultSet prs = null;

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
			stmt = myConn.createStatement(); p_stmt = myConn.createStatement(); 
			
			mySQL = "select s_addr, s_pwd from student where s_id='" + session_id + "'";
			rs = stmt.executeQuery(mySQL);
			
			pSQL = "select * from professor where p_id='"+session_id+"'";
			prs = p_stmt.executeQuery(pSQL);

		}catch(SQLException e){
		    out.println(e);
		    e.printStackTrace();
		}finally{
			if(rs != null && prs != null){
				if (rs.next()) {
					userAddr = rs.getString("s_addr");
					userPwd = rs.getString("s_pwd");
				}
				else if(prs.next()){
					userAddr = prs.getString("p_name");
					userPwd = prs.getString("p_pwd");
				}
				else {
%>
					<script> 
						alert("세션이 종료되었습니다. 다시 로그인 해주세요."); 
						location.href="login.jsp";  
					</script>  
<%
				}
			}	
%>
			<form action="update_verify.jsp?id=<%=session_id%>&mode=<%=stu_mode%>" method="post">
			<table align="center" id="update_table">
			<tr>
			  <td id="update_td">아이디</td>
			  <td><input id="update_id_in" type="text" name="id" size="15" value=<%=session_id%> disabled></td>
			</tr>
			<tr>  
			  <td id="update_td">비밀번호</td>
			  <td><input id="update_pw_in" type="password" name="password" size="10" value=<%=userPwd%>></td>
			</tr>
			<tr>
			  <td id="update_td">확인</td>
			  <td><input id="update_pw_in" type="password" name="passwordConfirm" size="10" ></td>
			</tr>
			
			<tr>
<%
			String up_name = "주소";
			if(stu_mode == false) up_name = "이름"; 
%>
			  <td id="update_td"><%=up_name%></td>
			  <td colspan="3"><input id="update_add_in" type="text" name="address" size="50" value="<%=userAddr%>"></td>
			</tr>
			<tr>
			  <td colspan="4" align="center">
			  <input id="update_btn" type="submit" value="수정 완료">
			  <input id="update_btn" type="reset" value="초기화">
			</tr>
			</table>
			</form>
<%	
			stmt.close(); p_stmt.close();
			myConn.close();
		}
	}
%>
</body>
</html>



