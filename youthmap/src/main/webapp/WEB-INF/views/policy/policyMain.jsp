<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정책 통합 검색 페이지</title>

<style>
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
/* 네비게이션바 */
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

/* body */
body {
  font-family: 'Playfair Display', serif;
  margin: 0;
  padding: 0;
  background-color: #fff;
  color: #333;
}

/* 검색컨테이너 */
.search-wrapper {
  	display: flex;
  	justify-content: center;
  	margin: 50px 0;
  	position: relative;
  	z-index: 1;
}

/* 검색바 */
.search-bar {
	display: flex;
  	align-items: center;
  	background: #f2f2f2;
  	padding: 20px 40px;
  	border-radius: 12px;
  	box-shadow: 0 4px 8px rgba(0,0,0,0.05);
  	gap: 12px;
  	width: fit-content; 		/* 내부 크기에 맞춤 */
    max-width: 100%;     		/* 모바일 대응 */
    flex-direction: column; 	/* 내부 항목 세로 정렬 */
    align-items: center;
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

/* 검색창 */
.search-combined input[type="text"] {
  border: none;
  padding: 12px 16px;
  font-size: 14px;
  width: 100%;
  outline: none;
}

/* 검색버튼 */
.search-bar input[type="submit"] {
  padding: 12px 20px;
  background-color: #888;
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: bold;
  cursor: pointer;
}

/* 초기화 버튼 */
.search-bar input[type="reset"] {
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

.search-buttons {
  display: flex;
  gap: 10px;
}

/* 셀렉트 박스 */
.category-select {
	padding: 8px;
	border: none;
	background: transparent;
	font-size: 1em;
}

/* 체크박스 css */
.subcategory-group input[type="checkbox"] {
  display: none;
}

.category-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 20px;
}

.category-group {
  display: inline-block;
  margin: 20px;
  vertical-align: top;
}

.category-header {
  text-align: center;
  margin-bottom: 10px;
  background-color: #f2f2f2;
  justify-content: center;
  align-items: center;
  
}

.category-header img {
  margin-bottom: 5px;
}

.btn-group-vertical {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.btn-pill {
  border: 1.5px solid #ccc;
  border-radius: 30px;
  min-width: 160px;
  text-align: center;
  transition: all 0.3s ease;
  font-size: 14px;
}

.btn.active {
  background-color: #eaf1ff;
  border-color: #0066ff;
  color: #0066ff;
  font-weight: bold;
}

.check-icon {
  margin-right: 5px;
  display: none;
}

.btn.active .check-icon {
  display: inline;
}


a {
	text-decoration: none;
	color: #888;
	margin: 0 5px;
}

a:hover {
	text-decoration: underline;
	color: #666;
}

.keyword {
  font-size: 0.9em;
  color: #555;
  margin: 4px 0 0 10px;
}

/* 인기 정책 */
.popular-policy {
  max-width: 1170px;
  margin: 0 auto;
  padding: 0 40px;
  box-sizing: border-box;
}

/* ---------------------------------------------- */
/* 베이지 배경을 살짝만 크게 */
.slider-section {
  background-color: #f5f0e6;
  height:400px;
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
  width: 100%;
  max-width: 1020px;            /* 필요에 따라 조절 */
  margin: 0 auto;               /* 가운데 정렬 */
  overflow: hidden;
  padding: 0 10px;              /* 좌우 여백 */
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
    overflow: hidden;  /* 중요: 넘침 방지 */
 }
/* 슬라이더 카드 크기 키우기 */
.swiper-slide {
 /* slide 자체 너비를 늘려서 사진을 크게 보여줍니다 */
  width: 300px !important;
  box-sizing: border-box;
  flex-shrink: 0;
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


/* ---------------------------------------------- */

/* 검색 결과 출력 컨테이너 */
.policy-container {
  display: grid;
  grid-template-columns: repeat(3, 1fr); /* 가로 3개 */
  gap: 20px;
  max-width: 1000px;
  margin: 0 auto;
}

/* 검색 결과 갯수 */
.policy-search-count{
  display: flex;
  justify-content: space-between; /* 좌우 정렬 */
  align-items: center;            /* 수직 가운데 정렬 */
  padding: 10px 0;
  width:100%;
  max-width: 1000px;
  margin: 0 auto;
}

.policy-search-count select{
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
  width: 100px;

}

.policy-card {
  border: 1px solid #ddd;
  border-radius: 10px;
  padding: 15px;
  width: 300px;
  background-color: #fff;
  vertical-align: top;
  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
}

.policy-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.policy-title {
  font-weight: bold;
  font-size: 16px;
  margin: 10px 0 5px;
}

.policy-desc {
  font-size: 14px;
  color: #555;
  height: 40px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;		 /* 한줄 제한 */
}

.policy-label {
  font-size: 12px;
  color: #777;
  margin-right: 5px;
  display: inline-block;
  padding: 3px 8px;
  background: #eee;
  border-radius: 12px;
  
}

/* D-Day 10일 이하 css */
.dday-red {
  color: red;
  font-weight: bold;
}


.detail-btn {
  display: block;
  margin-top: 15px;
  border:none; 
  border-radius: 5px;
  padding: 10px 28px;
  background-color: #888;
  color: #fff;
  font-size:17px; 
  cursor:pointer;
  text-align: center;
  text-decoration: none;
  
  
}

.detail-btn:hover {
  background-color: #666;
  color: white;
}

.policy-tag {
  display: inline-block;
  padding: 3px 8px;
  background: #eee;
  border-radius: 12px;
  font-size: 12px;
  margin: 3px 3px 0 0;
}

/* 페이징 스타일 */
.pagination {
	text-align: center;
	margin: 30px 0;
	font-size: 18px;
}
.page-btn {
	color: #666;
	background: #fff;
	text-decoration: none;
	margin: 0 6px;
	padding: 6px 12px;
	border-radius: 6px;
	border: 1px solid transparent;
	transition: background 0.2s, color 0.2s;
}
.page-btn.active {
	background: #f2f2f2;
	font-weight: bold;
}
.pagination b {
	color: #222;
	font-weight: bold;
	padding: 6px 12px;
	background: #e0e0e0;
	border-radius: 6px;
}
</style>
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
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

<!--  네비게이션 구조 -->
<div class="navbar">
  	<div class="navbar-left">
		<a href="#" class="nav-link">About</a>
	    <a href="${pageContext.request.contextPath}/policyMain?selectedCategory=일자리" class="nav-link">Facility</a>
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
	<br>

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
				    	<img src="${pageContext.request.contextPath}/policy/policyIcon/${cat.icon}" width="40" />
				      	<p><strong>${cat.name}</strong></p>
						<label>
							<input type="checkbox" class="check-all" data-target="${cat.name}" /> 전체
						</label>
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
	      <div>
	          <c:choose>
	              <c:when test="${empty p.aply_ymd_strt}">
	                  <span class="policy-label">상시</span><br />
	              </c:when>
	              <c:otherwise>
	                  <c:set var="dday" value="p.aply_ymd_end" />
<%-- 	                  <c:set var="ddayVal" value="${fn:replace(dday, '-', '')}" /> --%>
	                  <%-- 실제 D-day 계산은 서버에서 하거나 커스텀 태그로 처리 필요 --%>
	                  <span class="policy-label dday-red">
	                      D-10
	                  </span><br />
	              </c:otherwise>
	          </c:choose>
	          <c:forEach var="lclsf" items="${p.lclsf_nms}">
		          <span class="policy-label">${lclsf}</span>
	          </c:forEach>
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
	        <a href="${pageContext.request.contextPath}/policyContent?page=${page}&plcy_no=${p.plcy_no}"
	           class="detail-btn">
	            자세히보기
	        </a>

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
	document.addEventListener("DOMContentLoaded", () => {
	  // 전체 체크박스 클릭 시 → 하위 체크박스 모두 선택/해제
	  document.querySelectorAll('.check-all').forEach(master => {
	    master.addEventListener('change', () => {
	      const category = master.dataset.target;
	      const check = master.checked;
	      const group = document.querySelector(`.subcategory-group[data-category="\${category}"]`);
	      if (!group) return;
	
	      const checkboxes = group.querySelectorAll(`input[type="checkbox"][name="\${category}"]`);
	      checkboxes.forEach(cb => {
	        cb.checked = check;
	        cb.closest('label').classList.toggle('active', check); // 버튼 스타일 적용
	      });
	    });
	  });

	  // 하위 체크박스 클릭 시 → 전체 체크박스 상태 자동 갱신
	  document.querySelectorAll('.subcategory-group input[type="checkbox"]').forEach(cb => {
	    cb.addEventListener('change', () => {
	      const group = cb.closest('.subcategory-group');
	      const category = group.dataset.category;
	
	      const subCheckboxes = group.querySelectorAll(`input[type="checkbox"][name="${category}"]`);
	      const allChecked = [...subCheckboxes].every(box => box.checked);
	
	      const master = document.querySelector(`.check-all[data-target="${category}"]`);
	      if (master) {
	        master.checked = allChecked;
	      }
	
	      // 스타일 적용
	      cb.closest('label').classList.toggle('active', cb.checked);
	    });
	  });
	  const resetButton = document.querySelector('input[type="reset"]');
	  resetButton.addEventListener('click', () => {
	    // 전체 체크박스 해제
	    document.querySelectorAll('.check-all').forEach(master => {
	      master.checked = false;
	    });

	    // 하위 체크박스 해제 및 스타일 제거
	    document.querySelectorAll('.subcategory-group input[type="checkbox"]').forEach(cb => {
	      cb.checked = false;
	      cb.closest('label').classList.remove('active');
	    });
	  });
	  
	  
});
	
</script>

<script>
	let currentSortOrder = "latest"; // 기본값
	window.loadPage = function(page, sortOrder) {
	console.log("loadPage 호출됨. page = ", page);
	console.log(selectedCategories);
	currentSortOrder = sortOrder || currentSortOrder || "latest";
	const order = currentSortOrder;
	console.log("정렬방식 : ", order);
	
	fetch(`${pageContext.request.contextPath}/policyListJson?page=\${page}&
			searchInput=\${encodeURIComponent(currentSearchInput)}&
			mainCategory=\${encodeURIComponent(currentMainCategory)}&
			selectedCategories=\${selectedCategories}&
			sortOrder=\${order}`)  // 백틱(`) 사용!
	 	.then(response =>  	response.json())
	    .then(data => {
		console.log("data:", data);
		
		const preSearch = document.getElementById("pre-search-content");
		const container = document.getElementById("policy-container");
		const countBox = document.getElementById("policy-search-count");
	    const pagination = document.getElementById("pagination");
	    
	    container.innerHTML = "";
	    countBox.innerHTML = "";

	    // 검색 결과 없는 경우
	    if (!data.pmList || data.pmList.length === 0) {
		    container.innerHTML = "<p>데이터가 없습니다.</p>";
		    return;
	    } 
	    
	    // 검색 결과 있는 경우
	    // 검색 전 콘텐츠 숨기기
  		preSearch.style.display = "none";
	    // 검색 후 결과 출력
	    container.classList.remove("hidden");
	    countBox.classList.remove("hidden");
	    pagination.classList.remove("hidden");
	    
	 	// 검색 결과 갯수 출력
		const plcy_cnt = document.createElement("div");
		plcy_cnt.className = "policy-search-count";
		
		console.log(`listcount : \${data.listcount}`);
		
		const plcy_cnt_leftDiv = document.createElement("div");
		const search_result = document.createElement("p");
		search_result.textContent = `검색 된 결과 : \${data.listcount}개`;
		plcy_cnt_leftDiv.appendChild(search_result);
		plcy_cnt.appendChild(plcy_cnt_leftDiv);
		
		
		// 정렬 방식 선택 select box 추가
		const plcy_cnt_rightDiv = document.createElement("div");
		const select = document.createElement("select");
		select.name = "sortOrder";
		select.id = "sortOrder";

		const crntOrder = sortOrder || "latest";
		
		// option: 최신순
		const option1 = document.createElement("option");
		option1.value = "latest";
		option1.textContent = "최신순";
		if (crntOrder === "latest") option1.selected = true;

		// option: 조회순
		const option2 = document.createElement("option");
		option2.value = "views";
		option2.textContent = "조회순";
		if (crntOrder === "views") option2.selected = true;

		// select에 option 추가
		select.appendChild(option1);
		select.appendChild(option2);
		
		select.addEventListener("change", function () {
			  const selected = this.value;
			  console.log("정렬 방식 선택:", selected);
			  currentSortOrder = selected;
			  loadPage(1, selected);
			  // 정렬 기준에 따라 리스트 다시 요청 또는 필터링 로직 추가 가능
		});
		
		plcy_cnt_rightDiv.appendChild(select);

		// select를 div에 추가
		plcy_cnt.appendChild(plcy_cnt_rightDiv);
		const container_search = document.getElementById("policy-search-count");
	    container_search.innerHTML = "";
		container_search.appendChild(plcy_cnt);

		
	    console.log("data.pmList 출력 확인:", data.pmList);
		data.pmList.forEach(p => {
			console.log("각 항목 확인:", p);
			
			// 카드 박스 생성
		    const card = document.createElement("div");
		    card.className = "policy-card";
		   	
		 	// 라벨
		    const labels = document.createElement("div");
		 	
		    if(p.aply_ymd_strt == null){
		    	let labelHtml = `<span class="policy-label">상시</span><br>`;
 		    	p.lclsf_nms.forEach(lclsf => {
		    		labelHtml += `<span class="policy-label">\${lclsf}</span>`;
		    	});
		    	  
		    	labels.innerHTML = labelHtml;
		    }else{
		    	const dday = getDday(p.aply_ymd_end);
		    	
				// 출력 포맷
		    	let ddayText = '';
				if (parseInt(dday) > 0) {
				    ddayText = `D-\${dday}`;
				} else if (parseInt(dday) === 0) {
					ddayText = "D-Day";
				} else {
					ddayText = `D+\${dday}`;
				}
		    	
		    	let ddayColorClass = '';
		    	if (parseInt(dday) <= 10) {
		    	  ddayColorClass = 'dday-red';
		    	}

		    	let labelHtml = `<span class="policy-label \${ddayColorClass}">\${ddayText}</span><br>`;
 		    	p.lclsf_nms.forEach(lclsf => {
		    		labelHtml += `<span class="policy-label">\${lclsf}</span>`;
		    	});
		    	
			 	labels.innerHTML = labelHtml;
		    	
		    }
		    
		    card.appendChild(labels);
			
		 	const aContent = document.createElement("a");
		 	aContent.href= `${pageContext.request.contextPath}/policyContent?page=\${page}&plcy_no=\${p.plcy_no}`;
 	
		    // 제목
		    const title = document.createElement("div");
		    title.className = "policy-title";
		    title.textContent = p.plcy_nm;
		    aContent.appendChild(title);
		    
		    // 설명
		    const desc = document.createElement("div");
		    desc.className = "policy-desc";
		    desc.textContent = p.plcy_expln_cn || "";
		    aContent.appendChild(desc);
		    
		 	// 신청기간
		    const applyPeriod = document.createElement("div");
		    if(p.aply_ymd_strt != null){
		    	applyPeriod.innerHTML = 
		    		`<strong>신청기간</strong> <span class="policy-label">\${p.aply_ymd_strt} ~ \${p.aply_ymd_end}</span>`;
		    }else{
		    	applyPeriod.innerHTML =
		    		`<strong>신청기간</strong> <span class="policy-label">상시</span>`;
		    }
		    aContent.appendChild(applyPeriod);
		    
		 	// 링크 내 요소 추가 후 카드에 추가
		    card.appendChild(aContent);
		    
		 	// 자세히 보기 버튼
		    const detailBtn = document.createElement("a");
		    detailBtn.href = `${pageContext.request.contextPath}/policyContent?page=${page}&plcy_no=\${p.plcy_no}`;
		    detailBtn.className = "detail-btn";
		    detailBtn.textContent = "자세히보기";
		    card.appendChild(detailBtn);
		    
		    const keywordBox = document.createElement("div");
		    keywordBox.className = "policy-tags";

		    // 정책 키워드가 있을 경우
		    if (p.plcy_kywd_nm) {
		    	p.plcy_kywd_nms.forEach(keyword => {
		    		const keywordTag = document.createElement("span");
		    		keywordTag.className = "policy-tag";
		    		keywordTag.textContent = keyword;
		    		keywordBox.appendChild(keywordTag);
		    	});
		    } else {
		      const noneTag = document.createElement("span");
		      noneTag.className = "policy-tag";
		      noneTag.textContent = "키워드 없음";
		      keywordBox.appendChild(noneTag);
		    }

		    card.appendChild(keywordBox);
			container.appendChild(card);
			
			
			
	    });
	      
	   	// 페이지네이션 렌더링 호출
	    renderPagination(data.page, data.pagecount, data.startpage, data.endpage, currentSortOrder);

	    }).catch(error => console.error("오류 발생:", error));
	}
	
	// 페이지 렌더 처리
	function renderPagination(current, total, start, end, sortOrder) {

		const pagination = document.getElementById("pagination");
		pagination.innerHTML = "";

	    // 처음 페이지
	    pagination.innerHTML += 
	    	`<button class="page-btn" onclick="loadPage(1, '\${sortOrder}')">◀</button> `;

	    // 이전 블록
	    if (start > 6) {
	      pagination.innerHTML += 
	    	  `<button class="page-btn" onclick="loadPage(\${start - 6}, '\${sortOrder}')">[이전]</button> `;
	    } 	//end if

	    // 페이지 번호들
	    for (let i = start; i <= end; i++) {
	      if (i === current) {
	        pagination.innerHTML += `<b>\${i}</b>`;
	      } else {
	        pagination.innerHTML += 
	        	`<button class="page-btn" onclick="loadPage(\${i}, '\${sortOrder}')">\${i}</button>`;
	      }	// end if
	    }	// end for

	    // 다음 블록
	    if (end < total) {
	      pagination.innerHTML += 
	    	  `<button class="page-btn" onclick="loadPage(\${start + 6}, '\${sortOrder}')">[다음]</button> `;
	    }	// end if

	    // 마지막 페이지
	    pagination.innerHTML += 
	    	`<button class="page-btn" onclick="loadPage(\${total}, '\${sortOrder}')">▶</button>`;
	  }		// end function

	// 초기 로딩
	window.addEventListener("DOMContentLoaded", () => {
		currentSearchInput = "";  // 초기화
		currentMainCategory = "youthPolicy";
		// selectedCategories를 JS 배열로 변환하여 저장
		selectedCategories = [
		    <c:forEach var="cat" items="${selectedCategories}" varStatus="status">
		      "${cat}"<c:if test="${!status.last}">, </c:if>
		    </c:forEach>
		  ];

		// 유효한 카테고리 값이 있을 때만 수행
		if (selectedCategories.length > 0 && selectedCategories[0] !== "") {
			selectedCategories.forEach(cat => {
			    const checkbox = document.querySelector(`input[type="checkbox"][value="\${cat}"]`);
			    if (checkbox) {
			      checkbox.checked = true;
			      checkbox.closest("label").classList.add("active");		// CSS에서 시각적으로 선택된 버튼 스타일을 적용
	
			      // 해당 카테고리의 전체 체크박스도 동기화
			      const group = checkbox.closest(".subcategory-group");
			      if (group) {
			        const category = group.dataset.category;
			        const allChecked = [...group.querySelectorAll(`input[type="checkbox"][name="\${category}"]`)].every(box => box.checked);
			        const master = document.querySelector(`.check-all[data-target="\${category}"]`);
			        if (master) master.checked = allChecked;
			      }
			    }
			  });
			
			// DOM 반영 후 비동기 검색 호출
		    requestAnimationFrame(() => {
		      submitSearchForm();
		    });
		}
		
    });		// end window
	
    // 검색어 및 카테고리 상태 저장
    function submitSearchForm(event) {
    	  // 현재 검색어 상태 저장
    	  currentSearchInput = document.querySelector('input[name="searchInput"]').value;	// 현재 검색어
    	  currentMainCategory = document.querySelector('input[name="mainCategory"]').value;	// 대분류
    	  selectedCategories = collectSelectedCategories();		// 선택된 카테고리
    	  
    	  // 첫 페이지로 검색
    	  loadPage(1);
    	  return false;
   	}
    
 	// 체크된 카테고리 리스트에 저장 후 리턴
	function collectSelectedCategories() {
		const checkedInputs = document.querySelectorAll('.subcategory-group input[type="checkbox"]:checked');
		const selectedValues = [];

		checkedInputs.forEach(cb => {
			selectedValues.push(cb.value);
		});
		
		return selectedValues;
	}
    
 	// D-Day 출력
	function getDday(dateStr) {
 		
		if (!dateStr) return "";
 		
		const endDate = new Date(dateStr.slice(0, 4), dateStr.slice(4, 6) - 1, dateStr.slice(6, 8));
	    const today = new Date();
		
	    // 시차 제거
	    endDate.setHours(0, 0, 0, 0);
	    today.setHours(0, 0, 0, 0);

	    const diffTime = endDate.getTime() - today.getTime();
	    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

	    return `\${diffDays}`;
	    
	}
 	
 	
</script>

<!-- Swiper JS 추가 (body 끝 직전에) -->
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

<!-- 슬라이더 -->
<script>
const swiper = new Swiper('.swiper-container', {
	loop: true,
    centeredSlides: false,          // 항상 가운데 슬라이드가 중앙에 오도록
    centerInsufficientSlides: true, // 슬라이드 수가 적을 때도 가운데 정렬
    slidesPerView: 3,               // 한 번에 보여줄 카드 개수
    speed: 5000,               		// 애니메이션 속도 (ms)
	spaceBetween: 60,      			// 카드 간격 
    autoplay: {
      delay: 0,
      disableOnInteraction: false
    },
    freeMode: true,            		// 자연스럽게 끊김 없이 흘러감
    grabCursor: true,          		// 마우스 커서 변경 (UX 개선)
	navigation: {
	  nextEl: '.swiper-button-next',
	  prevEl: '.swiper-button-prev',
	},
	breakpoints: {
	  0:  { slidesPerView: 1 },
	  640:  { slidesPerView: 2 },
	  1024: { slidesPerView: 3 },
	}
});
</script>

</body>
</html>