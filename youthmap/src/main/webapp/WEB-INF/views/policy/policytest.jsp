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

a {
	text-decoration: none;
	color: #007bff;
	margin: 0 5px;
}

a:hover {
	text-decoration: underline;
}
</style>

<script>
	function loadPage(page) {
	  fetch(`/policyListJson?page=${page}`)  // ✅ 백틱(`) 사용!
	    .then(response => response.json())
	    .then(data => {
	      const container = document.getElementById("policy-container");
	      container.innerHTML = "";

	      if (!data.pm || data.pm.length === 0) {
	        container.innerHTML = "<p>데이터가 없습니다.</p>";
	        return;
	      } else{
	    	  
		      data.pm.forEach(p => {
		        const div = document.createElement("div");
		        div.className = "policy-item";
		        div.innerHTML = `<a href="/policyContent?plcy_no=${p.plcy_no}">${p.plcy_nm}</a>`;
		        container.appendChild(div);
	    	  
	      	}

	      });
	      
	   	  // 페이지네이션 렌더링 호출
	      renderPagination(data.page, data.pagecount, data.startpage, data.endpage);

	      // (선택) 검색 결과 개수 갱신
// 	      const resultText = document.getElementById("result-count");
// 	      if (resultText) {
// 	        resultText.innerText = `검색된 결과 : ${data.pm.length}개`;
// 	      }
	      
	    })
	    .catch(error => console.error("오류 발생:", error));
	}
	
	function renderPagination(current, total, start, end) {
		const pagination = document.getElementById("pagination");
		pagination.innerHTML = "";

	    // 처음 페이지
	    pagination.innerHTML += `<button onclick="loadPage(1)">&lt;</button> `;

	    // 이전 블록
	    if (start > 6) {
	      pagination.innerHTML += `<button onclick="loadPage(${start - 6})">[이전]</button> `;
	    } 	//end if

	    // 페이지 번호들
	    for (let i = start; i <= end; i++) {
	      if (i === current) {
	        pagination.innerHTML += `<strong>[${i}]</strong> `;
	      } else {
	        pagination.innerHTML += `<button onclick="loadPage(${i})">${i}</button> `;
	      }	// end if
	    }	// end for

	    // 다음 블록
	    if (end < total) {
	      pagination.innerHTML += `<button onclick="loadPage(${start + 6})">[다음]</button> `;
	    }	// end if

	    // 마지막 페이지
	    pagination.innerHTML += `<button onclick="loadPage(${total})">&gt;</button>`;
	  }		// end function

	  // 초기 로딩
	 window.addEventListener("DOMContentLoaded", () => {
		 loadPage(1);// 처음 페이지 비동기로 불러오기
    });		// end window
	
</script>

</head>
<body>
	<input type=button value="첫 화면" onclick="location.href='/'">
	<br>

	<div class="search-container">
		<form action="${pageContext.request.contextPath}/search" method="get"
			class="search-form">
			<div class="search-box">
				<!-- 카테고리 선택 -->
				<input type="hidden" name="mainCategory" value="youthPolicy" /> <select
					name="mainCategory" class="category-select" disabled>
					<option value="youthPolicy" selected>청년정책</option>
					<option value="culture">문화생활</option>
					<option value="food">맛집</option>
				</select>

				<!-- 검색어 입력 -->
				<input type="text" name="q" class="search-input"
					placeholder="검색어를 입력하세요" />

				<!-- 검색 버튼 -->
				<button type="submit" class="search-button">검색</button>
			</div>
		</form>
	</div>

	검색 된 결과 : ${listcount }개

	<!-- 테스트용 데이터 -->
<!-- 	<div id="policy-container"> -->
		<%-- 초기 목록을 서버에서 출력 (동기 방식) --%>
<%-- 		<c:if test="${not empty pm}"> --%>
<%-- 			<c:forEach var="p" items="${pm}"> --%>
<!-- 				<div class="policy-item"> -->
<%-- 					<a href="/policyContent?plcy_no=${p.plcy_no}">${p.plcy_nm}</a> --%>
<!-- 				</div> -->
<%-- 			</c:forEach> --%>
<%-- 		</c:if> --%>
<%-- 		<c:if test="${empty pm}"> --%>
<!-- 			<p>데이터가 없습니다.</p> -->
<%-- 		</c:if> --%>
<!-- 	</div> -->

<!-- 	<div id="pagination" style="text-align: center;"> -->
		<!-- 처음 페이지 -->
<!-- 		<button onclick="loadPage(1)">&lt;</button> -->

		<!-- 이전 페이지 -->
<%-- 		<c:if test="${startpage > 6}"> --%>
<%-- 			<button onclick="loadPage(${startpage - 6})">[이전]</button> --%>
<%-- 		</c:if> --%>

		<!-- 페이지 번호 -->
<%-- 		<c:forEach var="i" begin="${startpage}" end="${endpage}"> --%>
<%-- 			<c:choose> --%>
<%-- 				<c:when test="${i == page}"> --%>
<%-- 					<strong>[${i}]</strong> --%>
<%-- 				</c:when> --%>
<%-- 				<c:otherwise> --%>
<%-- 					<button onclick="loadPage(${i})">${i}</button> --%>
<%-- 				</c:otherwise> --%>
<%-- 			</c:choose> --%>
<%-- 		</c:forEach> --%>

		<!-- 다음 페이지 -->
<%-- 		<c:if test="${endpage < pagecount}"> --%>
<%-- 			<button onclick="loadPage(${startpage + 6})">[다음]</button> --%>
<%-- 		</c:if> --%>

		<!-- 마지막 페이지 -->
<%-- 		<button onclick="loadPage(${pagecount})">&gt;</button> --%>
<!-- 	</div> -->

<div id="policy-container"></div>

<div id="pagination" style="text-align:center; margin-top: 20px;"></div>


</body>
</html>