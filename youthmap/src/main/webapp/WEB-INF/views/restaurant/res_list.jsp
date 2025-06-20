	<%@ page contentType="text/html; charset=UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<html>
	<head>
	<title>맛집 리스트</title>
	<style>
	body {
	  font-family: 'Playfair Display', serif;
	  margin: 0;
	  padding: 0;
	  background-color: #fff;
	  color: #333;
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
	
	/* 검색 래퍼 */
.search-wrapper {
  display: flex;
  justify-content: center;
  margin: 50px 0;
  position: relative;
  z-index: 1;
}
/* 검색 래퍼 */
.search-wrapper {
  display: flex;
  justify-content: center;
  margin: 50px 0;
  position: relative;
  z-index: 1;
}

/* 검색 바 */
.search-bar {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 800px;
  padding: 20px 40px;
  gap: 12px;
  background: #f2f2f2;
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
  position: relative;
  z-index: 1;
}

/* 콤보 박스 + 입력 필드 래퍼 */
.search-combined {
  display: flex;
  flex-grow: 1;
  max-width: 760px;
  background: #fff;
  border: 1px solid #ccc;
  border-radius: 6px;
  overflow: hidden;
  position: relative;
  z-index: 2;
}

/* select 스타일 */
.search-combined select {
  width: 160px;
  padding: 12px 20px;
  font-size: 14px;
  border: none;
  border-right: 1px solid #ccc;
  background: #fff
    url('data:image/svg+xml;utf8,<svg fill="black" height="20" viewBox="0 0 24 24" width="20" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/></svg>')
    no-repeat right 10px center;
  background-size: 12px;
  appearance: none;
  outline: none;
  position: relative;
  z-index: 2;
}

/* 텍스트 입력 필드 */
.search-combined input[type="text"],
#keywordInput  {
  flex: 1;
  padding: 12px 16px;
  font-size: 14px;
  border: none;
  outline: none;
}

/* 검색 버튼 */
.search-bar input[type="submit"] {
  padding: 12px 20px;
  background-color: #888;
  color: #fff;
  border: none;
  border-radius: 6px;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.2s;
}

.search-bar input[type="submit"]:hover {
  background-color: #666;
}


	
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
	.restaurant-grid {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 36px 36px;
		max-width: 1000px;
		margin: 30px auto;
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
		transition: all 0.3s ease-in-out;
	}
	
	
	.restaurant-card:hover {
	  transform: translateY(-4px);
	  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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
	/* ✅ 페이징 스타일 */
	.pagination {
	  text-align: center;
	  margin: 30px 0;
	  font-size: 18px;
	}
	.pagination a {
	  color: #666;
	  text-decoration: none;
	  margin: 0 6px;
	  padding: 6px 12px;
	  border-radius: 6px;
	  border: 1px solid transparent;
	  transition: background 0.2s, color 0.2s;
	}
	.pagination a:hover {
	  background: #eee;
	}
	.pagination b {
	  color: #222;
	  font-weight: bold;
	  padding: 6px 12px;
	  background: #e0e0e0;
	  border-radius: 6px;
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
	
	
	<!-- 검색 -->
	
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
  		<input type="text" name="keyword" placeholder="검색어 입력" value="<c:out value='${keyword}'/>" />
  	</div>
  		<input type="submit" value="검색" />
	</form>
	</div>
	
	<!-- ✅ 구 버튼 -->
	<div class="gu-list <c:if test='${searchType eq \"res_gu\"}'>active</c:if>'">
	    <form method="get" action="restaurants">
	     <button type="submit" name="res_gu" value="" class="gu-btn <c:if test='${empty res_gu}'>active</c:if>">전체</button>
	      <c:forEach var="gu" items="${seoulGuList}">
	        <button type="submit" name="res_gu" value="${gu}" class="gu-btn <c:if test='${res_gu == gu}'>active</c:if>">${gu}</button>
	      </c:forEach>
	     
	      <input type="hidden" name="searchType" value="res_gu" />
	      <input type="hidden" name="keyword" value="<c:out value='${keyword}'/>" />
	    </form>
	  </div>
	
	
	
	
	<!-- 맛집 카드 리스트 -->
	<div class="restaurant-grid">
	<!-- 검색 결과가 없을 때 -->
<c:if test="${empty restaurants}">
  <div style="text-align:center; font-size:18px; color:#888; margin-top:20px;">
    검색 결과가 없습니다.
  </div>
</c:if>
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
	<div class="pagination">
	  <c:if test="${listcount > 0}">
	    <a href="restaurants?page=1&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">◀</a>
	    <c:if test="${startpage > 10}">
	      <a href="restaurants?page=${startpage-10}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">이전</a>
	    </c:if>
	    <c:forEach var="i" begin="${startpage}" end="${endpage}">
	      <c:choose>
	        <c:when test="${i == page}">
	          <b>${i}</b>
	        </c:when>
	        <c:otherwise>
	          <a href="restaurants?page=${i}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">${i}</a>
	        </c:otherwise>
	      </c:choose>
	    </c:forEach>
	    <c:if test="${endpage < pagecount}">
	      <a href="restaurants?page=${startpage+10}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">다음</a>
	    </c:if>
	    <a href="restaurants?page=${pagecount}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">▶</a>
	  </c:if>
	</div>
	<!-- ✅ 스크립트 -->
	<script>
document.addEventListener("DOMContentLoaded", function(){
  const select = document.getElementById("searchType");
  const keywordIn = document.querySelector('input[name="keyword"]');
  const guList = document.querySelector(".gu-list");
  function toggleGuList(){
    if (select.value === "res_gu") {
      guList.classList.add("active");
    } else {
      guList.classList.remove("active");
    }
    
  }

  // 셀렉트가 바뀔 때만 키워드 비우고 폼 제출
  select.addEventListener("change", function(){
    toggleGuList();
    keywordIn.value = "";  // 여기서만 초기화
    form.submit();
  });

  // 초기 로딩 시 리스트 표시 설정
  toggleGuList();
});
</script>
	</body>
	</html>
