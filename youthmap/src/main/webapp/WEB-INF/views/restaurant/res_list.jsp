
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>


<title>맛집 리스트</title>
 <!-- CSS 파일 로드 -->
  <link rel="stylesheet" href="<c:url value='/css/res/res_list.css'/>" />

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
		<form class="search-bar" action="restaurants" method="get">
			<div class="search-combined">
				<select name="searchType" id="searchType">
					<option value="res_subject"
						<c:if test="${searchType == 'res_subject'}">selected</c:if>>
						식당이름</option>
					<option value="res_gu"
						<c:if test="${searchType == 'res_gu'}">selected</c:if>>
						구별</option>
				</select> <input type="text" name="keyword" placeholder="검색어 입력"
					value="<c:out value='${keyword}'/>" />
			</div>
			<input type="submit" value="검색" />
			
			
		</form>
	</div>

	<!-- ✅ 구 버튼 -->
	<div class="gu-list <c:if test='${searchType eq \"res_gu\"}'>active</c:if>'">
		<form method="get" action="restaurants">
			<button type="submit" name="res_gu" value=""
				class="gu-btn <c:if test='${empty res_gu}'>active</c:if>">전체</button>
			<c:forEach var="gu" items="${seoulGuList}">
				<button type="submit" name="res_gu" value="${gu}"
					class="gu-btn <c:if test='${res_gu == gu}'>active</c:if>">${gu}</button>
			</c:forEach>

			<input type="hidden" name="searchType" value="res_gu" /> <input
				type="hidden" name="keyword" value="<c:out value='${keyword}'/>" />
		</form>
	</div>




	<!-- 맛집 카드 리스트 -->
	<div class="restaurant-grid">
		<!-- 검색 결과가 없을 때 -->
		<c:if test="${empty restaurants}">
			<div
				style="text-align: center; font-size: 18px; color: #888; margin-top: 20px;">
				검색 결과가 없습니다.</div>
		</c:if>
		<c:forEach var="r" items="${restaurants}">

			<div class="restaurant-card">
				 <!-- 사진이 있을 때 -->
				<c:if test="${not empty r.res_photo_url}">
					<a href="restaurantDetail?res_id=${r.res_id}"> <img
						src="${r.res_photo_url}" alt="대표 사진" />
					</a>
				</c:if>
				<!-- 사진이 없을 때 -->
				<c:if test="${empty r.res_photo_url}">
					<div class="no-img">이미지 없음</div>
				</c:if>
				<div class="restaurant-name">
					<a href="restaurantDetail?res_id=${r.res_id}"
						style="color: #222; text-decoration: none;"> ${r.res_subject}
					</a>
				</div>
				<div class="restaurant-score">★ ${r.res_score}</div>
			</div>
		</c:forEach>
	</div>
	<div class="pagination">
		<c:if test="${listcount > 0}">
			<a
				href="restaurants?page=1&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">◀</a>
			<c:if test="${startpage > 10}">
				<a
					href="restaurants?page=${startpage-10}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">이전</a>
			</c:if>
			<c:forEach var="i" begin="${startpage}" end="${endpage}">
				<c:choose>
					<c:when test="${i == page}">
						<b>${i}</b>
					</c:when>
					<c:otherwise>
						<a
							href="restaurants?page=${i}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">${i}</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<c:if test="${endpage < pagecount}">
				<a
					href="restaurants?page=${startpage+10}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">다음</a>
			</c:if>
			<a
				href="restaurants?page=${pagecount}&res_gu=${res_gu}&searchType=${searchType}&keyword=${keyword}">▶</a>
		</c:if>
	</div>
	<!-- ✅ 스크립트 -->
	<script>
		document.addEventListener("DOMContentLoaded", function() {
			const select = document.getElementById("searchType");
			const keywordIn = document.querySelector('input[name="keyword"]');
			const guList = document.querySelector(".gu-list");
			function toggleGuList() {
				if (select.value === "res_gu") {
					guList.classList.add("active");
				} else {
					guList.classList.remove("active");
				}

			}

			// 셀렉트가 바뀔 때만 키워드 비우고 폼 제출
			select.addEventListener("change", function() {
				toggleGuList();
				keywordIn.value = ""; // 여기서만 초기화
				form.submit();
			});

			// 초기 로딩 시 리스트 표시 설정
			toggleGuList();
		});
	</script>
</body>
</html>
