<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
	<title>수강신청 시스템 로그인</title>
	<link rel='stylesheet' href='./dbDesign.css' />
</head>
<body>
<div id="login_title">
	수강신청 로그인(부제)
</div>
<table width="36%" align="center" id="login_table">
<form method="post" action="login_verify.jsp">
	<tr height="50pt;">
		<td id="login_tag" ><div align="center">아이디</div></td>
		<td><div align="center"><input type="text" name="userID" id="login_id_in"></div></td>
	</tr>

	<tr height="50pt;">
		<td id="login_tag" ><div align="center">패스워드</div></td>
		<td>
		<div align="center"><input type="password" name="userPassword" id="login_pw_in"></div></td>
	</tr> 
	<tr><td colspan=2><div align="center" id = "login_div_btn"> 
	<input TYPE="SUBMIT" NAME="Submit" VALUE="로그인" id="login_sbtn">
	<input TYPE="RESET" VALUE="취소" id="login_cbtn">
	</div></td></tr> </table>
</form>
</body>
</html>