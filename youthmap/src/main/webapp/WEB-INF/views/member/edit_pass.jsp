<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>비밀번호 변경</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/mypage.css">
</head>
<body>

<!-- 상단 베이지 바 -->
<div class="topbar">
  <div class="menu">
    <a href="#">CART</a>
    <a href="#">MY PAGE</a>
    <a href="#">JOIN</a>
  </div>
</div>

<!-- 네비게이션 -->
<div class="navbar">
  <div class="navbar-left">
    <a href="#" class="nav-link">About</a>
    <a href="#" class="nav-link">Facility</a>
    <a href="#" class="nav-link active">Food</a>
    <a href="#" class="nav-link">Community</a>
    <a href="#" class="nav-link">Contact</a>
  </div>
  <div class="navbar-center">
    <a href="${pageContext.request.contextPath}/home" class="logo">YOUTHMAP</a>
  </div>
  <div class="navbar-right">
    <a href="#" class="nav-link">CART</a>
    <a href="#" class="nav-link">MY PAGE</a>
    <a href="#" class="nav-link">JOIN</a>
  </div>
</div>

<!-- 마이페이지 레이아웃 -->
<div class="mypage-container">
  <div class="sidebar">
    <a href="${pageContext.request.contextPath}/mypage">내 정보</a>
    <c:if test="${sessionScope.loginMember.memType == 'LOCAL'}">
      <a href="${pageContext.request.contextPath}/edit">정보 수정</a>
    </c:if>
    <a href="${pageContext.request.contextPath}/edit_pass">비밀번호 변경</a>
    <a href="#">내 게시물</a>
    <a href="#">내 댓글</a>
    <a href="#">회원 탈퇴</a>
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


</body>
</html>
