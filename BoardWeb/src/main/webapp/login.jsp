<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title></title>
<link href="/resources/css/login.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
// Elements
document.addEventListener("DOMContentLoaded", function () {
    const signInBtn = document.getElementById("signIn");
    const signUpBtn = document.getElementById("signUp");
    const firstForm = document.getElementById("form1");
    const secondForm = document.getElementById("form2");
    const container = document.querySelector(".container");

    // Sign In 버튼 클릭 시
    signInBtn.addEventListener("click", function() {
        container.classList.remove("right-panel-active");
    });

    // Sign Up 버튼 클릭 시
    signUpBtn.addEventListener("click", function() {
        container.classList.add("right-panel-active");
    });

});
</script>
</head>
<div class="container right-panel-active">
  <!-- Sign Up -->
  <div class="container__form container--signup">
    <form action="#" class="form" id="form1">
      <h2 class="form__title">회원가입</h2>
      <input type="text" placeholder="아이디" class="input" />
      <input type="email" placeholder="이메일" class="input" />
      <input type="password" placeholder="비밀번호" class="input" />
      <button class="btn">회원가입</button>
    </form>
  </div>

  <!-- Sign In -->
  <div class="container__form container--signin">
    <form action="login.do" class="form" id="form2" method="post">
      <h2 class="form__title">로그인</h2>
      <input type="text" placeholder="아이디" class="input" value="${user.id}" name="id"/>
      <input type="password" placeholder="비밀번호" class="input" value="${user.password}" name="password"/>
      <a href="#" class="link">비밀번호를 잊으셨나요?</a>
      <button class="btn">로그인</button>
    </form>
  </div>

  <!-- Overlay -->
  <div class="container__overlay">
    <div class="overlay">
      <div class="overlay__panel overlay--left">
        <button class="btn" id="signIn">로그인</button>
      </div>
      <div class="overlay__panel overlay--right">
        <button class="btn" id="signUp">회원가입</button>
      </div>
    </div>
  </div>
</div>
</body>
</html>
