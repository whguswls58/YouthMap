<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<title>서울 인기 맛집</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>
<style>
body {
  font-family: 'Playfair Display', serif;
  margin: 0;
  padding: 0;
  background-color: #fff;
  color: #333
}
/* 상단 베이지 바 */
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
.topbar .menu a {
  color: #444;
  text-decoration: none;
}
/* 네비게이션 */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 40px;
  background: #fff;
  position: sticky;
  top: 0;
  z-index: 1000;
  border-bottom: 1px solid #eee;
}
.navbar-left,
.navbar-right {
  display: flex;
  gap: 18px;
}
.navbar-center {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
}
.nav-link {
  font-size: 15px;
  color: #222;
  text-decoration: none;
}
.nav-link:hover,
.nav-link.active {
  border-bottom: 2px solid #222;
  padding-bottom: 2px;
}
.logo {
  font-size: 20px;
  font-weight: bold;
  letter-spacing: 1px;
  color: #111;
  font-family: 'Playfair Display', serif;
}

/* Hero */
.hero {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 60px 0 40px 0;
}
.hero-text {
  background: #888;
  color: white;
  padding: 20px 36px;
  border-radius: 10px;
  text-align: center;
  max-width: 360px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

/* 검색 */
.search-wrapper {
  display: flex;
  justify-content: center;
  margin: 50px 0;
  position: relative;
  z-index: 1;
}
.search-bar {
  display: flex;
  align-items: center;
  background: #f2f2f2;
  padding: 20px 40px;
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.05);
  gap: 12px;
  width: 800px;
  justify-content: center;
  position: relative;
  z-index: 1;
}
.search-combined {
  display: flex;
  background-color: #fff;
  border-radius: 6px;
  overflow: hidden;
  border: 1px solid #ccc;
  flex-grow: 1;
  max-width: 760px;
  position: relative;
  z-index: 2;
}
.search-combined select {
  border: none;
  padding: 12px 20px;
  font-size: 14px;
  background-color: #fff;
  border-right: 1px solid #ccc;
  position: relative;
  z-index: 2;
  background-image: url('data:image/svg+xml;utf8,<svg fill="black" height="20" viewBox="0 0 24 24" width="20" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/></svg>');
  background-repeat: no-repeat;
  background-position: right 10px center;
  background-size: 12px;
  appearance: none;
  width: 160px;
}
.search-combined select:focus {
  outline: none;
  z-index: 9999;
} 
.search-combined input[type="text"] {
  border: none;
  padding: 12px 16px;
  font-size: 14px;
  width: 100%;
  outline: none;
}
.search-bar input[type="submit"] {
  padding: 12px 20px;
  background-color: #888;
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: bold;
  cursor: pointer;
}
.search-bar input[type="submit"]:hover {
  background-color: #666;
}

.gu-list { display: none; }
.gu-list.active { display: flex !important; }

/* 구 버튼 리스트 */
.gu-list {
  text-align: center;
  flex-wrap: wrap;
  display: flex;
  justify-content: center;
  gap: 10px;
  margin: 20px auto;
  max-width: 1000px;
  display: none;
}
.gu-list.active {
  display: flex;
}
.gu-btn {
  padding: 10px 20px;
  border-radius: 20px;
  background: white;
  border: 1px solid #aaa;
  cursor: pointer;
  font-size: 14px;
}
.gu-btn.active {
  background: #222;
  color: white;
  font-weight: bold;
}
/* 베이지 배경을 살짝만 크게 */
.slider-section {
  background-color: #f5f0e6;
   height:370px;
  padding: 10px 0;              /* 위아래 여백만 줘서 카드보다 살짝 크게 */
  margin-top:50px;
  margin-bottom:50px;
}

/* 섹션 내부 컨텐츠 가운데 정렬 및 최대 너비 제한 */
.slider-section h2 {
  text-align: center;
  margin-bottom: 16px;
  color: #333;
}

.slider-section .swiper-container {
  max-width: 1200px;            /* 필요에 따라 조절 */
  margin: 0 auto;               /* 가운데 정렬 */
  padding: 0 16px;              /* 좌우 여백 */
  box-sizing: border-box;
}
/* 카드 자체는 원래 스타일 유지 (흰 배경, 그림자 등 그대로) */
.slider-section .restaurant-card {
  background: #fff;             /* 백그라운드 흰색 유지 */
  /* 기존 스타일 그대로… */
}


 /* 1) 슬라이더 하단 여백 */
  .swiper-container {
    margin-bottom: 0px;
    }
    /* 슬라이더 카드 크기 키우기 */
.swiper-slide {
  /* slide 자체 너비를 늘려서 사진을 크게 보여줍니다 */
  width: 240px !important;
}
.slider-section .slider-title {
  text-align: center;
  margin-bottom: 12px;
  color: #333;
  }
.swiper-slide .restaurant-card {
  width: 240px;       /* 기존 200px → 240px */
  padding: 16px;      /* 안쪽 여백도 살짝 늘려줍니다 */
}

.swiper-slide .restaurant-card img {
  height: 180px;      /* 기존 150px → 180px */
}

