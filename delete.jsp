<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<html>
	<head>
		<title>수강신청 취소</title>
		<link rel='stylesheet' href='./dbDesign.css' />
	</head>
	<style type="text/css">
		#in_b, #in_b:visited {
			width: 80pt;
			font-size: 17pt;
			color: blue;	
		}
	</style>
<body>
<%@ include file="top.jsp" %>
<%   
	if (session_id == null) 
		response.sendRedirect("login.jsp");
	
	Connection myConn = null;      
	Statement stmt = null;
	CallableStatement cstmt = null;
	String mySQL = "";
	ResultSet myResultSet = null;
	String dburl  = "jdbc:oracle:thin:@localhost:1521:XE";
	String user="db01";     String passwd="ss2";
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String str_course_day = "";

	try {
		Class.forName(dbdriver);
        myConn =  DriverManager.getConnection (dburl, user, passwd);
		stmt = myConn.createStatement();	
	} catch(SQLException ex) {
    	System.err.println("SQLException: " + ex.getMessage());
	}
	
	if (stu_mode == false) {		
%> <!-- professor login 시 -->
		<table width="75%" align="center" id="delete_table">
		<br>
		<tr>
			<th>과목번호</th>
			<th>분반</th>
			<th>과목명</th>
			<th>강의시간</th>
		    <th>강의장소</th>
		    <th>최대 수강인원</th>
		    <th>강의 삭제</th>
		</tr>
<%	
			mySQL = "select t.c_id, t.c_id_no, c.c_name, t.t_day, t.t_startTime_HH, t.t_startTime_MM, t.t_endTime_HH, t.t_endTime_MM, t.t_where, t.t_max from course c, teach t, professor p where p.p_id='"+ session_id +"' and t.p_id = p.p_id and c.c_id = t.c_id and t.c_id_no = c.c_id_no";
			try{
				myResultSet = stmt.executeQuery(mySQL);

				if (myResultSet != null) {
					while (myResultSet.next()) {	
						String c_id = myResultSet.getString("c_id");
						int c_id_no = myResultSet.getInt("c_id_no");			
						String c_name = myResultSet.getString("c_name");
						int t_day = myResultSet.getInt("t_day");
						int t_startTime_HH = myResultSet.getInt("t_startTime_HH");
						int t_startTime_MM = myResultSet.getInt("t_startTime_MM");
						int t_endTime_HH = myResultSet.getInt("t_endTime_HH");
						int t_endTime_MM = myResultSet.getInt("t_endTime_MM");
						String t_where = myResultSet.getString("t_where");
						int t_max = myResultSet.getInt("t_max");
						
						mySQL = "{? = call getStrDay(?)}";
						cstmt = myConn.prepareCall(mySQL);
						cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
						cstmt.setString(2, ""+t_day);
						cstmt.execute();
						str_course_day = cstmt.getString(1);
						
						String str_st_m = null, str_et_m = null;
						str_st_m = t_startTime_MM + "";
						if(t_startTime_MM == 0) str_st_m = "00";
						str_et_m = t_endTime_MM + "";
						if(t_endTime_MM == 0) str_et_m = "00";
%>
					<tr>
					  <td align="center"><%= c_id %></td>
					  <td align="center"><%= c_id_no %></td>
					  <td align="center"><%= c_name %></td>
					  <td align="center"><%=str_course_day %> <%= t_startTime_HH %> : <%= str_st_m %> ~ <%= t_endTime_HH %> : <%= str_et_m %></td>
					  <td align="center"><%= t_where %></td>
					  <td align="center"><%= t_max %>명</td>
					  <td align="center"><a id="in_b" href="delete_verify.jsp?c_id=<%= c_id %>&c_id_no=<%= c_id_no %>">삭제</a></td>
					</tr>
<%
					}
				}
			}catch(SQLException e){
			    out.println(e);
			    e.printStackTrace();
			}
			stmt.close();  
			myConn.close();
	} 
	else {
%>
		<table width="75%" align="center" id="delete_table">
		<br>
		<tr>
			<th>과목번호</th>
			<th>분반</th>
			<th>과목명</th>
			<th>강의시간</th>
		    <th>강의장소</th>
			<th>학점</th>
		    <th>수강취소</th>
		</tr>
<%
			
			mySQL = "select e.c_id, e.c_id_no, c.c_name, c.c_unit, t.t_day, t.t_startTime_HH, t.t_startTime_MM, t.t_endTime_HH, t.t_endTime_MM, t.t_where from course c, enroll e, teach t where e.s_id='"+ session_id +"' and e.c_id = c.c_id and e.c_id_no = c.c_id_no and t.c_id = c.c_id and t.c_id_no = c.c_id_no";
			try{
				myResultSet = stmt.executeQuery(mySQL);

				if (myResultSet != null) {
					while (myResultSet.next()) {	
						String c_id = myResultSet.getString("c_id");
						int c_id_no = myResultSet.getInt("c_id_no");			
						String c_name = myResultSet.getString("c_name");
						int c_unit = myResultSet.getInt("c_unit");
						int t_day = myResultSet.getInt("t_day");
						int t_startTime_HH = myResultSet.getInt("t_startTime_HH");
						int t_startTime_MM = myResultSet.getInt("t_startTime_MM");
						int t_endTime_HH = myResultSet.getInt("t_endTime_HH");
						int t_endTime_MM = myResultSet.getInt("t_endTime_MM");
						String t_where = myResultSet.getString("t_where");
						
						mySQL = "{? = call getStrDay(?)}";
						cstmt = myConn.prepareCall(mySQL);
						cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
						cstmt.setString(2, ""+t_day);
						cstmt.execute();
						str_course_day = cstmt.getString(1);
						
						String str_st_m = null, str_et_m = null;
						str_st_m = t_startTime_MM + "";
						if(t_startTime_MM == 0) str_st_m = "00";
						str_et_m = t_endTime_MM + "";
						if(t_endTime_MM == 0) str_et_m = "00";
%>				
					<tr>
					  <td align="center"><%= c_id %></td> <td align="center"><%= c_id_no %></td> 
					  <td align="center"><%= c_name %></td>
					  <td align="center"><%=str_course_day %> <%= t_startTime_HH %> : <%= str_st_m %> ~ <%= t_endTime_HH %> : <%= str_et_m %></td>
					  <td align="center"><%= t_where %></td>
					  <td align="center"><%= c_unit %></td>
					  <td align="center"><a id="in_b" href="delete_verify.jsp?c_id=<%= c_id %>&c_id_no=<%= c_id_no %>">취소</a></td>
					</tr>
<%
					}
				}
			}catch(SQLException e){
			    out.println(e);
			    e.printStackTrace();
			}
			stmt.close();  
			myConn.close();
			}
%>
</table></body></html>
