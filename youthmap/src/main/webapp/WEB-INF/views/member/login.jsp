<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <style>
        .login-container {
            width: 300px;
            margin: auto;
            text-align: center;
        }
        .login-btn {
            display: block;
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            font-size: 16px;
            border: none;
            cursor: pointer;
        }
        .google-btn img,
        .naver-btn img {
            width: 100%;
            height: 40px;
            object-fit: contain;
        }
        .divider {
            margin: 20px 0;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="login-container">

    <h2>로그인</h2>

    <!-- 오류 메시지 출력 -->
    <c:if test="${not empty error}">
        <div style="color: red;">
            <p>${error}</p>
        </div>
    </c:if>

    <!-- 로컬 로그인 -->
    <form action="${pageContext.request.contextPath}/login" method="post">
        <input class="login-btn" type="text" name="memId" placeholder="아이디" required>
        <input class="login-btn" type="password" name="memPass" placeholder="비밀번호" required>
        <button class="login-btn" style="background-color: #4CAF50; color: white;">로그인</button>
    </form>

    <div class="divider">또는</div>

    <!-- 구글 로그인 -->
    <div class="google-btn">
        <a href="${pageContext.request.contextPath}/oauth2/authorization/google">
            <img src="https://developers.google.com/identity/images/btn_google_signin_dark_normal_web.png" alt="Google 로그인">
        </a>
    </div>

    <!-- 네이버 로그인 -->
    <div class="naver-btn">
        <a href="${pageContext.request.contextPath}/oauth2/authorization/naver">
            <img src="https://static.nid.naver.com/oauth/small_g_in.PNG" alt="Naver 로그인">
        </a>
    </div>

    <p><a href="${pageContext.request.contextPath}/register">회원가입</a></p>
</div>
</body>
</html> 