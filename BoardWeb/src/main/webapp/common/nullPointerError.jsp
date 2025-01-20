<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기본 에러 화면</title>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<!-- 타이틀 제목 -->
<table width="100%" border="1" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" bgcolor="orange">
			<b>기본 에러 화면</b>
		</td>
	</tr>
</table>

<!-- 에러 메시지 출력 -->
<table width="100%" border="1" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center">
			<br><br><br><br><br>
			Message : ${exception.message}
			<br><br><br><br><br>
		</td>
	</tr>
</table>

</body>
</html>