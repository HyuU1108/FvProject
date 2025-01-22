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

<c:set var="userId" scope="page" value="${sessionScope.id}" />
<%-- 세션에서 "id" 값을 가져와 page scope 변수 userId에 저장 --%>

<c:choose>
	<c:when test="${not empty userId}">
		<%-- userId가 비어있지 않으면 (세션에 id가 있으면) --%>
		<footer>
			<a href="logout.do"> <input type="button" value="로그아웃"
				class="btn">
			</a>
			
			 <a href="getBoardList.do"> <input type="button" value="자유게시판"
				class="btn-link">
			</a>
			
			 <a href="getSBoardList.do"> <input type="button" value="건의게시판"
				class="btn-link">
			</a>
			
			 <a href="getNBoardList.do"> <input type="button" value="공지사항"
				class="btn-link">
			</a>
		</footer>
	</c:when>

	<c:otherwise>
		<%-- userId가 비어있으면 (세션에 id가 없으면) --%>
		<footer>
			<a href="login.do"> <input type="button" value="게시판" class="btn">
			<!-- </a> <a href="fre.do"> <input type="button" value="없는거"
				class="btn-link">
			</a> <a href="sug.do"> <input type="button" value="인공"
				class="btn-link"> -->
			</a> <a href="https://www.airport.kr/ap_ko/872/subview.do" target="_blank" rel="noopener noreferrer"> <input type="button" value="시간표"
				class="btn-link">
			</a>
		</footer>
	</c:otherwise>
</c:choose>
</html>