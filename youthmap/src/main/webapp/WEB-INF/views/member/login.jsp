<!-- login.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/login.css">
</head>
<body>
<div class="login-wrapper">
    <div class="login-box">
        <h2 class="login-title">로그인</h2>

        <c:if test="${not empty error}">
            <div class="login-error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="login-form">
            <input type="text" name="memId" placeholder="아이디" required>
            <input type="password" name="memPass" placeholder="비밀번호" required>
            <button type="submit" class="login-button">로그인</button>
        </form>

        <div class="login-divider">또는</div>

        <div class="social-login">
            <a href="${pageContext.request.contextPath}/oauth2/authorization/google">
                <img src="https://developers.google.com/identity/images/btn_google_signin_dark_normal_web.png" alt="구글 로그인">
            </a>
            <a href="${pageContext.request.contextPath}/oauth2/authorization/naver">
                <img src="https://static.nid.naver.com/oauth/small_g_in.PNG" alt="네이버 로그인">
            </a>
        </div>

        <div class="login-register">
            <a href="${pageContext.request.contextPath}/register">회원가입</a>
        </div>
    </div>
</div>
</body>
</html>