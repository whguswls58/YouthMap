<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>내 게시물 - 마이페이지</title>
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
</body>
</html> 