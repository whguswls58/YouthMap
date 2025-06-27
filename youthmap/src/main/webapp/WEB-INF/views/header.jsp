<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 헤더(include) -->
<!-- 상단 베이지 바 -->
<div class="topbar">
  <div class="menu">
    <c:choose>
      <c:when test="${empty sessionScope.loginMember}">
        <a href="/login">로그인</a>
        <a href="/register">회원가입</a>
      </c:when>
      <c:otherwise>
        <c:choose>
          <c:when test="${sessionScope.loginMember.memType eq 'ADMIN'}">
            <a href="/admin/dashboard">관리자 보드</a>
            <a href="/logout">로그아웃</a>
          </c:when>
          <c:otherwise>
            <a href="/mypage">마이페이지</a>
            <a href="/logout">로그아웃</a>
          </c:otherwise>
        </c:choose>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<!-- ✅ 네비게이션 구조 -->
<div class="navbar">
  <div class="navbar-left">
  <div class="nav-item">
    <a href="/policyMain" class="nav-link">Policy</a>
    <div class="dropdown">
        <a href="/policyMain?selectedCategory=일자리">일자리</a>
        <a href="/policyMain?selectedCategory=주거">주거</a>
        <a href="/policyMain?selectedCategory=교육">교육</a>
        <a href="/policyMain?selectedCategory=복지문화">복지문화</a>
        <a href="/policyMain?selectedCategory=참여권리">참여권리</a>
      </div>
      </div>
      <div class="nav-item">
    <a href="/culturemain" class="nav-link">Culture</a>
    <div class="dropdown">
       <a href="/exhibitionlist">전시/미술</a>
       <a href="/performancelist">공연</a>
      <a href="/eventlist">축제/행사</a>
    </div>
    </div>
    <div class="nav-item">
    <a href="/res_main" class="nav-link">Food</a>
    </div>
    <div class="nav-item">
    <a href="/boardlist" class="nav-link">Board</a>
   </div>
   
  </div>
 <div class="navbar-center">
    <a href="${pageContext.request.contextPath}/home" class="logo">VIVAMAP</a>
  </div>
  
  <div class="navbar-right">
    <c:if test="${not empty sessionScope.loginMember}">
      <input type="hidden" id="session-start-time" value="${sessionScope.loginStartTime}" />
      <span style="color: #333; font-size: 12px;">환영합니다 <b>${sessionScope.loginMember.memName}</b>님</span>
      <span id="login-timer" style="font-weight: bold; color: #d33; font-size: 14px;"></span>
    </c:if>
  </div>
</div>

<script>
/* 세션 타이머 기능 */
document.addEventListener('DOMContentLoaded', function() {
  var timerElement = document.getElementById('login-timer');
  var sessionStartTimeInput = document.getElementById('session-start-time');
  
  console.log('타이머 요소:', timerElement);
  console.log('세션 시작 시간 요소:', sessionStartTimeInput);
  
  if (timerElement && sessionStartTimeInput) {
    var sessionStartTime = parseInt(sessionStartTimeInput.value);
    console.log('세션 시작 시간:', sessionStartTime);
    
    // 세션 시작 시간이 유효하지 않은 경우 처리
    if (isNaN(sessionStartTime) || sessionStartTime <= 0) {
      console.log('유효하지 않은 세션 시작 시간:', sessionStartTime);
      timerElement.textContent = "세션 시간을 불러올 수 없습니다.";
      return;
    }
    
    var sessionTimeout = 30 * 60 * 1000; // 30분 (밀리초)
    
    function updateTimer() {
      var now = Date.now();
      var elapsed = now - sessionStartTime;
      var remaining = sessionTimeout - elapsed;
      
      console.log('현재 시간:', now, '경과 시간:', elapsed, '남은 시간:', remaining);
      
      if (remaining <= 0) {
        clearInterval(timerInterval);
        alert("로그인 시간이 만료되었습니다. 자동 로그아웃됩니다.");
        location.href = "/logout";
        return;
      }
      
      var minutes = Math.floor(remaining / 60000);
      var seconds = Math.floor((remaining % 60000) / 1000);
      
      var timerText = "남은 시간: " + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
      timerElement.textContent = timerText;
      console.log('타이머 텍스트:', timerText);
    }
    
    // 1초마다 갱신
    var timerInterval = setInterval(updateTimer, 1000);
    updateTimer(); // 즉시 실행
    
    // 페이지 이동 시 타이머 정리
    window.addEventListener('beforeunload', function() {
      clearInterval(timerInterval);
    });
  } else {
    console.log('타이머 요소나 세션 시작 시간을 찾을 수 없습니다.');
  }
});
</script>