/* 슬라이드 각각의 고정 폭 */
.swiper-slide {
  width: 240px;        /* 카드+여백 포함 너비 */
}

/* 1) swiper-container 를 화면 폭의 90%로 고정하고 최대 1200px 까지만 늘어나게 */
.swiper-container {
  width: 90vw;        /* 화면 너비의 90% */
  max-width: 1200px;  /* (원하는 최대값) */
  margin: 0 auto;     /* 좌우 자동 중앙정렬 */
}
    
/* 카드 */
.restaurant-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 30px;
  justify-content: center;
  margin-top: 50px;
}
.restaurant-card {
  width: 300px;
  border: 1px solid #ccc;
  border-radius: 12px;
  text-align: center;
  padding: 12px;
  transition: all 0.3s ease-in-out;
  margin-top: 50px;
}
.restaurant-card img {
  width: 100%;
  height: 150px;
  object-fit: cover;
  border-radius: 8px;
}
.restaurant-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}
.restaurant-name {
  font-weight: bold;
  margin-top: 10px;
  color: #222;
}
.restaurant-score {
  color: #ffa500;
}
.map-wrapper {
  position: relative;
  width: 100%;
  max-width: 900px;
  margin: 5px auto;     /* 기존 inline style 의 margin-top:20px */
}
/* 지도 */
#map {
  width: 100%;
  max-width: 900px;
  height: 400px;
  margin: 0 auto !important;
  border-radius: 16px;
}

/* 내 위치 버튼 */
#moveToMyLocationBtn {
  position: absolute;
  right: 6px;
  bottom: 24px;
  z-index: 1000;
  background: #fff;
  border: 2px solid #1784fc;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  box-shadow: 0 2px 12px #eee;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
</head>
<body>
<!-- 상단 베이지 바 -->
<div class="topbar">
  <div class="menu">
    <a href="#">CART</a>
    <a href="#">MY PAGE</a>
    <a href="#">JOIN</a>
  </div>
</div>

<!-- ✅ 네비게이션 구조 -->
<div class="navbar">
  <div class="navbar-left">
    <a href="#" class="nav-link">About</a>
    <a href="#" class="nav-link">Facility</a>
    <a href="#" class="nav-link active">Food</a>
    <a href="#" class="nav-link">Community</a>
    <a href="#" class="nav-link">Contact</a>
  </div>
  <div class="navbar-center">
    <span class="logo">YOUTHMAP</span>
  </div>
  <div class="navbar-right">
    <a href="#" class="nav-link">CART</a>
    <a href="#" class="nav-link">MY PAGE</a>
    <a href="#" class="nav-link">JOIN</a>
  </div>
</div>

<!-- ✅ Hero -->
<section class="hero">
  <div class="hero-text">
    <h2>Food</h2>
    <p>당신 근처의 인기 맛집을 소개합니다</p>
  </div>
</section>

<!-- ✅ 검색 -->
<div class="search-wrapper">
	  <form class="search-bar" action="restaurants" method="get" >
  <div class="search-combined">
    <select name="searchType" id="searchType">
      <option value="res_subject"
        <c:if test="${searchType == 'res_subject'}">selected</c:if>>
        식당이름
      </option>
      <option value="res_gu"
        <c:if test="${searchType == 'res_gu'}">selected</c:if>>
        구별
      </option>
    </select>
  		<input type="text" name="keyword" placeholder="검색어 입력"value="${fn:escapeXml(keyword)}" />
  	</div>
  		<input type="submit" value="검색" />
	</form>
	</div>


<!-- ✅ 구 버튼 -->
<div class="gu-list <c:if test='${searchType eq \"res_gu\"}'>active</c:if>'"> 
<form id="guForm" method="get" action="restaurants">
     <button type="submit" name="res_gu" value="" class="gu-btn <c:if test='${empty res_gu}'>active</c:if>">전체</button>
      <c:forEach var="gu" items="${seoulGuList}">
        <button type="submit" name="res_gu" value="${gu}" class="gu-btn <c:if test='${res_gu == gu}'>active</c:if>">${gu}</button>
      </c:forEach>
     
      <input type="hidden" name="searchType" value="res_gu" />
      <!-- <input type="hidden" name="keyword" value="" /> -->
      <input type="hidden" name="keyword" value="${fn:escapeXml(keyword)}" />
    </form>
  </div>



<!-- ✅ 타이틀 -->
<h2 style="text-align:center; margin-top:40px;">
  <c:choose>
    <c:when test="${not empty res_gu}">‘${res_gu}’ 인기 맛집</c:when>
    <c:when test="${not empty keyword}">‘${keyword}’ 검색 결과</c:when>
    <c:otherwise>별점 높은 인기 맛집</c:otherwise>
  </c:choose>
</h2>
<!-- ✅ 카드 슬라이더 -->
<section class="slider-section">
<div class="swiper-container">
  <div class="swiper-wrapper">
    <c:forEach var="res" items="${restaurants}">
      <div class="swiper-slide">
        <div class="restaurant-card">
          <a href="restaurantDetail?res_id=${res.res_id}">
            <img src="${res.res_photo_url}" alt="${res.res_subject}" />
          </a>
          <div class="restaurant-name">
            <a href="restaurantDetail?res_id=${res.res_id}">
              ${res.res_subject}
            </a>
          </div>
          <div class="restaurant-score">★ ${res.res_score}</div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>
