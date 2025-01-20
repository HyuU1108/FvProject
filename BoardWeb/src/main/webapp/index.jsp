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
          <div id="gtco-logo"><a href="index.jsp">FV <em>.</em></a></div>
        </div>
      </div>
    </div>
  </nav>

  <table>
    <tr>
      <td>
        <iframe id="map-iframe" src="/map(PT)0.3.jsp" marginwidth="0"
    		marginheight="0" frameborder="0" scrolling="no">
    	</iframe>
      </td>
    </tr>
  </table>

 
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

</body>
</html>