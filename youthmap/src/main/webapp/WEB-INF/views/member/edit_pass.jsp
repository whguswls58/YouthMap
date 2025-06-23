<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>비밀번호 변경</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/mypage.css">
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
<!-- 마이페이지 레이아웃 -->
<div class="mypage-container">
  <div class="sidebar">
    <div style="margin-bottom: 30px; font-weight: bold;">
      ${member.memName}님의 마이페이지
    </div>
    <a href="${pageContext.request.contextPath}/mypage">내 정보</a>
    <c:if test="${sessionScope.loginMember.memType == 'LOCAL'}">
          <a href="${pageContext.request.contextPath}/edit">정보 수정</a>
        </c:if>
   <a href="${pageContext.request.contextPath}/edit_pass">비밀번호 변경</a>
    <a href="${pageContext.request.contextPath}/mypage-posts">내 게시물</a>
    <a href="${pageContext.request.contextPath}/mypage-comments">내 댓글</a>
    <a href="javascript:void(0);" onclick="confirmWithdraw()" style="color: red;">회원 탈퇴</a>
  </div>

  <div class="main-content">
    <div class="mypage-title">
      <h2>비밀번호 변경</h2>
    </div>
    
    <!-- 성공 메시지 표시 -->
    <c:if test="${param.success == 'passwordChanged'}">
      <div class="success-message" style="color: green; margin-bottom: 15px; padding: 10px; background-color: #e6ffe6; border: 1px solid #99ff99; border-radius: 5px;">
        비밀번호가 성공적으로 변경되었습니다.
      </div>
    </c:if>
    
    <!-- 에러 메시지 표시 -->
    <c:if test="${not empty error}">
      <div class="error-message" style="color: red; margin-bottom: 15px; padding: 10px; background-color: #ffe6e6; border: 1px solid #ff9999; border-radius: 5px;">
        ${error}
      </div>
    </c:if>

    <div class="main-content">
  <form action="/edit_pass" method="post" class="pass-form">

    <div class="pass-row">
      <label for="currentPassword">현재 비밀번호</label>
      <input type="password" name="currentPassword" id="currentPassword" required>
    </div>

    <div class="pass-row">
      <label for="newPassword">새 비밀번호</label>
      <input type="password" name="newPassword" id="newPassword" required>
    </div>

    <div class="pass-row">
      <label for="confirmPassword">새 비밀번호 확인</label>
      <input type="password" name="confirmPassword" id="confirmPassword" required>
    </div>

    <div class="pass-row">
      <button type="submit">비밀번호 변경</button>
    </div>

  </form>
</div>
<script src="/js/session.js"></script>

</body>
</html>
