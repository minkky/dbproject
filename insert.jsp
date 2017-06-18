<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"  %>
<html>
	<head>
		<title>수강신청 입력</title>
		<link rel='stylesheet' href='./dbDesign.css' />
		<style type="text/css">
		#in_b, #in_b:visited {
			width: 80pt;
			font-size: 17pt;
			color: blue;	
		}
	</style>
	</head>
<body>
<%@ include file="top.jsp" %>
<% 	
	request.setCharacterEncoding("UTF-8");

	if (session_id==null) response.sendRedirect("login.jsp");  
	if(stu_mode == false){
%> 
<!-- professor login 시 -->
		<table width="70%" align="center" id="p_insert_table" style="font-size: 1.2em; margin-top: 8%;">
		<br>
			<tr style="background-color: #ff6347; color:white;">
				<th style="padding-top: 1%; padding-bottom: 1%;">과목명</th>
				<th>학점</th>
				<th>수업 요일</th>
				<th>수업 시간</th>
				<th>수업 장소</th>
				<th>인원</th>
			    <th>강의 추가</th>
			</tr>
			<tr></tr><tr></tr><tr></tr>
			<tr></tr><tr></tr><tr></tr>
			<tr>	</tr>
			<form action="insert_verify.jsp?mode=<%=stu_mode%>&id=<%=session_id%>" method="post">
				<td align="center"><input type="text" name="lec_name" id="in"></td>
				<td align="center"><input type="text" style="width:60px;" name="lec_unit" id="in" value="3"></td>
				<td align="center">
					<input type="checkbox" name="lec_day" id="in_c" value="월">월
					<input type="checkbox" name="lec_day" id="in_c" value="화">화 
					<input type="checkbox" name="lec_day" id="in_c" value="수">수 
					<input type="checkbox" name="lec_day" id="in_c" value="목">목 
					<input type="checkbox" name="lec_day" id="in_c" value="금">금
				</td>
				<td align="center">
						<input type="text" name="lec_st_hh" id="in" style="font-size: 1em; width:25pt;" value="08">
						:
						<input type="text" name="lec_st_mm" id="in" style="font-size: 1em; width:25pt;" value="00">
						-
						<input type="text" name="lec_et_hh" id="in" style="font-size: 1em; width:25pt;" value="10">
						:
						<input type="text" name="lec_et_mm" id="in" style="font-size: 1em; width:25pt;" value="00">
				</td> 
				<td align="center"><input type="text" name="lec_loc" id="in"></td>
				<td align="center"><input type="text" name="lec_max" style="width:65px;" id="in"></td>
				<td align="center"><input type="submit" value="추가" id="in_b" style="font-family: ppi;" value="1"></td>
			</form>
			</tr>
			</table>

<%
	}else{
%>
	<div align="center" id="insert_div" style="width:75%; overflow-y: auto; margin-top:2%; overflow-x: auto; margin-left: 12.5%; height: 80%;">
		<table align="center" width="100%" id="insert_table">
		<br>
		<tr>
			<th>과목번호</th>
			<th>분반</th>
			<th>학기</th>
			<th>과목명</th>
			<th>학점</th>
			<th>수업시간</th>
			<th>담당교수</th>
		    <th>수강신청</th>
		</tr>
<%
			Connection myConn = null;      Statement stmt = null;
			ResultSet myResultSet = null;   String mySQL = "";
			CallableStatement cstmt = null;
			String dburl  = "jdbc:oracle:thin:@localhost:1521:XE";
			String user="db01";     String passwd="ss2";
		    String dbdriver = "oracle.jdbc.driver.OracleDriver";

			try {
				Class.forName(dbdriver);
			    myConn =  DriverManager.getConnection (dburl, user, passwd);
			    stmt = myConn.createStatement();
			    
			    cstmt = myConn.prepareCall("{? = call getStrDay(?)}");
				cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);

		    } catch(SQLException ex) {
			     System.err.println("SQLException: " + ex.getMessage());
		    }
			mySQL = "SELECT c.c_id, c.c_id_no, c.c_name, c.c_unit, t.t_year, t.t_semester, t_day, t.t_startTime_hh, t.t_startTime_mm, t.t_endTime_hh, t.t_endTime_mm, p.p_name FROM course c, teach t, professor p WHERE p.p_id=t.p_id AND c.c_id = t.c_id AND c.c_id_no=t.c_id_no AND (c.c_id, c.c_id_no) not in (select c_id, c_id_no from enroll where s_id='" + session_id + "') order by c.c_id, c.c_id_no";
			try{
				myResultSet = stmt.executeQuery(mySQL);

				if (myResultSet != null) {
					while (myResultSet.next()) {	
						String c_id = myResultSet.getString("c_id");
						int c_id_no = myResultSet.getInt("c_id_no");			
						String c_name = myResultSet.getString("c_name");
						int c_unit = myResultSet.getInt("c_unit");			
						int t_year = myResultSet.getInt("t_year");
						int t_semester = myResultSet.getInt("t_semester");
						String p_name = myResultSet.getString("p_name");
						int t_st_h = myResultSet.getInt("t_startTime_hh"); int t_st_m = myResultSet.getInt("t_startTime_mm");
						int t_et_h = myResultSet.getInt("t_endTime_hh"); int t_et_m = myResultSet.getInt("t_endTime_mm");
						String t_st_mm = null, t_et_mm = null;
						t_st_mm = t_st_m + ""; t_et_mm = t_et_m + ""; 
						if(t_st_m == 0) t_st_mm = "00";
						if(t_et_m == 0) t_et_mm = "00";

						int int_c_day = myResultSet.getInt("t_day"); 
						cstmt.setInt(2, int_c_day);
						cstmt.execute();
						String str_c_day = cstmt.getString(1);

%>
					<tr>
					  <td align="center"><%= c_id %></td> 
					  <td align="center"><%= c_id_no %></td>
					  <td align="center"><%= t_year %>-<%=t_semester%></td> 
					  <td align="center"><%= c_name %></td>
					  <td align="center"><%= c_unit %></td>
					  <td align="center"><%=str_c_day%> <%= t_st_h %>:<%= t_st_mm %>-<%= t_et_h %>:<%= t_et_mm %></td>
					  <td align="center"><%= p_name %></td>
					  <td align="center"><a href="insert_verify.jsp?mode=<%=stu_mode%>&c_name='<%=c_name%>'&c_id=<%= c_id %>&c_id_no=<%= c_id_no %>" id="in_b">신청</a></td>
					</tr>
<%
					}
				%></table>
				</div><%	
				}
			}catch(SQLException e){
			    out.println(e);
			    e.printStackTrace();
			}

			stmt.close();  
			myConn.close();
			}
%>
</body></html>
