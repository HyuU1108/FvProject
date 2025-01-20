<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 상세 보기</title>
<link href="/resources/css/getBoard.css" rel="stylesheet" type="text/css">
</head>
<body>
<div align="center">
<h1>글 상세 보기</h1>

</style>
<a href="logout.do">Log-out</a>
<hr color="red">

<form action="updateBoard.do" method="post">
    <input type="hidden" name="seq" value="${board.seq }">
    <table border="1" cellpadding="0" cellspacing="0">
         <tr>
                <td bgcolor="#008997">제목</td>
                <td>
                   <input type="text" name="title" 
                   value="${board.title }">
                </td>
         </tr>
         
         <tr>
                <td bgcolor="#008997">작성자</td>
                <td>${board.writer}
                </td>
         </tr>
         
         <tr>
                <td bgcolor="#008997">내용</td>
                <td>
                <textarea rows="10" cols="40" name="content">${board.content}</textarea>
                </td>
         </tr>
         
         <tr>
                <td bgcolor="#008997">등록일</td>
                <td>${board.regDate}
                </td>
         </tr>
         
         <tr>
               <td bgcolor="#008997">조회수</td>
               <td>${board.cnt }
               </td>
         </tr>
         
         <tr>
             <td colspan="2" align="center">
                <input type="submit" value="글수정">
             </td>
         </tr>
    </table>
</form>
<hr>
 <a href="deleteBoard.do?seq=${board.seq}">글삭제</a>&nbsp;&nbsp;&nbsp;
 <a href="getBoardList.do">글목록</a>
</div>
</body>
</html>