<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<html><head><title> 수강신청 입력 </title></head>
<body>

<%
	request.setCharacterEncoding("UTF-8");

	String mode = request.getParameter("mode");
	String id = request.getParameter("id");
	int to_day = 0;
	
	if(mode.equals("false")){
		
		//request.setCharacterEncoding("UTF-8");
		//response.setContentType("text/html;charset=UTF-8");
	
		String c_name = request.getParameter("lec_name");
		String c_unit = request.getParameter("lec_unit");
		int unit = Integer.parseInt(c_unit);
		String c_loc = request.getParameter("lec_loc");
		String c_max = request.getParameter("lec_max");
		int max = Integer.parseInt(c_max);

		String[] c_day = request.getParameterValues("lec_day");
		String day = null;
		
		if(c_day == null || c_day.length > 2){
		%>
			<script>	
				alert("요일을 다시 선택해주세요.");
				location.href="insert.jsp";
			</script>
		<%
		}
		else{
			for(int i=0; i<c_day.length; i++){
				if(c_day[i].equals("월"))
					day += "1";
				else if(c_day[i].equals("화"))
					day += "2";
				else if(c_day[i].equals("수"))
					day += "3";
				else if(c_day[i].equals("목"))
					day += "4";			
				else if(c_day[i].equals("금"))
					day += "5";
			}
			if(c_day.length == 1)
				day = day.substring(4,5);
			else
				day = day.substring(4,6);
			to_day = Integer.parseInt(day);
		}
		
		int sh, sm, eh, em;
		sh = Integer.parseInt(request.getParameter("lec_st_hh")); sm = Integer.parseInt(request.getParameter("lec_st_mm"));
		eh = Integer.parseInt(request.getParameter("lec_et_hh")); em = Integer.parseInt(request.getParameter("lec_et_mm"));

		Connection myConn = null;    String	result = null;	
		String dburl  = "jdbc:oracle:thin:@localhost:1521:orcl";
		String user="db01";   String passwd="ss2";
		String dbdriver = "oracle.jdbc.driver.OracleDriver";    
		Statement stmt = null, stmt1 = null; ResultSet rs = null, rs1 = null;
		CallableStatement cstmt = null, cstmt1 = null;

		PreparedStatement pstmt = null, pstmt1 = null;
		String sql = null;
		Boolean check = false;

		int c_id_no = 0;

		try{
			Class.forName(dbdriver);
	  	    myConn =  DriverManager.getConnection (dburl, user, passwd);
	  	    stmt = myConn.createStatement();

	  	    sql = "select c_id, c_id_no from course where c_name = '" + c_name+"'";
	  	    rs = stmt.executeQuery(sql);

	  	    if(rs != null) {
	  	    	String c_id = null;
	  	    	while(rs.next()){
	  	    		c_id = rs.getString("c_id");
	  	    		check = true;
	  	    		c_id_no = Integer.parseInt(rs.getString("c_id_no"));
	  	    	}

	  	    	if(check == false){
	  	    		String cc_id = null; int n_id;
	  	    		stmt1 = myConn.createStatement();
	  	    		sql = "select c_id from course";
	  	    		rs1 = stmt1.executeQuery(sql);
	  	    		while(rs1.next())
		  	    		c_id = rs1.getString("c_id");
		  	    	cc_id = c_id.substring(1); n_id = Integer.parseInt(cc_id) + 1; out.print(n_id);
	  	    		c_id_no = 0; c_id = "C" + n_id;
	  	    		out.print(c_id + " " + c_id_no);
	  	    	}

  	    		sql = "insert into course values(?,?,?,?)";
  	    		pstmt = myConn.prepareStatement(sql);
  	    		pstmt.setString(1, c_id); 
  	    		pstmt.setInt(2, c_id_no+1);
  	    		pstmt.setString(3, c_name); 
  	    		pstmt.setInt(4, unit);

  	    		int nSemester = 0, nYear;
		  	    cstmt = myConn.prepareCall("{? = call Date2EnrollSemester(SYSDATE)}");
		  	    cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
		  	    cstmt.execute();
		  	    nSemester = cstmt.getInt(1);

		  	    cstmt = myConn.prepareCall("{? = call Date2EnrollYear(SYSDATE)}");
		  	    cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
		  	    cstmt.execute();
		  	    nYear = cstmt.getInt(1);


  	    		sql = "insert into teach values(?,?,?,?,?,?,?,?,?,?,?,?)";
  	    		pstmt1 = myConn.prepareStatement(sql);
  	    		pstmt1.setString(1, id);		pstmt1.setString(2, c_id);
  	    		pstmt1.setInt(3, c_id_no+1);	pstmt1.setInt(4, nYear);
  	    		pstmt1.setInt(5, nSemester);	pstmt1.setInt(6, to_day);
  	    		pstmt1.setInt(7, sh); 			pstmt1.setInt(8, sm);
  	    		pstmt1.setInt(9, eh);			pstmt1.setInt(10,em);
  	    		pstmt1.setString(11, c_loc);	pstmt1.setInt(12, max);
  	    		

				out.print("semester : " + nSemester + " nyear : " + nYear);

  	    		pstmt.executeUpdate();
  	    		pstmt1.executeUpdate();
%>
				<script>	
					alert("추가되었습니다.");
					location.href="insert.jsp";
				</script>
<%
	  	    }

		} catch(SQLException ex) {
		    System.err.println("SQLException: " + ex.getMessage());
	    }finally {
		    if (pstmt != null) 
	            try { 
	            	pstmt.close();
	            	pstmt1.close();
	            	cstmt.close();
	            	
	            }catch(SQLException ex) { 
	            	out.print("error");
	            }
	        if(stmt != null){
	        	try{
	        		stmt.close();
	        	}catch(SQLException ex) { 
	            	out.print("error");
	            }
	        }
	        myConn.close();
	    }
	}
	else{
		String s_id = (String)session.getAttribute("user");
		String c_id = request.getParameter("c_id");
		int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));

		Connection myConn = null;    String	result = null;	
		String dburl  = "jdbc:oracle:thin:@localhost:1521:orcl";
		String user="db01";   String passwd="ss2";
		String dbdriver = "oracle.jdbc.driver.OracleDriver";    

		try {
			Class.forName(dbdriver);
	  	        myConn =  DriverManager.getConnection (dburl, user, passwd);
	    } catch(SQLException ex) {
		     System.err.println("SQLException: " + ex.getMessage());
	    }
		
	    CallableStatement cstmt = myConn.prepareCall("{call InsertEnroll(?,?,?,?)}");	
		cstmt.setString(1, s_id);
		cstmt.setString(2, c_id);
		cstmt.setInt(3,c_id_no);
		cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);	
		
		try {
			cstmt.execute();
			result = cstmt.getString(4);
		%>
			<script>	
				alert("<%=result%>");
				location.href="insert.jsp";
			</script>
		<%		
		} catch(SQLException ex) {		
			 System.err.println("SQLException: " + ex.getMessage());
		}
		finally {
		    if (cstmt != null) 
	            try { myConn.commit(); cstmt.close();  myConn.close(); }
	 	      catch(SQLException ex) { }
	    }
}
%>
</form></body></html>
