<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>VIVAMAP</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
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
    <c:if test="${sessionScope.loginMember.memType != 'LOCAL'}">
      <span style="color: gray; display: block; margin-bottom: 10px;">소셜 계정은 정보 수정이 불가합니다.</span>
    </c:if>
    <c:if test="${sessionScope.loginMember.memType == 'LOCAL'}">
      <a href="${pageContext.request.contextPath}/edit_pass">비밀번호 변경</a>
    </c:if>
    <c:if test="${sessionScope.loginMember.memType != 'LOCAL'}">
      <span style="color: gray; display: block; margin-bottom: 10px;">소셜 계정은 비밀번호 변경이 불가합니다.</span>
    </c:if>
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

	<c:if test="${param.success == 'updated'}">
      <div class="success-message" style="color: green; margin-bottom: 15px; padding: 10px; background-color: #e6ffe6; border: 1px solid #99ff99; border-radius: 5px;">
        회원정보가 성공적으로 수정되었습니다.
      </div>
    </c:if>

    <div class="info-stats-row">
      <div class="mypage-info">
        <h3>회원 정보</h3>
        <p><strong>아이디:</strong> ${member.memId}</p>
        <p><strong>이름:</strong> ${member.memName}</p>
        <p><strong>핸드폰번호:</strong> ${member.memNum}</p>
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
<!-- 푸터 -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>

