<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 가입</title>
    <link rel="stylesheet" href="/css/styles.css"> <!-- 필요한 스타일 추가 -->
</head>
<body>

    <h1>회원 가입</h1>

    <!-- 회원가입 폼 -->
    <form action="/member/save" method="post">
        <!-- 아이디 -->
        <label for="id">아이디:</label>
        <input type="text" id="id" name="id" value="${user.id}" required /><br>

        <!-- 비밀번호 -->
        <label for="password">비밀번호:</label>
        <input type="password" id="password" name="password" value="${user.password}" required /><br>

        <!-- 이름 -->
        <label for="name">이름:</label>
        <input type="text" id="name" name="name" value="${user.name}" required /><br>

        <!-- 역할 -->
        <label for="role">역할:</label>
        <select id="role" name="role" required>
            <option value="USER">일반 사용자</option>
            <option value="ADMIN">관리자</option>
        </select><br>

        <!-- 제출 버튼 -->
        <button type="submit">회원 가입</button>
    </form>

    <!-- 로그인 화면으로 돌아가기 링크 -->
    <p>이미 회원이신가요? <a href="/member/login">로그인</a></p>

</body>
</html>
