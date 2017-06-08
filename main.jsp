<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
	<title>데이터베이스를 활용한 수강신청 시스템 입니다.</title>
	<link rel='stylesheet' href='./dbDesign.css' />
</head>
<body>
	<%@ include file="/top.jsp" %>
	<table width="75%" align="center" height="68%" id="main_table">
		<% 
		String prof = "";
		if(stu_mode == false ) prof = "교수";
		if (session_id!= null) { %>
		<tr>
			<td align="center"><b><%=session_id%><%=prof%>님</b> 방문을환영합니다.</td> 
		</tr>
		<% } else { %>
		<tr>
			<td align="center">로그인 한 후 사용하세요.<br/><br/><br/>
			<a href="login.jsp" id="main_a">로그인</a>
			</td>
		</tr>
		<%
		}
		%>
	</table>
</body>
</html>