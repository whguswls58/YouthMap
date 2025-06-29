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
    <a href="${pageContext.request.contextPath}/mypage/posts" class="active">내 게시물</a>
    <a href="${pageContext.request.contextPath}/mypage/comments">내 댓글</a>
    <form id="withdrawForm" action="${pageContext.request.contextPath}/withdraw" method="post" style="display: none;"></form>
    <a href="javascript:void(0);" onclick="confirmWithdraw()" style="color: red;">회원 탈퇴</a>
  </div>

  <!-- 오른쪽 컨텐츠 -->
  <div class="main-content">
    <div class="content-section">
      <h3>내 게시물 (${postCount}개)</h3>
      <c:choose>
        <c:when test="${empty myPosts}">
          <div class="empty-message">작성한 게시물이 없습니다.</div>
        </c:when>
        <c:otherwise>
          <div class="post-list">
            <c:forEach var="post" items="${myPosts}">
              <div class="post-item">
                <div class="post-header">
                  <span class="post-category">[${post.boardCategory}]</span>
                  <span class="post-date">${post.boardDate}</span>
                </div>
                <div class="post-title">
                  <a href="${pageContext.request.contextPath}/boardview?no=${post.boardNo}">${post.boardSubject}</a>
                </div>
                <div class="post-meta">
                  <span class="post-views">조회수: ${post.boardReadcount}</span>
                </div>
              </div>
            </c:forEach>
          </div>
          
          <!-- 페이징 네비게이션 -->
          <c:if test="${totalPages > 1}">
            <div class="pagination">
              <c:if test="${currentPage > 1}">
                <a href="?page=${currentPage - 1}" class="page-link">&lt;</a>
              </c:if>
              
              <c:forEach var="i" begin="1" end="${totalPages}">
                <c:choose>
                  <c:when test="${i == currentPage}">
                    <span class="page-link active">${i}</span>
                  </c:when>
                  <c:otherwise>
                    <a href="?page=${i}" class="page-link">${i}</a>
                  </c:otherwise>
                </c:choose>
              </c:forEach>
              
              <c:if test="${currentPage < totalPages}">
                <a href="?page=${currentPage + 1}" class="page-link">&gt;</a>
              </c:if>
            </div>
          </c:if>
        </c:otherwise>
      </c:choose>
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