</section>
<!-- ✅ 지도 -->
<div class=map-wrapper>
  <div id="map"></div>
  <button id="moveToMyLocationBtn">
    <img src="https://cdn-icons-png.flaticon.com/512/684/684908.png" alt="내 위치" style="width:26px; height:26px;">
  </button>
</div>

<!-- ✅ 스크립트 -->
<script>
document.addEventListener('DOMContentLoaded', function() {
  var searchType = document.getElementById('searchType');
  var keyword = document.getElementById('keywordInput');
  var form = document.getElementById('searchForm');
  if(searchType && keyword && form) {
      function onTypeChange() {
          // 검색어 초기화
          keywordIn.value = "";
          // 구 버튼 리스트 토글
          if (select.value === "res_gu") {
            guList.classList.add("active");
          } else {
            guList.classList.remove("active");
          }
        }

        select.addEventListener("change", onTypeChange);
        onTypeChange(); // 로드 시 한 번 실행
      });
});
}
});

let map;
var mapRestaurants = [
  <c:forEach var="r" items="${mapRestaurants}" varStatus="status">
    {lat: ${r.res_latitude}, lng: ${r.res_longitude}, name: '${r.res_subject}', id: '${r.res_id}', photo: '${r.res_photo_url}'}
    <c:if test="${!status.last}">,</c:if>
  </c:forEach>
];
function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 37.5665, lng: 126.9780},
    zoom: 14
  });

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(pos) {
      var myLatLng = {
        lat: pos.coords.latitude,
        lng: pos.coords.longitude
      };
      map.setCenter(myLatLng);
      map.setZoom(18);

      new google.maps.Marker({
        map: map,
        position: myLatLng,
        title: "내 위치",
        icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"
      });

      mapRestaurants.forEach(function(r) {
        if (r.lat && r.lng) {
          var marker = new google.maps.Marker({
            map: map,
            position: {lat: r.lat, lng: r.lng},
            title: r.name,
            icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png"
          });

          var photoUrl = r.photo && r.photo !== 'null' ? r.photo : 'https://dummyimage.com/80x80/cccccc/fff&text=No+Image';
          var infoHtml = `
            <div style="width:220px; padding:18px; border-radius:14px; background:#fff;">
              <a href="restaurantDetail?res_id=${r.id}" style="text-decoration:none;">
                <img src="${photoUrl}" alt="${r.name}" style="width:100%; height:110px; object-fit:cover; border-radius:8px;">
                <div style="font-weight:bold; margin-top:10px; color:#222;">${r.name}</div>
              </a>
            </div>`;

          var infowindow = new google.maps.InfoWindow({ content: infoHtml });
          marker.addListener('mouseover', function() { infowindow.open(map, marker); });
          marker.addListener('mouseout', function() { infowindow.close(); });
          marker.addListener('click', function() {
            window.location.href = "restaurantDetail?res_id=" + r.id;
        }
      });
    });
  }
}

document.getElementById('moveToMyLocationBtn').onclick = function() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(pos) {
      map.setCenter({ lat: pos.coords.latitude, lng: pos.coords.longitude });
      map.setZoom(18);
    }, function() {
      alert('위치 정보를 불러올 수 없습니다.');
    });
  } else {
    alert('브라우저가 위치 정보를 지원하지 않습니다.');
  }
};
</script>
<!--구리스트 스크립트 -->
<script>
document.addEventListener("DOMContentLoaded", function(){
  const select = document.getElementById("searchType");
  const guList = document.querySelector(".gu-list");
  function toggleGuList(){
    if (select.value === "res_gu") {
      guList.classList.add("active");
    } else {
      guList.classList.remove("active");
    }
  }
  select.addEventListener("change", toggleGuList); 
  toggleGuList();  // 초기 로딩 시 상태 반영
});
</script>
<script src="https://maps.googleapis.com/maps/api/js?key=${apiKey}&callback=initMap" async defer></script>
<!-- Swiper JS 추가 (body 끝 직전에) -->
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script>
const swiper = new Swiper('.swiper-container', {
	loop: true,
    centeredSlides: true,           // 항상 가운데 슬라이드가 중앙에 오도록
    centerInsufficientSlides: true, // 슬라이드 수가 적을 때도 가운데 정렬
    autoplay: {
      delay: 2500,
      disableOnInteraction: false
    },
    slidesPerView: 5,               // 한 번에 보여줄 카드 개수
	  spaceBetween: 60,      // 카드 간격 
	  pagination: {
	    el: '.swiper-pagination',
	    clickable: true
	  },
	  navigation: {
	    nextEl: '.swiper-button-next',
	    prevEl: '.swiper-button-prev',
	  },
	  breakpoints: {
	    640:  { slidesPerView: 2 },
	    768:  { slidesPerView: 3 },
	    1024: { slidesPerView: 4 },
	    1440: { slidesPerView: 5 }
	  }
	});
</script>
</body>
</html>
