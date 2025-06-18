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
.search-container {
	text-align: center;
	margin: 20px 0;
}

/* 폼 전체 */
.search-form {
	display: inline-block;
}

/* 검색 박스 래퍼 */
.search-box {
	display: inline-flex;
	align-items: center;
	border: 1px solid #000;
	border-radius: 6px;
	background: #eee;
	overflow: hidden;
}

/* 셀렉트 박스 */
.category-select {
	padding: 8px;
	border: none;
	background: transparent;
	font-size: 1em;
}

/* 검색어 입력창 */
.search-input {
	width: 800px;
	padding: 8px;
	border: none;
	outline: none;
	font-size: 1em;
	background: transparent;
}

/* 검색 버튼 */
.search-button {
	border: none;
	background: #fff;
	padding: 8px 16px;
	cursor: pointer;
	font-size: 1em;
}

/* 체크박스 css */
.subcategory-group input[type="checkbox"] {
  display: none;
}


.icon-checkbox-group {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 20px;
}

.icon-checkbox img {
  width: 48px;
  height: 48px;
  margin-bottom: 8px;
  border: 2px solid transparent;
  border-radius: 12px;
  transition: transform 0.2s ease;
}

.category-group {
  display: inline-block;
  margin: 20px;
  vertical-align: top;
}

.category-header {
  text-align: center;
  margin-bottom: 10px;
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
	color: #007bff;
	margin: 0 5px;
}

a:hover {
	text-decoration: underline;
}

.policy-item {
  margin: 10px 0;
  font-size: 1.2em;
  border: 1px solid black;
}

.keyword {
  font-size: 0.9em;
  color: #555;
  margin: 4px 0 0 10px;
}

.policy-container {
  display: grid;
  grid-template-columns: repeat(3, 1fr); /* 가로 3개 */
  gap: 20px;
  max-width: 1000px;
  margin: 0 auto;
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
}

.detail-btn {
  display: block;
  margin-top: 15px;
  border: 1px solid #337ab7;
  color: #337ab7;
  padding: 6px 12px;
  border-radius: 5px;
  text-align: center;
  text-decoration: none;
}

