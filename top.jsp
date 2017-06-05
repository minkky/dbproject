<%@ page contentType="text/html; charset=UTF-8" %>
<%
	String session_id= (String)session.getAttribute("user");
	String log;
%>
<table width="75%" align="center" id="top_nav">
	<tr>
	<td align="center"><b><a href="update.jsp" id="top_a">사용자 정보 수정</b></td>
	<td align="center"><b><a href="insert.jsp" id="top_a">수강신청 입력</b></td>
	<td align="center"><b><a href="delete.jsp" id="top_a">수강신청 삭제</b></td>
	<td align="center"><b><a href="select.jsp" id="top_a">수강신청 조회</b></td>
<%	if (session_id!=null){
		//log="<a href=login.jsp id=top_a>로그인</a>";
	//else 
		log="<a href=logout.jsp id=top_a>로그아웃</a>";
%>
	<td align="center"><b><%=log%></b></td>
<%	}
%>
	</tr>
</table>