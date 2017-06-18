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
		if(c_name == null || c_name.equals("")){
		%>
			<script>	
				alert("과목명을 확인해주세요.");
				location.href="insert.jsp";
			</script>
		<%
		}
		String c_unit = request.getParameter("lec_unit");
		if(c_unit == null || c_unit.equals("")){
		%>
			<script>	
				alert("이수학점을 확인해주세요.");
				location.href="insert.jsp";
			</script>
		<%
		}
		
		int unit = 0;
		if(!c_unit.equals(""))
			unit = Integer.parseInt(c_unit);
		else 
			unit = 0;

		if(unit == 0){
		%>
			<script>	
				alert("이수학점을 확인해주세요.");
				location.href="insert.jsp";
			</script>
		<%
		}
		
		String c_loc = request.getParameter("lec_loc");
		if(c_loc == null || c_loc.equals("")){
		%>
			<script>	
				alert("강의실을 확인해주세요.");
				location.href="insert.jsp";
			</script>
		<%
		}
		

		String c_max = request.getParameter("lec_max");
		int max = 0;
		if(!c_max.equals(""))
			max = Integer.parseInt(c_max);
		else 
			max = 0;

		if(max == 0){
		%>
			<script>	
				alert("강의 인원을 확인해주세요.");
				location.href="insert.jsp";
			</script>
		<%
		}
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
		String dburl  = "jdbc:oracle:thin:@localhost:1521:XE";
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
	  	    	
	  	    	
	  	    	cstmt = myConn.prepareCall("{call InsertLecture(?,?,?,?,?,?,?,?,?,?,?,?,?)}");	
	  			cstmt.setString(1, c_name);
	  			cstmt.setString(2, c_unit);
	  	    	
	  	    	cstmt.setString(3, id);
	  			cstmt.setString(4, c_id);
				cstmt.setInt(5,c_id_no+1);
				cstmt.setInt(6, to_day);
				cstmt.setInt(7, sh); cstmt.setInt(8, sm);
				cstmt.setInt(9, eh); cstmt.setInt(10, em);
				cstmt.setString(11, c_loc); cstmt.setInt(12, max);
				
				cstmt.registerOutParameter(13, java.sql.Types.VARCHAR);
	  			cstmt.execute();
	  			
	  			result = cstmt.getString(13);
	  			%>
	  			<script>	
	  				alert("<%=result%>");
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
		String dburl  = "jdbc:oracle:thin:@localhost:1521:XE";
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
