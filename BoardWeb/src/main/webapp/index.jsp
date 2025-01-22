<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FV_Project</title>
<link href="/resources/css/index.css" rel="stylesheet" type="text/css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<nav class="gtco-nav" role="navigation">
		<div class="gtco-container">
			<div class="row">
				<div class="col-sm-4 col-xs-12">
					<div id="gtco-logo">
						<a href="index.jsp">FV <em>.</em></a>
					</div>
				</div>
			</div>
		</div>
	</nav>

	<table>
		<tr>
			<td><iframe id="map-iframe" src="/map(PT)0.9.jsp"
					marginwidth="0" marginheight="0" frameborder="0" scrolling="no">
				</iframe></td>
		</tr>
	</table>
</body>
<footer>
	<a href="login.do"> <input type="button" value="게시판" class="btn">
	</a> <a href="https://www.airport.kr/ap_ko/872/subview.do" target="_blank" rel="noopener noreferrer"><input type="button" value="시간표"
		class="btn-link">
	</a>
</footer>
</html>