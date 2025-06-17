<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<style>
  /* …기존 스타일 그대로… */
</style>
</head>
<body>

  <div class="mypage-container">
    <div class="mypage-title">
      <h2>${member.memName}님의 마이페이지</h2>
      <div class="mypage-buttons">
        <!-- 로컬 사용자일 때만 수정 링크 노출 -->
        <c:if test="${sessionScope.loginMember.memType == 'LOCAL'}">
          <a href="${pageContext.request.contextPath}/edit">회원정보수정</a>
        </c:if>
        <!-- 소셜 로그인 사용자는 안내 문구만 노출할 수도 있습니다 -->
        <c:if test="${sessionScope.loginMember.memType != 'LOCAL'}">
          <span style="color: gray; margin-right: 10px;">
            소셜 계정은 정보 수정이 불가합니다.
          </span>
        </c:if>

        |

        <!-- 탈퇴 폼 + 버튼 -->
        <form id="withdrawForm" action="${pageContext.request.contextPath}/withdraw" method="post" style="display: none;"></form>
        <a href="javascript:void(0);" onclick="confirmWithdraw()">회원 탈퇴</a>

        <script>
          function confirmWithdraw() {
            if (confirm("정말 탈퇴하시겠습니까?")) {
              document.getElementById("withdrawForm").submit();
            }
          }
        </script>
      </div>
    </div>

    <a href="${pageContext.request.contextPath}/logout">로그아웃</a>

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

</body>
</html> 