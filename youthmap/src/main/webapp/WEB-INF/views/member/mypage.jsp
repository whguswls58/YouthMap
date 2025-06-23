<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>마이페이지</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/member/mypage.css">
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
  <!-- 사이드바 -->
  <div class="sidebar">
    <div style="margin-bottom: 30px; font-weight: bold;">
      ${member.memName}님의 마이페이지
    </div>

    <a href="${pageContext.request.contextPath}/mypage">내 정보</a>
    <c:if test="${sessionScope.loginMember.memType == 'LOCAL'}">
      <a href="${pageContext.request.contextPath}/edit">정보 수정</a>
    </c:if>
    <c:if test="${sessionScope.loginMember.memType != 'LOCAL'}">
      <span style="color: gray;">소셜 계정은 정보 수정이 불가합니다.</span>
    </c:if>
    <a href="${pageContext.request.contextPath}/edit_pass">비밀번호 변경</a>
    <a href="${pageContext.request.contextPath}/mypage/posts">내 게시물</a>
    <a href="${pageContext.request.contextPath}/mypage/comments">내 댓글</a>
    <form id="withdrawForm" action="${pageContext.request.contextPath}/withdraw" method="post" style="display: none;"></form>
    <a href="javascript:void(0);" onclick="confirmWithdraw()" style="color: red;">회원 탈퇴</a>
  </div>

  <!-- 오른쪽 컨텐츠: 회원정보 + 활동통계 -->
  <div class="main-content">

    <c:if test="${param.error == 'socialUserCannotEdit'}">
      <div class="error-message" style="color: red; margin-bottom: 15px; padding: 10px; background-color: #ffe6e6; border: 1px solid #ff9999; border-radius: 5px;">
        소셜 로그인 계정은 정보 수정이 불가합니다.
      </div>
    </c:if>

    <div class="info-stats-row">
      <div class="mypage-info">
        <h3>회원 정보</h3>
        <p><strong>아이디:</strong> ${member.memId}</p>
        <p><strong>이름:</strong> ${member.memName}</p>
        <p><strong>이메일:</strong> ${member.memMail}</p>
        <p><strong>주소:</strong> ${member.memAddress} ${member.memAddDetail}</p>
        <p><strong>가입일:</strong> ${member.memDate}</p>
      </div>

      <div class="mypage-stats">
        <h3>활동 통계</h3>
        <p><strong>작성한 게시물:</strong> ${postCount}개</p>
        <p><strong>작성한 댓글:</strong> ${commentCount}개</p>
      </div>
    </div>
  </div>
</div>

<footer>
  ⓒ 2025 YOUTHMAP. All Rights Reserved.
</footer>

<script>
  function confirmWithdraw() {
    if (confirm("정말 탈퇴하시겠습니까?")) {
      document.getElementById("withdrawForm").submit();
    }
  }
</script>
<script src="/js/session.js"></script>
</body>
</html>

