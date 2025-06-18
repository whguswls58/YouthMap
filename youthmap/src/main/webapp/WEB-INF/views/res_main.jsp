<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<title>서울 맛집 메인</title>
<style>
.gu-btn {
	display: inline-block; margin: 6px 8px; padding: 9px 22px;
	border: 2px solid #aaa; border-radius: 25px; background: #fff;
	font-size: 17px; cursor: pointer; transition: background 0.2s, border 0.2s;
}
.gu-btn.active { background: #222; color: #fff; border-color: #222; }
.gu-btn:hover { background: #f2f2f2; border-color: #333; }
body { font-family: Arial, sans-serif; }
.search-bar { text-align: center; margin: 30px 0; }
.search-bar input[type="text"] {
	width: 300px; padding: 8px; border-radius: 6px; border: 1px solid #ccc;
}
.search-bar button {
	padding: 8px 16px; border-radius: 6px; border: none;
	background-color: #4CAF50; color: white; cursor: pointer;
}
.restaurant-grid {
	display: flex; flex-wrap: wrap; gap: 30px; justify-content: center;
}
.restaurant-card {
	width: 200px; border: 1px solid #ccc; padding: 10px;
	border-radius: 12px; text-align: center;
}
.restaurant-card img {
	width: 100%; height: 150px; object-fit: cover; border-radius: 8px;
}
.restaurant-name { font-weight: bold; margin-top: 10px; }
.restaurant-score { color: #ffa500; }
</style>
</head>
<body>
<!-- 검색폼 -->
<div style="text-align:center; margin-bottom:28px;">
	<form action="restaurants" method="get" id="searchForm" style="display:inline;">
		<select name="searchType" id="searchType" onChange="onSearchTypeChange()">
			<option value="res_subject" <c:if test="${searchType=='res_subject'}">selected</c:if>>식당이름</option>
			<option value="res_gu" <c:if test="${searchType=='res_gu'}">selected</c:if>>구별</option>
		</select>
		<input type="text" name="keyword" id="keywordInput"
			value="<c:out value='${empty keyword ? "" : keyword}'/>"
			placeholder="검색어 입력" style="padding:7px; border-radius:5px; border:1px solid #ccc;">
		<input type="submit" value="검색" style="padding:7px 18px; border-radius:5px; background:#333; color:#fff; border:none;">
	</form>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
  var searchType = document.getElementById('searchType');
  var keyword = document.getElementById('keywordInput');
  var form = document.getElementById('searchForm');
  if(searchType && keyword && form) {
    searchType.addEventListener('change', function() {
      keyword.value = '';
      form.submit();
    });
  }
});
</script>

<!-- 구별 버튼 -->
<c:if test="${searchType == 'res_gu'}">
	<div style="text-align:center; margin-bottom:18px;">
		<form id="guForm" method="get" action="restaurants" style="display:inline;">
			<c:forEach var="gu" items="${seoulGuList}">
				<button type="submit" name="res_gu" value="${gu}" class="gu-btn <c:if test='${res_gu == gu}'>active</c:if>">${gu}</button>
			</c:forEach>
			<button type="submit" name="res_gu" value="" class="gu-btn <c:if test='${empty res_gu}'>active</c:if>">전체</button>
			<input type="hidden" name="searchType" value="res_gu" />
			<input type="hidden" name="keyword" value="" />
		</form>
	</div>
</c:if>

<h2 align="center">
	<c:choose>
		<c:when test="${not empty res_gu}">‘${res_gu}’ 인기 맛집</c:when>
		<c:when test="${not empty keyword}">‘${keyword}’ 검색 결과</c:when>
		<c:otherwise>별점 높은 인기 맛집</c:otherwise>
	</c:choose>
</h2>

<!-- ★ BEST 4개 or 검색결과만 카드로 -->
<div class="restaurant-grid">
	<c:choose>
		<c:when test="${empty restaurants}">
			<div style="font-size:18px; color:#888; text-align:center;">결과가 없습니다.</div>
		</c:when>
		<c:otherwise>
			<c:forEach var="res" items="${restaurants}">
				<div class="restaurant-card">
					<c:if test="${not empty res.res_photo_url}">
					<a href="restaurantDetail?res_id=${res.res_id}">
						<img src="${res.res_photo_url}" alt="대표 사진" />
					</a>
					</c:if>
					<div class="restaurant-name">
						<a href="restaurantDetail?res_id=${res.res_id}" style="color:#222; text-decoration:none;">
						${res.res_subject}
						</a>
					</div>
					<div class="restaurant-score">★ ${res.res_score}</div>
				</div>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</div>

<!-- 지도 -->
<div style="position:relative; width:100%; max-width:900px; margin:0 auto;">
<div id="map" style="width:100%; max-width:900px; height:400px; margin:30px auto; border-radius:16px;"></div>
<!-- 내 위치 버튼 -->
  <button id="moveToMyLocationBtn"
    style="
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
    ">
    <img src="https://cdn-icons-png.flaticon.com/512/684/684908.png" alt="내 위치" style="width:26px; height:26px;">
  </button>
  </div>
<script>
var mapRestaurants = [
	  <c:forEach var="r" items="${mapRestaurants}" varStatus="status">
	    {lat: ${r.res_latitude}, lng: ${r.res_longitude}, name: '${r.res_subject}', id: '${r.res_id}', photo: '${r.res_photo_url}'}
	    <c:if test="${!status.last}">,</c:if>
	  </c:forEach>
	];

console.log("mapRestaurants 실제 데이터:", mapRestaurants);
console.log("id값:", mapRestaurants[0].id); // id 속성 값
function getDistance(lat1, lng1, lat2, lng2) {
    function toRad(x) { return x * Math.PI / 180; }
    var R = 6371;
    var dLat = toRad(lat2 - lat1);
    var dLng = toRad(lng2 - lng1);
    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
            Math.sin(dLng/2) * Math.sin(dLng/2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c;
}
  	var map;
	function initMap() {
    	 map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: 37.5665, lng: 126.9780},
        zoom: 14,
        
    });
    

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(pos) {
            var myLat = pos.coords.latitude;
            var myLng = pos.coords.longitude;
            var myLatLng = { lat: myLat, lng: myLng };
            map.setCenter(myLatLng);
            map.setZoom(18); // ← 내 위치 주변 크게!

            // 내 위치 마커
            new google.maps.Marker({
                map: map,
                position: myLatLng,
                title: "내 위치",
                icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"
            });

            // 내 위치 3km 이내 식당만
            var rangeKm = 3.0;
            mapRestaurants.forEach(function(r) {
                if (r.lat && r.lng) {
                    var pos = {lat: r.lat, lng: r.lng};
                    var marker = new google.maps.Marker({
                        map: map,
                        position: pos,
                        title: r.name, // 툴팁은 그냥 있음!
                        icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png"
                    });
                    // 👇 이름 + 이미지 HTML을 content로
                    
                    var photoUrl = r.photo && r.photo !== 'null' ? r.photo : 'https://dummyimage.com/80x80/cccccc/fff&text=No+Image';
                   // 마커위에이미지,이름뜨게
			     var infoHtml =
			    '<div style="width:220px; min-height:200px; background:#fff; border-radius:14px; box-shadow:0 2px 12px #eee; padding:18px 13px 10px 13px; text-align:center; border:1.5px solid #eee;">' +
			        '<a href="restaurantDetail?res_id=' + r.id + '" style="display:block; text-decoration:none;">' +
			            '<img src="' + r.photo + '" alt="' + r.name + '" style="width:100%; max-width:194px; height:110px; object-fit:cover; border-radius:8px; margin-bottom:13px; background:#fafafa;">' +
			            '<div style="font-weight:bold; margin-top:0; font-size:17px; color:#222; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">' + r.name + '</div>' +
			        '</a>' 
			       
    			'</div>';



					// 이 부분에서 infoHtml을 content로 씀
					var infowindow = new google.maps.InfoWindow({ content: infoHtml });

                    // [1] 각 마커마다 별도의 infowindow 선언
  //                var infowindow = new google.maps.InfoWindow({ content: "<b>" + r.name + "</b>" });

                    // [2] 마우스 오버시 이름 infoWindow 열기
                    marker.addListener('mouseover', function() {
                        infowindow.open(map, marker);
                    });

                    // [3] 마우스 아웃시 infoWindow 닫기
                    marker.addListener('mouseout', function() {
                        infowindow.close();
                    });

                    // [4] 클릭 시 상세페이지 이동
                    marker.addListener('click', function() {
                        window.location.href = "restaurantDetail?res_id=" + r.id;
                        });
                    
                }
            });
        }, function() {
            // 위치 못 잡으면 전체 마커 fitBounds
            var bounds = new google.maps.LatLngBounds();
            addRestaurantMarkers(map, bounds);
            map.fitBounds(bounds);
        });
    } else {
        var bounds = new google.maps.LatLngBounds();
        addRestaurantMarkers(map, bounds);
        map.fitBounds(bounds);
    }
}

    // 내 위치로 이동 버튼 클릭 이벤트 연결
    document.getElementById('moveToMyLocationBtn').onclick = function() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(pos) {
                var myLat = pos.coords.latitude;
                var myLng = pos.coords.longitude;
                var myLatLng = { lat: myLat, lng: myLng };
                map.setCenter(myLatLng);
                map.setZoom(18);
                new google.maps.Marker({
                    map: map,
                    position: myLatLng,
                    title: "내 위치",
                    icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"
                });
            }, function() {
                alert('위치 정보를 불러올 수 없습니다.');
            });
        } else {
            alert('브라우저가 위치 정보를 지원하지 않습니다.');
        }
    };

	
</script>


<script src="https://maps.googleapis.com/maps/api/js?key=${GOOGLE_API_KEY}&callback=initMap" async defer></script>

</body>
</html>
