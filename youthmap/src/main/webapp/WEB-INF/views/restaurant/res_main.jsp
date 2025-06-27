<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>서울 인기 맛집</title>
  <!-- CSS 파일 로드 -->
  <link rel="stylesheet" href="<c:url value='/css/res/res_main.css'/>" />
  
  <!-- Swiper CSS -->
  <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">

 
</head>
<body>
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

  <!-- Hero 배너 -->
  <section class="hero-banner"></section>

  <!-- 검색 -->
  <div class="search-wrapper">
    <form id="searchForm" class="search-bar" action="restaurants" method="get">
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
        <input
          id="keywordInput"
          type="text"
          name="keyword"
          placeholder="검색어 입력"
          value="${fn:escapeXml(keyword)}" />
      </div>
      <input type="submit" value="검색" />
    </form>
  </div>

  <!-- 구 버튼 -->
  <div class="gu-list <c:if test='${searchType eq "res_gu"}'>active</c:if>">
    <form id="guForm" method="get" action="restaurants">
      <button type="submit" name="res_gu" value=""
        class="gu-btn <c:if test='${empty res_gu}'>active</c:if>">
        전체
      </button>
      <c:forEach var="gu" items="${seoulGuList}">
        <button type="submit" name="res_gu" value="${gu}"
          class="gu-btn <c:if test='${res_gu == gu}'>active</c:if>">
          ${gu}
        </button>
      </c:forEach>
      <input type="hidden" name="searchType" value="res_gu" />
      <input type="hidden" name="keyword" value="${fn:escapeXml(keyword)}" />
    </form>
  </div>

  <!-- 타이틀 -->
  <h2 style="text-align:center; margin-top:40px;">
    <c:choose>
      <c:when test="${not empty res_gu}">‘${res_gu}’ 인기 맛집</c:when>
      <c:when test="${not empty keyword}">‘${keyword}’ 검색 결과</c:when>
      <c:otherwise>별점 높은 인기 맛집</c:otherwise>
    </c:choose>
  </h2>

  <!-- 카드 슬라이더 -->
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

  <!-- 지도 -->
  <div class="map-wrapper">
    <div id="map"></div>
    <button id="moveToMyLocationBtn">
      <img src="https://cdn-icons-png.flaticon.com/512/684/684908.png"
           alt="내 위치" style="width:26px; height:26px;" />
    </button>
  </div>

  <!-- JS: 검색 Type 변경 + 폼 제출 -->
  <script>
    document.addEventListener('DOMContentLoaded', function(){
      const select     = document.getElementById('searchType');
      const keywordIn  = document.getElementById('keywordInput');
      const form       = document.getElementById('searchForm');
      const guList     = document.querySelector('.gu-list');

      function onTypeChange(){
        if(select.value==='res_gu'){
          guList.classList.add('active');
        } else {
          guList.classList.remove('active');
        }
      }

      select.addEventListener('change', function(){
        onTypeChange();
        keywordIn.value = '';
        form.submit();
      });

      onTypeChange();
    });
  </script>

  <!-- Google Maps -->
  <script>
    let map;
    const mapRestaurants = [
    	<c:forEach var="r" items="${mapRestaurants}" varStatus="status">
        {
        	lat:   <c:out value="${r.res_latitude}" />,  
            lng:   <c:out value="${r.res_longitude}" />,  
            name:  '<c:out value="${fn:escapeXml(r.res_subject)}"/>',
            // ★ 여기 id에 c:out으로 값을 확실히 삽입
            id:    '<c:out value="${r.res_id}" escapeXml="false"/>',
            photo: '<c:out value="${r.res_photo_url}" escapeXml="false"/>'
          }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
  
    function initMap(){
      map = new google.maps.Map(document.getElementById('map'), {
        center: {lat:37.5665, lng:126.9780},
        zoom: 14
      });

      if(navigator.geolocation){
        navigator.geolocation.getCurrentPosition(pos=>{
          const myLatLng = {lat:pos.coords.latitude, lng:pos.coords.longitude};
          map.setCenter(myLatLng);
          map.setZoom(18);
          new google.maps.Marker({
            map, position: myLatLng,
            title:'내 위치',
            icon:'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
          });
          
          mapRestaurants.forEach(r=>
          {
        	  
            if(r.lat&&r.lng){
              const marker = new google.maps.Marker({
                map,
                position:{lat:r.lat, lng:r.lng},
                title:r.name,
                icon:'http://maps.google.com/mapfiles/ms/icons/red-dot.png'
              });
              const photoUrl = (r.photo && r.photo.trim() !== '')
              ? r.photo
              : 'https://dummyimage.com/80x80/cccccc/fff&text=No+Image';

              const infoHtml =
            	  '<div style="width:180px; padding:12px; border-radius:14px; background:#fff;">' +
            	    '<a href="restaurantDetail?res_id=' + r.id + '"' +
            	       ' style="text-decoration:none; color:inherit; outline:none;">' +
            	      '<img src="' + photoUrl + '" ' +
            	           'style="width:100%; height:90px; object-fit:cover; border-radius:8px;">' +
            	      '<div style="font-weight:bold; margin-top:8px; color:#222;">' +
            	        r.name +
            	      '</div>' +
            	    '</a>' +
            	  '</div>';
            	  
                const infowindow = new google.maps.InfoWindow({content:infoHtml});
              marker.addListener('mouseover', ()=>infowindow.open(map,marker));
              marker.addListener('mouseout', ()=>infowindow.close());
              marker.addListener('click', ()=>window.location.href='restaurantDetail?res_id='+r.id);
            }
          });
        });
      }
    }

    document.getElementById('moveToMyLocationBtn')
      .addEventListener('click', ()=>{
        if(navigator.geolocation){
          navigator.geolocation.getCurrentPosition(pos=>{
            map.setCenter({lat:pos.coords.latitude, lng:pos.coords.longitude});
            map.setZoom(18);
          }, ()=>alert('위치 정보를 불러올 수 없습니다.'));
        } else {
          alert('브라우저가 위치 정보를 지원하지 않습니다.');
        }
      });
  </script>
    <!-- 구글지도  -->
  <script  src="https://maps.googleapis.com/maps/api/js?key=${apiKey}&callback=initMap" defer></script>
  
  

  <!-- Swiper JS -->
  <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script>
	const totalSlides = 10;  // 실제 슬라이드 갯수에 맞춰 조정

  	const swiper = new Swiper('.swiper-container', {
	  loop: true,
	  loopedSlides: totalSlides,    // 전체 슬라이드 수
	  slidesPerView: 5,   // 한 화면에 꽉 채워 보여줄 개수
	   speed: 6000,
	   spaceBetween: 10,
	   slidesPerView: 7,           // 보여줄 카드 수
	   slidesPerGroup: 1,
	   spaceBetween: 20,
 	   loopedSlides: 7,             // 실제 카드 개수만큼 복제(clone)해서
 	   loopAdditionalSlides: 7,     // 앞뒤로 여분을 더 만들어 줍니다
    // 하단 도트 내비게이션 제거 (dots: false)
    	pagination: false,

    // 자동 재생 설정
    autoplay: {
      delay: 0,               // autoplaySpeed: 1ms  
      disableOnInteraction: false,   // disableOnInteraction: false
      pauseOnMouseEnter: true        // pauseOnHover: true
    },
    

    // 반응형 슬라이드 개수
    breakpoints: {
      1440: { slidesPerView: 4 },
      1024: { slidesPerView: 3 },
      768:  { slidesPerView: 2 },
      480:  { slidesPerView: 1 }
    }
  });
</script>
	<!-- 푸터 -->
	<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
