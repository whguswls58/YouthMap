<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원정보 수정</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/member/mypage.css">
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
  <!-- 사이드바 -->
<body>
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


<!--회원수정 -->
   <div class="main-content">
  <div class="edit-profile-wrapper">
    <h2>회원 정보 수정</h2>

    <form action="${pageContext.request.contextPath}/edit" method="post" class="edit-form">

      <!-- 이름 (수정 불가) -->
      <div class="edit-row">
        <label>이름</label>
        <input type="text" value="${member.memName}" readonly>
      </div>

      <!-- 아이디 (수정 불가) -->
      <div class="edit-row">
        <label>아이디</label>
        <input type="text" value="${member.memId}" readonly>
      </div>

      <!-- 이메일 -->
      <div class="edit-row">
        <label>이메일</label>
        <input type="email" name="memMail" value="${member.memMail}" required>
      </div>

      <!-- 휴대폰번호 -->
      <div class="edit-row">
        <label>휴대전화번호</label>
        <input type="text" name="memPhone" value="${member.memNum}" required>
      </div>

      <!-- 주소 -->
      <div class="edit-row">
        <label>주소</label>
        <input type="text" name="memAddress" value="${member.memAddress}" required>
      </div>

      <!-- 상세주소 -->
      <div class="edit-row">
        <label>상세 주소</label>
        <input type="text" name="memAddDetail" value="${member.memAddDetail}">
      </div>

      <!-- 버튼 -->
      <div class="edit-row">
        <button type="submit">수정 완료</button>
      </div>
    </form>
  </div>
</div>


  <footer>
    ⓒ 2025 YOUTHMAP. All Rights Reserved.
  </footer>

  <c:if test="${not empty error}">
    <script>alert('${error}');</script>
  </c:if>

  <script>
    $(function(){
      $("#phoneMiddle, #phoneLast").on("input", function(){
        $(this).val($(this).val().replace(/[^0-9]/g, ''));
      });

      $("#phoneMiddle").on("input", function(){
        if($(this).val().length === 4){
          $("#phoneLast").focus();
        }
      });

      $("#phoneLast").on("input", function(){
        if($(this).val().length === 4){
          $(this).blur();
        }
      });
    });
  </script>
<script src="/js/session.js"></script>
</body>
</html>
