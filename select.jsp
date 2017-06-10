<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>수강신청 조회</title>
	<link rel='stylesheet' href='./dbDesign.css' />
</head>
<body>
	<%@ include file="/top.jsp" %>
<%
	if (session_id == null) 
		response.sendRedirect("login.jsp");
%>
	<br/><br/><br/>
	<table width="75%" align="center" id="select_table">
<% 
	if (stu_mode) {
%>
		<tr>
			<th>과목</th>
			<th>분반</th>
			<th>과목명</th>
			<th>교수</th>
			<th>시간</th>
			<th>장소</th>
			<th>학점</th>
		</tr>
<%
	}
	else {
%>
		<tr>
			<th>과목</th>
			<th>분반</th>
			<th>과목명</th>
			<th>시간</th>
			<th>장소</th>
			<th>수강 인원</th>
		</tr>
<%		
	}

	Calendar system_date = Calendar.getInstance();
	int current_year = system_date.get(Calendar.YEAR);
	int current_month = system_date.get(Calendar.MONTH);
	int next_semester = 0;
	String course_id;
	int course_id_no;
	String course_name = "";
	int course_unit = 0;
	String professor_id = "";
	String professor_name = "";
	String int_course_day = "";
	String str_course_day = "";
	String course_start_time = "";
	String course_end_time = "";
	String course_place = "";
	int max_student_num = 0;
	int current_student_num = 0;
	
	int total_course = 0;
	int total_unit = 0;
	
	Connection conn = null;		
	PreparedStatement pstmt = null;
	CallableStatement cstmt = null; 
	ResultSet rs = null;
	ResultSet sub_rs = null;
	String sql;
	String sub_sql;
	
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";        
	String user = "db01";                                       
	String passwd = "ss2";
	
	try {
		Class.forName("oracle.jdbc.driver.OracleDriver");            
		conn = DriverManager.getConnection(dburl, user, passwd);

		sql = "{call getNextSemester(?)}";
		cstmt = conn.prepareCall(sql);
		cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
		cstmt.execute();
		next_semester = cstmt.getInt(1);
		if (current_month >= 11) 
			current_year++;
		
		if (stu_mode) 
			sql = "SELECT c_id, c_id_no FROM enroll WHERE s_id = ? and e_year = ? and e_semester = ?";
		else
			sql = "SELECT c_id, c_id_no FROM teach WHERE p_id = ? and t_year = ? and t_semester = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, session_id);
		pstmt.setInt(2, current_year);
		pstmt.setInt(3, next_semester);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			course_id = rs.getString("c_id");
			course_id_no = rs.getInt("c_id_no");
			
			sub_sql = "SELECT c_name, c_unit FROM course WHERE c_id = ? and c_id_no = ?";
			pstmt = conn.prepareStatement(sub_sql);
			pstmt.setString(1, course_id);
			pstmt.setInt(2, course_id_no);
			sub_rs = pstmt.executeQuery();
			if (sub_rs.next()) {
				course_name = sub_rs.getString("c_name");
				course_unit = sub_rs.getInt("c_unit");
				total_unit = total_unit + course_unit;
				total_course++;
			}
			
			sub_sql = "SELECT p_id, t_day, t_startTime_HH, t_startTime_MM, t_endTime_HH, t_endTime_MM, t_where, t_max FROM teach WHERE c_id = ? and c_id_no = ?";
			pstmt = conn.prepareStatement(sub_sql);
			pstmt.setString(1, course_id);
			pstmt.setInt(2, course_id_no);
			sub_rs = pstmt.executeQuery();
			if (sub_rs.next()) {
				professor_id = sub_rs.getString("p_id");
				int_course_day = "" + sub_rs.getInt("t_day");
				course_start_time = "" + sub_rs.getInt("t_startTime_HH");
				course_start_time = course_start_time + " : " + sub_rs.getInt("t_startTime_MM");
				course_end_time = "" + sub_rs.getInt("t_endTime_HH");
				course_end_time = course_end_time + " : " + sub_rs.getInt("t_endTime_MM");
				course_place = sub_rs.getString("t_where");
				max_student_num = sub_rs.getInt("t_max");
			}
			
			sub_sql = "SELECT p_name FROM professor WHERE p_id = ?";
			pstmt = conn.prepareStatement(sub_sql);
			pstmt.setString(1, professor_id);
			sub_rs = pstmt.executeQuery();
			if (sub_rs.next())
				professor_name = sub_rs.getString("p_name");
			
			sub_sql = "SELECT s_id FROM enroll WHERE c_id = ? and c_id_no = ?";
			pstmt = conn.prepareStatement(sub_sql);
			pstmt.setString(1, course_id);
			pstmt.setInt(2, course_id_no);
			sub_rs = pstmt.executeQuery();
			if (sub_rs.next())
				current_student_num++;
			
			sql = "{? = call getStrDay(?)}";
			cstmt = conn.prepareCall(sql);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.setString(2, int_course_day);
			cstmt.execute();
			str_course_day = cstmt.getString(1);
			
			if (stu_mode) {
%>
		<tr>
			<td align="center"><%=course_id %></td>
			<td align="center"><%=course_id_no %></td>
			<td align="center"><%=course_name %></td>
			<td align="center"><%=professor_name %></td>
			<td align="center"><%=str_course_day %> <%=course_start_time %> - <%=course_end_time %></td>
			<td align="center"><%=course_place %></td>
			<td align="center"><%=course_unit %></td>
<%
			}
			else {
%>
		<tr>
			<td align="center"><%=course_id %></td>
			<td align="center"><%=course_id_no %></td>
			<td align="center"><%=course_name %></td>
			<td align="center"><%=str_course_day %> <%=course_start_time %> - <%=course_end_time %></td>
			<td align="center"><%=course_place %></td>
			<td align="center"><%=current_student_num %> / <%=max_student_num %></td>
<%
			}
		}
		rs.close();
		pstmt.close();
		conn.close();
	} 
	catch(SQLException ex) { 
		System.err.println("SQLException: " + ex.getMessage());
	}
	if (stu_mode) {
%>
		</tr>
	</table>
	<br/>
	<br/>
	<div width="75%" align="center">
		<p>현재까지 <%=total_course %>과목, 총 <%=total_unit %>학점 수강신청 했습니다 </p>
	</div>
<%
	}
	else
%>
	</table>
</body>
</html>