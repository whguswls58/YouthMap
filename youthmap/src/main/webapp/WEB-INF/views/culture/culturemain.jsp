<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>문화생활 메인</title>
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

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
       슬라이더 섹션
    ─────────────────────────────────────────────────────────────── */
  /* 슬라이더(전시·공연·축제) 영역 위아래 여백을 60px씩 줍니다. */
.slider-section {
	margin: 5px 0;
} 

/*───────────────────────────────────────────────────────────────
 슬라이더 내부 컨테이너 최대 너비 2000px, 상하 100px·좌우 자동 중앙 정렬.
  배경색·패딩·box-sizing을 지정합니다. 
  ───────────────────────────────────────────────────────────────*/
.slider-inner {
	max-width: 80%;
	margin: 50px auto;       /* ← top/bottom 100px, left/right auto 로 바꿔서 가로 중앙 정렬 */
	background-color: #f5f0e6;
	box-sizing: border-box;
	height: auto;              /* 카드 높이에 맞춰 늘어나게 */
  	padding: 40px;             /* 패딩도 비율에 맞게 줄이기 */
}

/* 제목(“전시/미술” 등)과 “+more” 버튼을 좌우 끝에 배치합니다. */
.slider-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin: 0;
	padding: 0 20px;
}
/* 헤더 텍스트·버튼 스타일, 그리고 가로 구분선을 세팅합니다. */
.slider-header h3 {
	font-weight: bold;
	font-size: 1.1em;
	margin: 0;
}

.slider-header button {
	background: none;
	border: none;
	font-size: 1rem;
	cursor: pointer;
	color: #333;
}

.slider-divider {
	border: 0;
	border-bottom: 1px solid #ccc;
	margin: 8px 20px 16px;
}

/* ───────────────────────────────────────────────────────────────
       Polaroid 카드 + 뱃지
    ─────────────────────────────────────────────────────────────── */
.card-slider {
	width: 100%;
	margin: 0 auto;
}

.card-slider .slick-track {
	display: flex !important;
}

.slick-prev, .slick-next {
	top: 40%;
}

/* 뱃지 공통 */
/* commonList.css 또는 <style> 내 badge 스타일 수정 */
.card-slider .badge {
	position: absolute;
	top: 15px;
	right: 15px; /* 기존 8px → 20px 로 변경 */
	padding: 4px 10px;
	border-radius: 12px;
	font-size: 0.85rem;
	font-weight: bold;
	color: #fff;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	z-index: 10;
}
/* 카테고리별 색상 */
.card-slider .badge.exhibition {
	background: #008060;
}

.card-slider .badge.performance {
	background: #a83279;
}

.card-slider .badge.event {
	background: #0066cc;
}

/* .card-slider .slick-slide {
  width: 180px !important;
} */

/* 3) 폴라로이드 카드 스타일 (이전 restaurant-card) */
.card-slider .polaroid-item {
	width: 100% /* 이전 220px → 240px */
	height: 250px;
	padding: 16px; /* 안쪽 여백 */
	border: 1px solid #ccc;
	border-radius: 12px;
	background: #fff;
	text-align: center;
	transition: all 0.3s ease-in-out;
	margin: 0 13px; /* 카드 사이 간격 */
	position: relative;
	text-decoration: none !important;
}

/* 4) 이미지 영역 (이전 restaurant-card img) */
.card-slider .polaroid-img {
	width: 100%; /* 카드 폭에 꽉 채우기 */
	height: 180px; /* 이전 150px → 180px */
	object-fit: cover;
	border-radius: 8px;
	margin-bottom: 12px;
}

/* 5) 카드 타이틀 (이전 restaurant-name) */
.card-slider .polaroid-caption {
	font-weight: bold;
	margin-top: 8px;
	color: #222;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}


.card-slider .polaroid-date {
	margin-top: 4px;
	font-size: 0.85rem;
	color: #777;
	text-align: center;
}

.card-slider .polaroid-item:hover .polaroid-caption {
	text-decoration: underline;
}

.card-slider .polaroid-item:hover {
	transform: translateY(-4px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}
</style>
</head>

<body>
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>
  <!-- 검색 바 -->
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
</body>
</html>
