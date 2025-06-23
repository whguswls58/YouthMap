<!-- login.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/login.css">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
</head>
<body>

<!-- 상단 베이지 바 -->
<div class="topbar">
  <div class="menu">
    <c:choose>
      <c:when test="${empty sessionScope.loginMember}">
        <a href="/login">로그인</a>
        <a href="/register">회원가입</a>
      </c:when>
      <c:otherwise>
        <a href="/mypage">마이페이지</a>
        <a href="/logout">로그아웃</a>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<!-- ✅ 네비게이션 구조 -->
<div class="navbar">
  <div class="navbar-left">
  <div class="nav-item">
    <a href="/policyMain" class="nav-link">정책</a>
    <div class="dropdown">
        <a href="/policyMain?mainCategory=일자리">일자리</a>
        <a href="/policyMain?mainCategory=주거">주거</a>
        <a href="/policyMain?mainCategory=교육">교육</a>
      </div>
      </div>
      <div class="nav-item">
    <a href="/culturemain" class="nav-link">문화</a>
    <div class="dropdown">
       <a href="/exhibitionlist">전시/미술</a>
       <a href="/performancelist">공연</a>
      <a href="/eventlist">축제/행사</a>
    </div>
    </div>
    <div class="nav-item">
    <a href="/res_main" class="nav-link">맛집</a>
    <div class="dropdown">
       <a href="/res_main?res_gu=강남구">강남구</a>
       <a href="/res_main?res_gu=강북구">강북구</a>
       <a href="/res_main?res_gu=강서구">강서구</a>
       <a href="/res_main?res_gu=강동구">강동구</a>
    </div>
    </div>
    <div class="nav-item">
    <a href="/boardlist" class="nav-link">유저게시판</a>
   </div>
   
  </div>
 <div class="navbar-center">
    <a href="${pageContext.request.contextPath}/home" class="logo">YOUTHMAP</a>
  </div>
  
  <div class="navbar-right">
    <c:if test="${not empty sessionScope.loginMember}">
      <input type="hidden" id="session-start-time" value="${sessionScope.loginStartTime}" />
      <span style="color: #333; font-size: 12px;">환영합니다 <b>${sessionScope.loginMember.memName}</b>님</span>
      <span id="login-timer" style="font-weight: bold; color: #d33; font-size: 14px;"></span>
    </c:if>
  </div>
</div>

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