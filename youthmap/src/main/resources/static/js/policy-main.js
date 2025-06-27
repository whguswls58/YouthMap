// 정책 메인페이지 js

// 전역 상태 변수
let currentSortOrder = "latest";			// 정렬 기준 기본값 : 최신순
let currentSearchInput = "";
let currentMainCategory = "youthPolicy";

// 초기 로딩 이벤트
window.addEventListener("DOMContentLoaded", () => {
	console.log("현재 선택된 카테고리 : " + selectedCategories);
	initializeCheckboxHandlers();
	initializeResetButton();
	restoreSelectedCategories();
	initSwiper();
});

// 전체/하위 체크박스 동기화
function initializeCheckboxHandlers() {
	// 전체 체크박스 클릭 시 → 하위 체크박스 모두 선택/해제
	document.querySelectorAll(".check-all").forEach((master) => {
		master.addEventListener("change", () => {
			const category = master.dataset.target;
			const check = master.checked;
			const group = document.querySelector(`.subcategory-group[data-category="${category}"]`);
			if (!group) return;

			const checkboxes = group.querySelectorAll(`input[type="checkbox"][name="${category}"]`);
			checkboxes.forEach((cb) => {
				cb.checked = check;
				cb.closest("label").classList.toggle("active", check);
			});
		});
	});
	// 하위 체크박스 모두 클릭 시 → 전체 체크박스 상태 자동 갱신
	document.querySelectorAll(".subcategory-group input[type=\"checkbox\"]").forEach((cb) => {
		cb.addEventListener("change", () => {
			const group = cb.closest(".subcategory-group");
			const category = group.dataset.category;

			const subCheckboxes = group.querySelectorAll(`input[type="checkbox"][name="${category}"]`);
			const allChecked = [...subCheckboxes].every((box) => box.checked);

			const master = document.querySelector(`.check-all[data-target="${category}"]`);
			if (master) master.checked = allChecked;
			// 스타일 적용
			cb.closest("label").classList.toggle("active", cb.checked);
		});
	});
}

// 초기화 버튼
function initializeResetButton() {
	const resetButton = document.querySelector('input[type="reset"]');
	resetButton.addEventListener("click", () => {
		// 전체 체크박스 체크 해제
		document.querySelectorAll(".check-all").forEach((master) => {
			master.checked = false;
		});

		// 하위 체크박스 해제 및 스타일 제거
		document.querySelectorAll(".subcategory-group input[type=\"checkbox\"]").forEach((cb) => {
			cb.checked = false;
			cb.closest("label").classList.remove("active");
		});
	});
}

// selectedCategories를 복원하고 검색 수행
function restoreSelectedCategories() {
	// 이 변수는 JSP에서 미리 선언되어야 함
	if (typeof selectedCategories === 'undefined') return;

	// 유효한 카테고리 값이 있을 때만 수행
	if (selectedCategories.length > 0 && selectedCategories[0] !== "") {
		selectedCategories.forEach((cat) => {
			const checkbox = document.querySelector(`input[type=\"checkbox\"][value=\"${cat}\"]`);
			if (checkbox) {
				checkbox.checked = true;
				checkbox.closest("label").classList.add("active");		// CSS에서 시각적으로 선택된 버튼 스타일을 적용

				// 해당 카테고리의 전체 체크박스도 동기화
				const group = checkbox.closest(".subcategory-group");
				if (group) {
					const category = group.dataset.category;
					const allChecked = [...group.querySelectorAll(`input[type="checkbox"][name="${category}"]`)].every(
						(box) => box.checked
					);
					const master = document.querySelector(`.check-all[data-target="${category}"]`);
					if (master) master.checked = allChecked;
				}
			}
		});

		// DOM 반영 후 비동기 검색 호출
		requestAnimationFrame(() => {
			submitSearchForm();
		});
	}
}

// 검색어 및 카테고리 상태 저장 후 검색 실행
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

	return Math.floor(diffTime / (1000 * 60 * 60 * 24));;

}

