 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>    

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>건의게시판 글 목록</title>
<link href="/resources/css/getBoardList2.css" rel="stylesheet" type="text/css">
</head>
<body>
<div align="center">
<h1>글 목록</h1>
<h3>
	<c:if test ="${not empty userName }">
			${userName}님 환영합니다...<a href="logout.do">Log-out</a>
	</c:if>
</h3>

<!-- 검색 시작 -->
<form action="getSBoardList.do" method="post">
<table border="1" cellpadding="0" cellspacing="0" width="700">
<tr>
  <td align="right">
     <select name="searchCondition">
     	<c:forEach var="option" items="${conditionMap}">
	        <option value="${option.value}">${option.key}</option>
     	</c:forEach>
     </select>
     <input type="text" name="searchKeyword">
     <input type="submit" value="검색">  
  </td>
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
			
			<c:forEach var="board" items="${sboardList}">
			<tr>
				<td>${sboard.sbNum }</td>
				<td align="left"><a href="getSBoard.do?seq=${sboard.sbNum }">
						${sboard.sbSubject }</a></td>
				<td>${sboard. eNick }</td>
				<td>${sboard.sbRegDate }</td>
				<td>${sboard.sbRdCnt }</td>
			</tr>
			</c:forEach>
		</table>
		<br>
		<a href="insertSBoard.jsp">새글 등록</a>
</div>
</body>
  <footer>
    <a href="login.do">
      <input type="button" value="로그인" class="btn">
    </a>
    <a href="getBoardList.do">
      <input type="button" value="자유게시판" class="btn-link">
    </a>
    <a href="getSBoardList.do">
      <input type="button" value="건의게시판" class="btn-link">
    </a>
    <a href="getNBoardList.do">
      <input type="button" value="공지" class="btn-link">
    </a>
  </footer>

</html>