.detail-btn:hover {
  background-color: #337ab7;
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

</style>

</head>
<body>
	<input type=button value="첫 화면" onclick="location.href='/'">
	<br>

	<div class="search-container">
		<form onsubmit="return submitSearchForm(event);" class="search-form">
			<div class="search-box">
				<!-- 카테고리 선택 -->
				<input type="hidden" name="mainCategory" value="youthPolicy" />
				<select
					name="mainCategory" class="category-select" disabled>
					<option value="youthPolicy" selected>청년정책</option>
					<option value="culture">문화생활</option>
					<option value="food">맛집</option>
				</select>

				<!-- 검색어 입력 -->
				<input type="text" name="searchInput" class="search-input"
					placeholder="검색어를 입력하세요" />
				<input type="hidden" name="page" value="${page }"/>
				<!-- 검색 버튼 -->
				<button type="submit" class="search-button">검색</button>
			</div><br>
			
			<!-- 카테고리 체크박스 -->
			<c:forEach var="cat" items="${categoryList}">
				<div class="category-group">
					<div class="category-header">
				    	<img src="policy/policyIcon/${cat.icon}" width="40" />
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
		</form>
	</div>

<div id="policy-search-count" class="policy-search-count hidden"></div>

<div id="policy-container" class="policy-container hidden"></div>

<div id="pagination" class="pagination hidden" style="text-align:center; margin-top: 20px;"></div>

<script>
	document.addEventListener("DOMContentLoaded", () => {
	  // 전체 체크박스 클릭 시 → 하위 체크박스 모두 선택/해제
	  document.querySelectorAll('.check-all').forEach(master => {
	    master.addEventListener('change', () => {
	      const category = master.dataset.target;
	      const check = master.checked;
		  console.log(category);
		  console.log(check);
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
	});
	
</script>

<script>
	window.loadPage = function(page) {
	console.log("loadPage 호출됨. page = ", page);
	console.log(selectedCategories);

	fetch(`/policyListJson?page=\${page}&
			searchInput=\${encodeURIComponent(currentSearchInput)}&
			mainCategory=\${encodeURIComponent(currentMainCategory)}&
			selectedCategories=\${selectedCategories}`)  // 백틱(`) 사용!
	 	.then(response =>  	response.json())
	    .then(data => {
		console.log("data:", data);
	 	
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
	    container.classList.remove("hidden");
	    countBox.classList.remove("hidden");
	    pagination.classList.remove("hidden");
	    
	    console.log("data.pmList 출력 확인:", data.pmList);
		data.pmList.forEach(p => {
			console.log("각 항목 확인:", p);
			
			// 카드 박스 생성
		    const card = document.createElement("div");
		    card.className = "policy-card";
		   	
		 	// 라벨
		    const labels = document.createElement("div");
		    
		    if(p.aply_ymd_strt == null){
			 	labels.innerHTML = `
			        <span class="policy-label">상시</span><br>
			        <span class="policy-label">\${p.lclsf_nm}</span><br>
			    `;
		    }else{
		    	const ddayText = getDday(p.aply_ymd_end);
		    	console.log(ddayText);
			 	labels.innerHTML = `
			        <span class="policy-label">\${ddayText}</span><br>
			        <span class="policy-label">\${p.lclsf_nm}</span><br>
			    `;
		    	
		    }
		    
		    card.appendChild(labels);
			
		 	const aContent = document.createElement("a");
		 	aContent.href= `/policyContent?page=${page}&plcy_no=\${p.plcy_no}`;
 	
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
		    detailBtn.href = `/policyContent?page=${page}&plcy_no=\${p.plcy_no}`;
		    detailBtn.className = "detail-btn";
		    detailBtn.textContent = "자세히보기";
		    card.appendChild(detailBtn);
		    
		    const keywordBox = document.createElement("div");
		    keywordBox.className = "policy-tags";

		    // 정책 키워드가 있을 경우
		    if (p.plcy_kywd_nm) {
		      const keywordTag = document.createElement("span");
		      keywordTag.className = "policy-tag";
		      keywordTag.textContent = p.plcy_kywd_nm;
		      keywordBox.appendChild(keywordTag);
		    } else {
		      const noneTag = document.createElement("span");
		      noneTag.className = "policy-tag";
		      noneTag.textContent = "키워드 없음";
		      keywordBox.appendChild(noneTag);
		    }

		    card.appendChild(keywordBox);
			container.appendChild(card);
			
			// 검색 결과 갯수 출력
			const plcy_cnt = document.createElement("div");
			plcy_cnt.className = "policy-search-count";
			
			console.log(`listcount : \${data.listcount}`);
			const search_result = document.createElement("p");
			search_result.textContent = `검색 된 결과 : \${data.listcount}개`;
			plcy_cnt.appendChild(search_result);
			
			const container_search = document.getElementById("policy-search-count");
		    container_search.innerHTML = "";
			
			container_search.appendChild(plcy_cnt);
			
	    });
	      
	   	// 페이지네이션 렌더링 호출
	    renderPagination(data.page, data.pagecount, data.startpage, data.endpage);
	      
	    })
	    .catch(error => console.error("오류 발생:", error));
	}
	
	// 페이지 렌더 처리
	function renderPagination(current, total, start, end) {

		const pagination = document.getElementById("pagination");
		pagination.innerHTML = "";

	    // 처음 페이지
	    pagination.innerHTML += `<button onclick="loadPage(1)">&lt;</button> `;

	    // 이전 블록
	    if (start > 6) {
	      pagination.innerHTML += `<button onclick="loadPage(\${start - 6})">[이전]</button> `;
	    } 	//end if

	    // 페이지 번호들
	    for (let i = start; i <= end; i++) {
	      if (i === current) {
	        pagination.innerHTML += `<strong>[\${i}]</strong>`;
	      } else {
	        pagination.innerHTML += `<button onclick="loadPage(\${i})">\${i}</button> `;
	      }	// end if
	    }	// end for

	    // 다음 블록
	    if (end < total) {
	      pagination.innerHTML += `<button onclick="loadPage(\${start + 6})">[다음]</button> `;
	    }	// end if

	    // 마지막 페이지
	    pagination.innerHTML += `<button onclick="loadPage(\${total})">&gt;</button>`;
	  }		// end function

	  // 초기 로딩
	 window.addEventListener("DOMContentLoaded", () => {
		 currentSearchInput = "";  // 초기화
		 currentMainCategory = "youthPolicy";

    });		// end window
	
    // 검색어 및 카테고리 상태 저장
    function submitSearchForm(event) {
    	  event.preventDefault();	// 기본 이동 막기

    	  // 현재 검색어 상태 저장
    	  currentSearchInput = document.querySelector('input[name="searchInput"]').value;	// 현재 검색어
    	  currentMainCategory = document.querySelector('input[name="mainCategory"]').value;	// 대분류
    	  selectedCategories = collectSelectedCategories();		// 선택된 카테고리
    	  
    	  console.log("selectedCategories : " + selectedCategories);
    	  
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
		
		console.log(selectedValues);

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

		// 출력 포맷
		if (diffDays > 0) {
		    return `D-\${diffDays}`;
		} else if (diffDays === 0) {
			return "D-Day";
		} else {
			return `D+\${Math.abs(diffDays || 0)}`;
		}
	}
 	
</script>


</body>
</html>