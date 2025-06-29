<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>VIVAMAP</title>
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/culture/culture_main.css">
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

</style>
</head>

<body>

<%@ include file="/WEB-INF/views/header.jsp" %>
<!-- Hero 배너 -->
<section class="hero-banner"></section>

<%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>


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
        slidesToShow: 4,		// ③ 화면에 한 번에 보여줄 슬라이드 개수 (여기선 3개)
      					  //    → 하지만 CSS에서 .slick-slide width를 고정해 두면, 이 설정이 무시되기도 합니다.
        slidesToScroll: 1,		// ④ 한 번에 몇 칸씩 넘길지 (화살표나 autoplay 시 이동 단위)
        infinite: true,  	    // ⑤ 슬라이드를 끝까지 넘겨도 다시 처음으로 “무한 반복” 여부
        arrows: false,			// ⑥ 좌우 화살표(prev/next) 표시 여부
        dots: false,			// ⑦ 하단 도트 내비게이션 표시 여부
        autoplay: true,			// ⑧ 페이지 로드 직후 자동 재생 시작 여부
        autoplaySpeed: 1,		// ⑨ 자동 재생 시 “다음 애니메이션” 트리거 대기(ms)
       							 //    보통 2000 정도 주는데, 0을 주면 트리거가 바로바로 찍혀서
       							 //    속도(speed)만큼의 애니메이션이 연달아 계속 돌게 됩니다.
        speed: 5000,	   // ⑩ 한 번의 슬라이드 애니메이션(translate) 지속 시간(ms) //    5초 동안 천천히 넘어가도록 설정
        cssEase: 'linear',		// ⑪ 애니메이션 속도 곡선: 일정한 속도로 움직이기 위한 ‘linear’
        pauseOnHover: true,			// ⑫ 마우스 올리면 autoplay 일시정지 여부
        responsive: [
          { breakpoint: 1024, settings: { slidesToShow: 5 } },
          { breakpoint: 768,  settings: { slidesToShow: 4 } },
          { breakpoint: 480,  settings: { slidesToShow: 2 } }
       // ⑬ 반응형: 화면폭이 작아질 때 슬라이드 개수 재지정
        ]
      });
    });
  </script>
  <br><hr><br><br>
<!-- 푸터 -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
