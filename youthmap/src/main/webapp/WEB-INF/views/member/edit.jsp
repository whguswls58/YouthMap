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

</head>

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
  
  <!-- 사이드바 -->
<body>
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

</body>
</html>
