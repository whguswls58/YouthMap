<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>YouthMap</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
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
    <!-- 세션 시작 시간 저장용 히든 필드 -->
    <input type="hidden" id="session-start-time"
           value="${sessionScope.loginStartTime}" />

    <!-- 환영 메시지 + 타이머 표시 영역 -->
    <span style="color: #333; font-size: 12px;">
      환영합니다 <b>${sessionScope.loginMember.memName}</b>님
    </span>
    <span id="login-timer"
          style="font-weight: bold; color: #d33; font-size: 14px;">
    </span>

    <!-- 세션 타이머 JS 한 번에 로드 -->
    <script src="${pageContext.request.contextPath}/js/session.js"></script>
  </c:if>
</div>


</div>
<section class="main-hero">
  <img src="${pageContext.request.contextPath}/img/123.jpg" alt="YouthMap 메인 이미지">
  <div class="main-hero-text">
    <h1>YouthMap</h1>
  </div>
</section>

<section class="category-info-section">
  <div class="category-info-grid">

    <a href="/policyMain" class="info-box">
      <div class="info-image">
        <img src="/img/JYimg/YouthMap_logo.png" alt="정책 이미지">
      </div>
      <hr>
      <h3>정책</h3>
      <p>지원, 주거, 혜택 등 다양한 청년 정책을 확인할 수 있습니다.</p>
    </a>

    <a href="/culturemain" class="info-box">
      <div class="info-image">
        <img src="/img/JYimg/YouthMap_logo.png" alt="문화 이미지">
      </div>
      <hr>
      <h3>문화</h3>
      <p>뮤지컬, 전시회, 축제 등 서울의 문화 소식을 소개합니다.</p>
    </a>

    <a href="/res_main" class="info-box">
      <div class="info-image">
        <img src="/img/JYimg/YouthMap_logo.png" alt="맛집 이미지">
      </div>
      <hr>
      <h3>맛집</h3>
      <p>서울 청년이 직접 추천하는 구별 숨은 맛집 모음입니다.</p>
    </a>

    <a href="/boardlist" class="info-box">
      <div class="info-image">
        <img src="/img/JYimg/YouthMap_logo.png" alt="유저게시판 이미지">
      </div>
      <hr>
      <h3>유저게시판</h3>
      <p>청년들의 생생한 이야기, 게시판에서 자유롭게 소통할 수 있습니다.</p>
    </a>

  </div>
</section>

<!-- 공지사항 배너
<section class="notice-banner">
  <div class="notice-inner">
    <h2 class="notice-title">공지사항</h2>
    <ul class="notice-list">
      <c:forEach var="notice" items="${noticeList}" varStatus="status">
        <c:if test="${status.index < 3}">
          <li>
            ■ / ${notice.memId} /
            <a href="/boardview?no=${notice.boardNo}">${notice.boardSubject}</a> /
            <fmt:formatDate value="${notice.boardDate}" pattern="yyyy.MM.dd a hh:mm" /> /
            ${notice.boardReadcount}
          </li>
        </c:if>
      </c:forEach>
    </ul>
  </div>
</section>
-->

<!-- 조원 소개 섹션
      <section class="team-section">
  <div class="team-title">조원 소개</div>
  <div class="team-wrapper">
    <div class="team-member">
      <img src="/img/JYimg/Profile_icon.png" alt="member">
      <p>표정현</p>
    </div>
    <div class="team-member">
      <img src="/img/JYimg/Profile_icon.png" alt="member">
      <p>김진영</p>
    </div>
    <div class="team-member">
      <img src="/img/JYimg/Profile_icon.png" alt="member">
      <p>[팀장] 조현진</p>
    </div>
    <div class="team-member">
      <img src="/img/JYimg/Profile_icon.png" alt="member">
      <p>김예원</p>
    </div>
    <div class="team-member">
      <img src="/img/JYimg/Profile_icon.png" alt="member">
      <p>이슬</p>
    </div>
  </div>
</section>
-->
<footer class="footer-modern">
  <div class="footer-content">
    <p>Tel. 000-0000-0000 | Fax. 00-0000-0000 | youthmap@support.com</p>
    <p>Addr. Seoul, Korea | Biz License 000-00-00000</p>
    <p>© 2025 YouthMap. All Rights Reserved.<br>Hosting by YouthMap Team</p>
  </div>
</footer>

<script src="/js/JYjs/main.js"></script>


</body>
</html>