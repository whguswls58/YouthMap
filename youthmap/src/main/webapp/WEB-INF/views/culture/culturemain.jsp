<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
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
    /* ───────────────────────────────────────────────────────────────
       전체 페이지 공통 스타일
    ─────────────────────────────────────────────────────────────── */
    body {
      font-family: 'Playfair Display', serif;
      margin: 0; padding: 0;
      background-color: #fff;
      color: #333;
    }
    .topbar {
      background: #f5f0e6;
      padding: 10px 40px;
    }
    .topbar .menu {
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      justify-content: flex-end;
      gap: 20px;
      font-size: 14px;
    }
    .topbar .menu a { color: #444; text-decoration: none; }

    .navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 18px 40px;
      background: #fff;
      position: sticky; top: 0; z-index: 1000;
      border-bottom: 1px solid #eee;
    }
    .navbar-left, .navbar-right { display: flex; gap: 18px; }
    .navbar-center {
      position: absolute; left: 50%; transform: translateX(-50%);
    }
    .nav-link {
      font-size: 15px; color: #222; text-decoration: none;
    }
    .nav-link:hover, .nav-link.active {
      border-bottom: 2px solid #222; padding-bottom: 2px;
    }
    .logo {
      font-size: 20px; font-weight: bold;
      letter-spacing: 1px; color: #111;
      font-family: 'Playfair Display', serif;
    }

    /* ───────────────────────────────────────────────────────────────
       슬라이더 섹션
    ─────────────────────────────────────────────────────────────── */
    .slider-section { margin: 80px 0; }
    .slider-inner {
      max-width: 1200px;
      margin: 0 auto;
      background-color: #f5f0e6;
      padding: 40px;
      box-sizing: border-box;
    }
    .slider-header {
      display: flex; justify-content: space-between;
      align-items: center;
      margin: 0; padding: 0 20px;
    }
    .slider-header h3 {
      font-weight: bold; font-size: 1.1em; margin: 0;
    }
    .slider-header button {
      background: none; border: none;
      font-size: 1rem; cursor: pointer; color: #333;
    }
    .slider-divider {
      border: 0; border-bottom: 1px solid #ccc;
      margin: 8px 20px 16px;
    }

    /* ───────────────────────────────────────────────────────────────
       Polaroid 카드 + 뱃지
    ─────────────────────────────────────────────────────────────── */
    .card-slider { width: 100%; margin: 0 auto; }
    .card-slider .slick-track { display: flex !important; }
    .card-slider .slick-slide { display: block !important; }
    .slick-prev, .slick-next { top: 40%; }

    .card-slider .polaroid-item {
      position: relative;
      flex: 0 0 auto;
      display: flex;
      flex-direction: column;
      align-items: center;
      width: 220px;
      margin: 20px 12px;
      box-sizing: border-box;
      height: 380px;
      text-decoration: none;
      color: inherit;
    }
    /* 뱃지 공통 */
    /* commonList.css 또는 <style> 내 badge 스타일 수정 */
