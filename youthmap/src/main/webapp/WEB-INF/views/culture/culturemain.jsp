<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>문화생활 메인</title>

  <!-- Slick CSS -->
  <link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
  <link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>

  <!-- jQuery + Slick JS -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script
    src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>

  <style>
    /* 카드 슬라이더 공통 스타일 */
    .card-slider {
      width: 880px;
      margin: 0 auto;
    }
    .card-slider .card {
      padding: 8px;
      box-sizing: border-box;
      text-align: center;
    }
    .card-slider .card img {
      width: 170px;
      height: 170px;
      object-fit: cover;
      display: block;
      margin: 0 auto 4px;
    }
    .card-slider .card .title {
      height: 40px;
      overflow: hidden;
      line-height: 20px;
      font-weight: bold;
    }
    .card-slider .card .date {
      font-size: 0.85em;
      color: #555;
      margin-top: 4px;
    }
    /* 화살표 위치 조정 (optional) */
    .slick-prev, .slick-next {
      top: 40%;
    }
  </style>
</head>
<body>

  <!-- 전체 목록 버튼 -->
  <div style="text-align:center; margin:20px 0;">
    <button onclick="location.href='allList'"
            style="width:100px; height:26px; font-size:16px;">
      전체 목록
    </button>
  </div>
  <hr>

  <!-- 전시/미술 섹션 -->
  <div style="text-align:center; margin:20px 0;">
    <div style="display:flex; justify-content:space-between; width:880px; margin:0 auto 10px;">
      <p style="font-weight:bold; font-size:1.1em; margin:0;">전시/미술</p>
      <button type="button" onclick="location.href='exhibitionlist'"
              style="width:100px; height:26px; font-size:18px; cursor:pointer;">
        더보기
      </button>
    </div>
    <div class="card-slider exhibition-slider">
      <c:forEach var="cul" items="${exhibition}">
        <div class="card">
          <img src="${cul.con_img}" alt="${cul.con_title}" />
          <div class="title">${cul.con_title}</div>
          <div class="date">${cul.con_start_date} ~ ${cul.con_end_date}</div>
        </div>
      </c:forEach>
    </div>
  </div>

  <!-- 공연 섹션 -->
  <div style="text-align:center; margin:20px 0;">
    <div style="display:flex; justify-content:space-between; width:880px; margin:0 auto 10px;">
      <p style="font-weight:bold; font-size:1.1em; margin:0;">공연</p>
      <button type="button" onclick="location.href='performancelist'"
              style="width:100px; height:26px; font-size:18px; cursor:pointer;">
        더보기
      </button>
    </div>
    <div class="card-slider performance-slider">
      <c:forEach var="cul" items="${performance}">
        <div class="card">
          <img src="${cul.con_img}" alt="${cul.con_title}" />
          <div class="title">${cul.con_title}</div>
          <div class="date">${cul.con_start_date} ~ ${cul.con_end_date}</div>
        </div>
      </c:forEach>
    </div>
  </div>

  <!-- 축제/행사 섹션 -->
  <div style="text-align:center; margin:20px 0;">
    <div style="display:flex; justify-content:space-between; width:880px; margin:0 auto 10px;">
      <p style="font-weight:bold; font-size:1.1em; margin:0;">축제/행사</p>
      <button type="button" onclick="location.href='eventlist'"
              style="width:100px; height:26px; font-size:18px; cursor:pointer;">
        더보기
      </button>
    </div>
    <div class="card-slider event-slider">
      <c:forEach var="cul" items="${event}">
        <div class="card">
          <img src="${cul.con_img}" alt="${cul.con_title}" />
          <div class="title">${cul.con_title}</div>
          <div class="date">${cul.con_start_date} ~ ${cul.con_end_date}</div>
        </div>
      </c:forEach>
    </div>
  </div>

  <!-- Slick 초기화 스크립트 -->
  <script>
    $(function(){
      $('.exhibition-slider, .performance-slider, .event-slider').slick({
       /*  slidesToShow: 3,
        slidesToScroll: 1,
        infinite: true,
        arrows: true,
        dots: true,
        autoplay: true,
        autoplaySpeed: 0, */
        
        slidesToShow: 3,        // 한 화면에 3개
        slidesToScroll: 1,      // 한 칸씩 이동
        infinite: true,
        arrows: true,          // 화살표는 숨기거나 켜도 무방
        dots: false,            // 도트도 숨김
        autoplay: true,
        autoplaySpeed: 0,       // 다음 슬라이드 딜레이 없이 바로 시작
        speed: 5000,            // 한 번 움직일 때 걸리는 시간(ms)
        cssEase: 'linear',      // 선형 이동 — 가속/감속 없이 일정 속도
        pauseOnHover: true,
        responsive: [
          { breakpoint: 1024, settings: { slidesToShow: 4 } },
          { breakpoint: 768,  settings: { slidesToShow: 2 } },
          { breakpoint: 480,  settings: { slidesToShow: 1 } }
        ]
      });
    });
  </script>
<br><hr><BR><BR>
</body>
</html>
