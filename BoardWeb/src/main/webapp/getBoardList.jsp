<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글목록</title>
<link href="/resources/css/getBoardList2.css" rel="stylesheet"
	type="text/css">
</head>
<nav class="home">
	<a href="index.jsp">FV <em>.</em></a>
</nav>
<body>
	<div>
		<h1>글 목록</h1>
		<h3>

			<c:if test="${not empty userName }">
			${userName}님 환영합니다...<a href="logout.do">Log-out</a>
			</c:if>

		</h3>

		<!-- 검색 시작 -->
		<form action="getBoardList.do" method="post">
			<table border="1" cellpadding="0" cellspacing="0" width="700">
				<tr>
					<td align="right"><select name="searchCondition">
							<c:forEach var="option" items="${conditionMap}">
								<option value="${option.value}">${option.key}</option>
							</c:forEach>
					</select> <input type="text" name="searchKeyword"> <input
						type="submit" value="검색"></td>
				</tr>
			</table>
		</form>
		<!-- 검색 종료 -->

		<table class="bdtable">
			<tr>
				<th bgcolor="orange" width="100">번호</th>
				<th bgcolor="orange" width="200">제목</th>
				<th bgcolor="orange" width="150">작성자</th>
				<th bgcolor="orange" width="150">등록일</th>
				<th bgcolor="orange" width="100">조회수</th>
			</tr>

			<c:forEach var="board" items="${boardList}">
				<tr>
					<td>${board.seq }</td>
					<td align="left"><a href="getBoard.do?seq=${board.seq }">
							${board.title }</a></td>
					<td>${board.writer }</td>
					<td>${board.regDate }</td>
					<td>${board.cnt }</td>
				</tr>
			</c:forEach>
		</table>
		<br> 
	<a href="insertBoard.jsp">새글등록</a>
	</div>
</body>
<footer>
	<a href="logout.do"> 
	<input type="button" value="로그아웃" class="btn">
	</a>
	<a href="getBoardList.do"> 
		<input type="button" value="자유게시판"
		class="btn-link">
	</a> <a href="getSBoardList.do"> <input type="button" value="건의게시판"
		class="btn-link">
	</a> <a href="getNBoardList.do"> <input type="button" value="공지"
		class="btn-link">
	</a>
</footer>

</html>