function initSwiper() {
	new Swiper('.swiper-container', {
		loop: true,
		centeredSlides: false,				// 항상 가운데 슬라이드가 중앙에 오도록
		centerInsufficientSlides: true,		// 슬라이드 수가 적을 때도 가운데 정렬
		slidesPerView: 3,					// 한 번에 보여줄 카드 개수
		speed: 5000,						// 애니메이션 속도 (ms)
		spaceBetween: 60,					// 카드 간격 
		autoplay: {
			delay: 0,
			disableOnInteraction: false
		},
		freeMode: true,						// 자연스럽게 끊김 없이 흘러감
		grabCursor: true,					// 마우스 커서 변경 (UX 개선)
		navigation: {
			nextEl: '.swiper-button-next',
			prevEl: '.swiper-button-prev',
		},
		breakpoints: {
			0: { slidesPerView: 1 },
			640: { slidesPerView: 2 },
			1024: { slidesPerView: 3 },
		}
	});
}

// 비동기 페이지 로딩
window.loadPage = function(page, sortOrder) {
	console.log("loadPage 호출됨. page = ", page);
	console.log(selectedCategories);
	currentSortOrder = sortOrder || currentSortOrder || "latest";
	const order = currentSortOrder;
	console.log("정렬방식 : ", order);

	// 비동기 검색결과 호출
	fetch(`${contextPath}/policyListJson?page=${page}&
			searchInput=${encodeURIComponent(currentSearchInput)}&
			mainCategory=${encodeURIComponent(currentMainCategory)}&
			selectedCategories=${selectedCategories}&
			sortOrder=${order}`).then(response => response.json()).then(data => {
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

		console.log(`listcount : ${data.listcount}`);

		const plcy_cnt_leftDiv = document.createElement("div");
		const search_result = document.createElement("p");
		search_result.textContent = `검색 된 결과 : ${data.listcount}개`;
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

		select.addEventListener("change", function() {
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

			// 상시
			if (p.aply_ymd_strt == null) {
				let labelHtml = `<span class="policy-label">상시</span><br>`;
				p.lclsf_nms.forEach(lclsf => {
					labelHtml += `<span class="policy-label">${lclsf}</span>`;
				});

				labels.innerHTML = labelHtml;
			} else {
				const dday = getDday(p.aply_ymd_end);

				// 출력 포맷
				let ddayText = '';
				if (parseInt(dday) > 0) {
					ddayText = `D-${dday}`;
				} else if (parseInt(dday) === 0) {
					ddayText = "D-Day";
				} else {
					ddayText = `D+${dday}`;
				}

				let ddayColorClass = '';
				if (parseInt(dday) <= 10) {
					ddayColorClass = 'dday-red';
				}

				let labelHtml = `<span class="policy-label ${ddayColorClass}">${ddayText}</span><br>`;
				p.lclsf_nms.forEach(lclsf => {
					labelHtml += `<span class="policy-label">${lclsf}</span>`;
				});

				labels.innerHTML = labelHtml;

			}

			card.appendChild(labels);

			const aContent = document.createElement("a");
			aContent.href = `${contextPath}/policyContent?page=${page}&plcy_no=${p.plcy_no}`;

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
			if (p.aply_ymd_strt != null) {
				applyPeriod.innerHTML =
					`<strong>신청기간</strong> <span class="policy-label">${p.aply_ymd_strt} ~ ${p.aply_ymd_end}</span>`;
			} else {
				applyPeriod.innerHTML =
					`<strong>신청기간</strong> <span class="policy-label">상시</span>`;
			}
			aContent.appendChild(applyPeriod);

			// 링크 내 요소 추가 후 카드에 추가
			card.appendChild(aContent);

			// 자세히 보기 버튼
			const detailBtn = document.createElement("a");
			detailBtn.href = `${contextPath}/policyContent?page=${page}&plcy_no=${p.plcy_no}`;
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
		`<a href="javascript:loadPage(1, '${sortOrder}')">&laquo;</a>`;
	// 이전 블록
	if (start > 6) {
		pagination.innerHTML +=
			`<a href="javascript:loadPage(${start - 6}, '${sortOrder}')">[이전]</a>`;
		} 	//end if

	// 페이지 번호들
	for (let i = start; i <= end; i++) {
		if (i === current) {
			pagination.innerHTML += `<span class="current">${i}</span>`;
		} else {
			pagination.innerHTML +=
				`<a href="javascript:loadPage(${i}, '${sortOrder}')">${i}</a>`;
		}	// end if
	}	// end for

	// 다음 페이지
	if (current < total) {
		pagination.innerHTML +=
			`<a href="javascript:loadPage(${start + 6}, '${sortOrder}')">[다음]</a>`;
	}	// end if

	// 마지막 페이지
	pagination.innerHTML +=
		`<a href="javascript:loadPage(${total}, '${sortOrder}')">&raquo;</a>`;
}		// end function




