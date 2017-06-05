<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>

<html>
<head>
<title>수강신청 사용자 정보 수정</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	Class.forName(dbdriver);
	Connection myConn = null;
	
	String dburl = "jdbc:oracle:thin:@localhost:1521:XE";
	String user = "db01";
	String passwd = "ss2";
	
	PreparedStatement pstmt = null;
	
	String formId = request.getParameter("id");
	String formPass = request.getParameter("password");
	String formAddr = request.getParameter("address");
	
	try{          
		myConn = DriverManager.getConnection(dburl, user, passwd);
		
		String sql = "UPDATE student SET s_pwd=?, s_addr=? WHERE s_id=?";        
		pstmt = myConn.prepareStatement(sql);
		
		pstmt.setString(1, formPass);
		pstmt.setString(2, formAddr);
		pstmt.setString(3, formId);
		
		pstmt.executeUpdate();
		%><script> 
			alert("성공적으로 수정했습니다."); 
			location.href="main.jsp";  
		</script><%
	}catch(SQLException ex){
		String sMessage="";
		if (ex.getErrorCode() == 20002)
			sMessage = "암호는 4자리 이상이어야합니다.";
		else if (ex.getErrorCode() == 20003)
			sMessage = "암호에 공란은 입력되지 않습니다.";
		else
			sMessage = "잠시 후 다시 시도하십시오.";
		out.println("<script>");
		out.println("alert('"+sMessage+"');");
		out.println("location.href='update.jsp';");
		out.println("</script>");
		out.flush();
	}finally{
		if(pstmt != null) try{pstmt.close();}catch(SQLException sqle){}
		if(myConn != null) try{myConn.close();}catch(SQLException sqle){}   
	}		
%>
</body>
</html>