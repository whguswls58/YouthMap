<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>VIVAMAP</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/member/mypage.css">
</head>
<body>

<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

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
    <a href="${pageContext.request.contextPath}/edit_pass">비밀번호 변경</a>
    <a href="${pageContext.request.contextPath}/mypage-posts">내 게시물</a>
    <a href="${pageContext.request.contextPath}/mypage-comments">내 댓글</a>
    <a href="javascript:void(0);" onclick="confirmWithdraw()" style="color: red;">회원 탈퇴</a>
  </div>
      <!-- 메인 컨텐츠 -->
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
          <input type="text" name="memPhone" value="${member.memNum}" placeholder="010-1234-5678" required>
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
</div>

  <c:if test="${not empty error}">
    <script>alert('${error}');</script>
  </c:if>

<script>
  // 전화번호 입력 시 숫자만 허용
  $(function(){
    $("input[name='memPhone']").on("input", function(){
      $(this).val($(this).val().replace(/[^0-9-]/g, ''));
    });
  });
</script>  
<script src="/js/session.js"></script>

<!-- 푸터 -->
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
