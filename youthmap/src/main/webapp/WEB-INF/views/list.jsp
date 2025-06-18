<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<title>맛집 리스트</title>
<style>
.gu-btn {
	display: inline-block;
	margin: 6px 8px;
	padding: 9px 22px;
	border: 2px solid #aaa;
	border-radius: 25px;
	background: #fff;
	font-size: 17px;
	cursor: pointer;
	transition: background 0.2s, border 0.2s;
}
.gu-btn.active {
	background: #222;
	color: #fff;
	border-color: #222;
}
.restaurant-grid {
	display: flex;
	flex-wrap: wrap;
	justify-content: center;
	gap: 24px 18px;
	max-width: 900px;
	margin: 25px auto;
}
.restaurant-card {
	width: 30%;
	min-width: 240px;
	box-sizing: border-box;
	border: 1px solid #ccc;
	padding: 14px;
	border-radius: 12px;
	text-align: center;
	background: #fff;
	box-shadow: 0 2px 8px #eee;
	margin-bottom: 28px;
}
.restaurant-card img {
	width: 100%;
	height: 140px;
	object-fit: cover;
	border-radius: 8px;
	background: #fafafa;
}
.restaurant-name {
	font-weight: bold;
	margin-top: 13px;
	font-size: 17px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
.restaurant-score {
	color: #ffa500;
	font-size: 16px;
	margin-top: 6px;
}
/* 반응형 */
@media (max-width: 800px) {
	.restaurant-card { width: 46%; min-width:160px; }
}
@media (max-width: 500px) {
	.restaurant-card { width: 95%; min-width:100px; }
	.restaurant-grid { gap: 20px 0; }
}

/* 검색 input, select, button 한 번에 키움 */
#searchForm select,
#searchForm input[type="text"],
#searchForm input[type="submit"] {
	font-size: 20px;
	padding: 13px 20px;
	height: 52px;
	border-radius: 10px;
}

#searchForm input[type="text"] {
	width: 260px; /* 필요하면 더 크게 */
}

#searchForm input[type="submit"] {
	background: #1976d2;
	color: #fff;
	font-weight: 700;
	border: none;
	transition: background 0.18s
	font-weight: 700;    /* ← 폰트 두껍게! */	;
}

#searchForm input[type="submit"]:hover {
	background: #12549b;
}

</style>
</head>
<body>
<!-- 검색폼 (식당이름 or 구) -->
<div style="text-align:center; margin-bottom:28px;">
	<form action="restaurants" method="get" id="searchForm" style="display:inline;">
		<select name="searchType" id="searchType" onChange="onSearchTypeChange()">
			<option value="res_subject" <c:if test="${searchType=='res_subject'}">selected</c:if>>식당이름</option>
			<option value="res_gu" <c:if test="${searchType=='res_gu'}">selected</c:if>>구  별</option>
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

<!-- ⭐️ 구별 버튼: searchType이 'res_gu'일 때만 보이게 -->
<c:if test="${searchType == 'res_gu'}">
	<div style="text-align:center; margin-bottom:18px;">
		<form id="guForm" method="get" action="restaurants" style="display:inline;">
		<button type="submit" name="res_gu" value="" class="gu-btn <c:if test='${empty res_gu}'>active</c:if>">전체</button>
			<c:forEach var="gu" items="${seoulGuList}">
				<button type="submit" name="res_gu" value="${gu}" class="gu-btn <c:if test='${res_gu == gu}'>active</c:if>">${gu}</button>
			</c:forEach>
			
			<!-- 검색유지용 hidden -->
			<input type="hidden" name="searchType" value="res_gu" />
			<input type="hidden" name="keyword" value="${keyword}" />
		</form>
	</div>
</c:if>

<!-- 맛집 카드 리스트 -->
<div class="restaurant-grid">
	<c:forEach var="r" items="${restaurants}">
		<div class="restaurant-card">
			<c:if test="${not empty r.res_photo_url}">
			<a href="restaurantDetail?res_id=${r.res_id}">
				<img src="${r.res_photo_url}" alt="대표 사진" />
			</a>
			</c:if>
			<div class="restaurant-name">
				<a href="restaurantDetail?res_id=${r.res_id}" style="color:#222; text-decoration:none;">
					${r.res_subject}
				</a>
			</div>
			<div class="restaurant-score">★ ${r.res_score}</div>
		</div>
	</c:forEach>
</div>

<!-- 페이징 -->
<div style="text-align:center; margin:28px 0;">
	<c:if test="${listcount > 0}">
		<a href="restaurants?page=1&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}" style="text-decoration:none"> ◀ </a>
		<c:if test="${startpage > 10}">
			<a href="restaurants?page=${startpage-10}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">[이전]</a>
		</c:if>
		<c:forEach var="i" begin="${startpage}" end="${endpage}">
			<c:choose>
				<c:when test="${i == page}">
					<b>[${i}]</b>
				</c:when>
				<c:otherwise>
					<a href="restaurants?page=${i}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">[${i}]</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		<c:if test="${endpage < pagecount}">
			<a href="restaurants?page=${startpage+10}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">[다음]</a>
		</c:if>
		<a href="restaurants?page=${pagecount}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}" style="text-decoration:none"> ▶ </a>
	</c:if>
</div>
</body>
</html>
