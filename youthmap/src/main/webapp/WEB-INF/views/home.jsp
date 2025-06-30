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
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

<section class="main-hero">
  <img src="${pageContext.request.contextPath}/img/banner/main.jpg" alt="VIVA MAP 메인 이미지">
  <div class="main-hero-text">
   <h1 style="font-family: 'Georgia', serif; font-weight: normal; font-size: 70px; letter-spacing: 1px; margin: 0;">
  VIVAMAP
</h1>
  </div>
</section>

<section class="category-info-section">
  <div class="category-info-grid">

    <a href="/policyMain" class="info-box">
      <div class="info-image">
        <img src="/img/banner/policy5.jpg" alt="정책 이미지">
      </div>
      <h3>정책</h3>
      <p>지원, 주거, 혜택 등 다양한 청년 정책을 확인할 수 있습니다.</p>
    </a>
    <a href="/culturemain" class="info-box">
      <div class="info-image">
        <img src="/img/banner/culture4.png" alt="문화 이미지">
      </div>
      <h3>문화</h3>
      <p>전시회, 공연, 축제 등 서울의 문화 소식을 소개합니다.</p>
    </a>

    <a href="/res_main" class="info-box">
      <div class="info-image">
        <img src="/img/banner/food4.jpg" alt="맛집 이미지">
      </div>
      <h3>맛집</h3>
      <p>서울 청년에게 추천하는 구별 숨은 맛집 모음입니다.</p>
    </a>

    <a href="/boardlist" class="info-box">
      <div class="info-image">
        <img src="/img/banner/board.jpeg" alt="유저게시판 이미지">
      </div>
      <h3>유저게시판</h3>
      <p>청년들의 생생한 이야기, 게시판에서 자유롭게 소통할 수 있습니다.</p>
    </a>

  </div>
</section>

<script src="/js/JYjs/main.js"></script>
	<!-- 푸터 -->
	<%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>