.card-slider .badge {
  position: absolute;
  top: 15px;
  right: 28px;      /* 기존 8px → 20px 로 변경 */
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: bold;
  color: #fff;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  z-index: 10;
}
    /* 카테고리별 색상 */
    .card-slider .badge.exhibition  { background: #008060; }
    .card-slider .badge.performance { background: #a83279; }
    .card-slider .badge.event       { background: #0066cc; }

    .card-slider .polaroid {
      width: 90%; height: 300px; background: #fff;
      padding: 12px 12px 24px; border: 1px solid #eee;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      border-radius: 4px; display: flex;
      align-items: center; justify-content: center;
    }
    .card-slider .polaroid-img {
      max-width: 100%; max-height: 100%;
      object-fit: cover; border-radius: 2px;
    }
    .card-slider .polaroid-caption {
      margin-top: auto; width: 100%; max-width: 35ch;
      white-space: nowrap; overflow: hidden;
      text-overflow: ellipsis; text-align: center;
      font-size: 1rem; color: #333;
    }
    .card-slider .polaroid-date {
      margin-top: 4px; font-size: 0.85rem;
      color: #777; text-align: center;
    }
    .card-slider .polaroid-item:hover .polaroid-caption {
      text-decoration: underline;
    }
  </style>
</head>

<body>
  <!-- 상단 베이지 바 -->
  <div class="topbar">
    <div class="menu">
      <a href="#">CART</a><a href="#">MY PAGE</a><a href="#">JOIN</a>
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
    <div class="navbar-center"><span class="logo">YOUTHMAP</span></div>
    <div class="navbar-right">
      <a href="#" class="nav-link">CART</a>
      <a href="#" class="nav-link">MY PAGE</a>
      <a href="#" class="nav-link">JOIN</a>
    </div>
  </div>

  <!-- 검색 바 -->
  <%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>

  <!-- 전체 목록 버튼 -->
  <div style="text-align:center; margin:20px 0;">
    <button onclick="location.href='allList'"
            style="width:100px; height:26px; font-size:16px; cursor:pointer;">
      전체 목록
    </button>
  </div>
  <hr>

  <!-- 전시/미술 섹션 -->
  <section class="slider-section">
    <div class="slider-inner">
      <div class="slider-header">
        <h3>전시/미술</h3>
        <button type="button" onclick="location.href='exhibitionlist'">+more</button>
      </div>
      <hr class="slider-divider"/>
      <div class="card-slider exhibition-slider">
        <c:forEach var="cul" items="${exhibition}">
          <a class="polaroid-item"
             href="${pageContext.request.contextPath}/exhibitioncont?con_id=${cul.con_id}">
            <div class="badge exhibition">${cul.category_name}</div>
            <div class="polaroid">
              <img class="polaroid-img" src="${cul.con_img}"
                   alt="${cul.con_title}" />
            </div>
            <div class="polaroid-caption" title="${cul.con_title}">
              ${cul.con_title}
            </div>
            <div class="polaroid-date">
              ${cul.con_start_date} ~ ${cul.con_end_date}
            </div>
          </a>
        </c:forEach>
      </div>
    </div>
  </section>

  <!-- 공연 섹션 -->
  <section class="slider-section">
    <div class="slider-inner">
      <div class="slider-header">
        <h3>공연</h3>
        <button type="button" onclick="location.href='performancelist'">+more</button>
      </div>
      <hr class="slider-divider"/>
      <div class="card-slider performance-slider">
        <c:forEach var="cul" items="${performance}">
          <a class="polaroid-item"
             href="${pageContext.request.contextPath}/performancecont?con_id=${cul.con_id}">
            <div class="badge performance">${cul.category_name}</div>
            <div class="polaroid">
              <img class="polaroid-img" src="${cul.con_img}"
                   alt="${cul.con_title}" />
            </div>
            <div class="polaroid-caption" title="${cul.con_title}">
              ${cul.con_title}
            </div>
            <div class="polaroid-date">
              ${cul.con_start_date} ~ ${cul.con_end_date}
            </div>
          </a>
        </c:forEach>
      </div>
    </div>
  </section>

  <!-- 축제/행사 섹션 -->
  <section class="slider-section">
    <div class="slider-inner">
      <div class="slider-header">
        <h3>축제/행사</h3>
        <button type="button" onclick="location.href='eventlist'">+more</button>
      </div>
      <hr class="slider-divider"/>
      <div class="card-slider event-slider">
        <c:forEach var="cul" items="${event}">
          <a class="polaroid-item"
             href="${pageContext.request.contextPath}/eventcont?con_id=${cul.con_id}">
            <div class="badge event">${cul.category_name}</div>
            <div class="polaroid">
              <img class="polaroid-img" src="${cul.con_img}"
                   alt="${cul.con_title}" />
            </div>
            <div class="polaroid-caption" title="${cul.con_title}">
              ${cul.con_title}
            </div>
            <div class="polaroid-date">
              ${cul.con_start_date} ~ ${cul.con_end_date}
            </div>
          </a>
        </c:forEach>
      </div>
    </div>
  </section>

  <!-- Slick 초기화 -->
  <script>
    $(function(){
      $('.exhibition-slider, .performance-slider, .event-slider').slick({
        slidesToShow: 3,
        slidesToScroll: 1,
        infinite: true,
        arrows: true,
        dots: false,
        autoplay: true,
        autoplaySpeed: 0,
        speed: 5000,
        cssEase: 'linear',
        pauseOnHover: true,
        responsive: [
          { breakpoint: 1024, settings: { slidesToShow: 4 } },
          { breakpoint: 768,  settings: { slidesToShow: 2 } },
          { breakpoint: 480,  settings: { slidesToShow: 1 } }
        ]
      });
    });
  </script>

  <br><hr><br><br>
</body>
</html>
