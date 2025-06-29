<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정책 통합 검색 페이지</title>

<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/policy/policy-main.css" />

</head>
<body>
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- Hero 배너 -->
<section class="hero-banner"></section>


<div class="search-wrapper">
	<form onsubmit="return submitSearchForm(event);" class="search-bar" method="get" >
  		<div class="search-combined">
  			<input type="hidden" name="mainCategory" value="youthPolicy" />
  			<select	name="mainCategory" class="category-select" disabled>
				<option value="youthPolicy" selected>청년정책</option>
				<option value="culture">문화생활</option>
				<option value="food">맛집</option>
			</select>

			<input type="text" name="searchInput" placeholder="검색어를 입력하세요" />
	  		<input type="submit" value="검색" />
  		</div>
  		
  		<div class="category-container">
			<c:forEach var="cat" items="${categoryList}">
				<div class="category-group">
					<div class="category-header">
				    	<img src="${pageContext.request.contextPath}/img/policy/policyIcon/${cat.icon}" width="40" />
				      	<p><strong>${cat.name}</strong></p>
					</div>
					<div class="btn-group-vertical subcategory-group" data-category="${cat.name}" data-toggle="buttons">
						<c:forEach var="sub" items="${cat.subcategories}">
						  	<label class="btn btn-default btn-pill">
						    	<input type="checkbox" name="${cat.name}" value="${sub}" />
						        <span class="check-icon">✔</span> ${sub}
						     </label>
						</c:forEach>
					</div>
				</div>
			</c:forEach>
		</div>
		<div id="search-button">
			<input type="submit" value="검색">		
			<input type="reset" value="초기화">		
		</div>
	</form>
</div>

<!-- 검색 전 보여줄 콘텐츠 -->
<div id="pre-search-content" class="pre-search-content">
<section class="slider-section">
<div class="popular-policy"><p>인기 정책</p></div>
<div class="swiper-container">
  <div class="swiper-wrapper">
    <c:forEach var="p" items="${pmList}">
      <div class="swiper-slide">
        <div class="policy-card">
          <!-- 라벨 -->
	      <div style="position: relative;">
	          <c:choose>
	              <c:when test="${empty p.aply_ymd_strt}">
	                  <span class="policy-label">상시</span><br />
	              </c:when>
	              <c:otherwise>
	                  <c:set var="dday" value="p.aply_ymd_end" />
	                  <span class="policy-label dday-red">
	                  </span><br />
	              </c:otherwise>
	          </c:choose>
	          <c:forEach var="lclsf" items="${p.lclsf_nms}">
		          <span class="policy-label">${lclsf}</span>
	          </c:forEach>
	          
<!-- 			  <span class="star-wrapper" style="position: absolute; right: 0;"> -->
<%-- 			  	<svg class="star-icon" data-filled="false" data-plcy-no=${p.plcy_no } --%>
<!-- 				     xmlns="http://www.w3.org/2000/svg" fill="none" stroke="gold" stroke-width="2" -->
<!-- 				     width="20" height="20" viewBox="0 0 24 24" style="cursor: pointer;"> -->
<!-- 				    <path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 -->
<!-- 				             9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /> -->
<!-- 				</svg> -->
<!-- 			  </span> -->
				
	      </div>
	      <!-- 링크 및 내용 -->
	        <a href="${pageContext.request.contextPath}/policyContent?page=${page}&plcy_no=${p.plcy_no}">
	            <div class="policy-title">${p.plcy_nm}</div>
	            <div class="policy-desc">
	                <c:out value="${p.plcy_expln_cn}" default="설명이 없습니다." />
	            </div>
	            <div>
	                <strong>신청기간</strong>
	                <span class="policy-label">
	                    <c:choose>
	                        <c:when test="${empty p.aply_ymd_strt}">
	                            상시
	                        </c:when>
	                        <c:otherwise>
	                            ${p.aply_ymd_strt} ~ ${p.aply_ymd_end}
	                        </c:otherwise>
	                    </c:choose>
	                </span>
	            </div>
	        </a>
	         <!-- 자세히 보기 버튼 -->
<%-- 	        <a href="${pageContext.request.contextPath}/policyContent?page=${page}&plcy_no=${p.plcy_no}" --%>
<!-- 	           class="detail-btn"> -->
<!-- 	            자세히보기 -->
<!-- 	        </a> -->

	        <!-- 키워드 태그 -->
	        <div class="policy-tags">
	            <c:choose>
	                <c:when test="${not empty p.plcy_kywd_nm}">
	                	<c:forEach var="kywd" items="${p.plcy_kywd_nms}">
	                    	<span class="policy-tag">${kywd}</span>
	                	</c:forEach>
	                </c:when>
	                <c:otherwise>
	                    <span class="policy-tag">키워드 없음</span>
	                </c:otherwise>
	            </c:choose>
	        </div>
        </div>
      </div>
    </c:forEach>
  </div>
</div>
</section>


</div>

<!-- 검색 결과 갯수 -->
<div id="policy-search-count" class="policy-search-count hidden"></div>

<!-- 검색 결과 출력 컨테이너 -->
<div id="policy-container" class="policy-container hidden"></div>

<!-- 검색 결과 페이징 처리 -->
<div id="pagination" class="pagination hidden" style="text-align:center; margin-top: 20px;"></div>

<script>
	<!-- 파일 경로 전역변수 -->
  	const contextPath = "${pageContext.request.contextPath}";
	<!-- 헤더의 목록에서 선택된 카테고리 항목 리스트 -->
   	selectedCategories = [
   	  <c:forEach var="cat" items="${selectedCategories}" varStatus="status">
   	    "${cat}"<c:if test="${!status.last}">, </c:if>
   	  </c:forEach>
   	];
   	console.log("main.jsp 출력 : " + selectedCategories);
</script>

<!-- 메인 script -->
<script src="${pageContext.request.contextPath}/js/policy/policy-main.js"></script>

<!-- Swiper JS -->
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

<script>
//   document.addEventListener('DOMContentLoaded', function () {
//     document.querySelectorAll('.star-icon').forEach(star => {
//       star.addEventListener('click', function () {
//         const isFilled = this.getAttribute('data-filled') === 'true';
//         const plcyNo = this.getAttribute('data-plcy-no');

//         // UI 토글
//         this.setAttribute('fill', isFilled ? 'none' : 'gold');
//         this.setAttribute('data-filled', isFilled ? 'false' : 'true');

//         // 서버 호출
//         const url = '/policyFavorite';
//         const method = isFilled ? 'DELETE' : 'POST';

//         fetch(url, {
//           method: method,
//           headers: {
//             'Content-Type': 'application/json'
//           },
//           body: JSON.stringify({ plcy_no: plcyNo })
//         })
//         .then(res => {
//           if (!res.ok) throw new Error("서버 오류");
//           return res.text();
//         })
//         .then(msg => console.log(`서버 응답: \${msg}`))
//         .catch(err => console.error("요청 실패", err));
//       });
//     });
//   });
</script>
<!-- 푸터 -->
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>