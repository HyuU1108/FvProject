<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
          <div id="gtco-logo"><a href="index3.jsp">FV <em>.</em></a></div>
        </div>
      </div>
    </div>
  </nav>

  <table>
    <tr>
      <td>
        <iframe id="map-iframe" src="/map(PT)0.3.jsp" scrolling="no">
    	</iframe>
      </td>
    </tr>
  </table>

 
  <footer>
    <a href="login.do">
      <input type="button" value="로그인" class="btn">
    </a>
    <a href="getBoardList.do" class="btn-link">
      자유게시판
    </a>
    <a href="getSBoardList.do" class="btn-link">
      건의게시판
    </a>
    <a href="getNBoardList.do" class="btn-link">
      공지
    </a>
  </footer>

</body>
</html>