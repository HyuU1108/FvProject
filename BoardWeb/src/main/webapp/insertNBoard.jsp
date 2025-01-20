<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지</title>
<link href="/resources/css/insertBoard.css" rel="stylesheet" type="text/css">
</head>
<body>
<div align="center">
  <h1>공지</h1>
  <a href="logout.do">Log-out</a>
  <hr color="red">
  <form action="insertNBoard.do" method="post" enctype="multipart/form-data">
    <table border="1" cellpadding="0" cellspacing="0">
      <tr>
        <td class="table-header">제목</td>
        <td align="left">
          <input type="text" name="title">
        </td>
      </tr>
      <tr>
        <td class="table-header">작성자</td>
        <td align="left">
          <input type="text" name="writer" size="10" value="${AdminVO.adminid}"><!-- adminid -->
        </td>
      </tr>
      <tr>
        <td class="table-header">내용</td>
        <td align="left">
          <textarea rows="10" cols="40" name="content"></textarea>
        </td>
      </tr>
      <tr>
        <td class="table-header">업로드</td>
        <td align="left">
          <input type="file" name="uploadFile">
        </td>
      </tr>
      <tr>
        <td colspan="2" align="center">
          <input type="submit" value="공지 등록">
        </td>
      </tr>
    </table>
  </form>
  <hr color="red">
  <a href="getNBoardList.do">공지 목록</a>
</div>
</body>
</html>
