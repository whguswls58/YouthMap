<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>${restaurant.res_subject}- 상세 정보</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<script>
    // 모든 사진 배열 생성 (대표 + 여분)
    const photos = [
      '<c:out value="${restaurant.res_photo_url}" escapeXml="false"/>'
      <c:if test="${not empty extraPhotoUrls}">
        <c:forEach var="url" items="${extraPhotoUrls}" varStatus="st">
          , '<c:out value="${url}" escapeXml="false"/>'
        </c:forEach>
      </c:if>
    ];

    // 메인 사진 인덱스
    let currentMainIndex = 0;
    function updateMainPhoto(idx) {
      currentMainIndex = idx;
      document.getElementById('mainPhoto').src = photos[idx];
    }
    function prevMainPhoto() {
      updateMainPhoto((currentMainIndex - 1 + photos.length) % photos.length);
    }
    function nextMainPhoto() {
      updateMainPhoto((currentMainIndex + 1) % photos.length);
    }

    // 모달 인덱스 및 함수
    let currentModalIndex = 0;
    function openModalAt(idx) {
      currentModalIndex = idx;
      document.getElementById('modalImg').src = photos[idx];
      document.getElementById('imgModal').style.display = 'flex';
    }
    function prevModal() {
      currentModalIndex = (currentModalIndex - 1 + photos.length) % photos.length;
      document.getElementById('modalImg').src = photos[currentModalIndex];
    }
    function nextModal() {
      currentModalIndex = (currentModalIndex + 1) % photos.length;
      document.getElementById('modalImg').src = photos[currentModalIndex];
    }
    function closeModal() {
      document.getElementById('imgModal').style.display = 'none';
    }

    document.addEventListener('DOMContentLoaded', () => {
      updateMainPhoto(0);
    });
  </script>
 <!-- CSS 파일 로드 -->
  <link rel="stylesheet" href="<c:url value='/css/res/res_detail.css'/>" />

  <!-- Swiper CSS -->
  <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css"/>

<script>
	function showMainPhoto(url) {
		document.getElementById('mainPhoto').src = url;
	}
</script>

</head>
<body>
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>




	<div class="detail-container">
    <!-- 메인 사진 + 좌우 버튼 -->
    <div class="main-photo-container">
      <button id="mainPrev" class="photo-nav" onclick="prevMainPhoto()">‹</button>
      <img
        id="mainPhoto"
        src=""
        alt="대표 사진"
        onclick="openModalAt(currentMainIndex)"
      />
      <button id="mainNext" class="photo-nav" onclick="nextMainPhoto()">›</button>
    </div>
    
		<!-- 여분 사진(썸네일) -->
		<c:if test="${not empty extraPhotoUrls}">
			<div class="photos-container" >
				<c:forEach var="img" items="${extraPhotoUrls}">
					<img src="${img}" class="thumb">
				</c:forEach>
			</div>
		</c:if>

		<!-- 모달 (확대이미지) -->
		<div id="imgModal" calss="imgModal">
			<img id="modalImg" calss="modalImg">
		</div>

		<script>
			document.addEventListener('DOMContentLoaded',
					function() {document.querySelectorAll('.thumb')
										.forEach(
					function(img) {img.addEventListener('click',
					function() {document.getElementById('modalImg').src = this.src;
								document.getElementById('imgModal').style.display = 'flex';
					});
				});
			document.getElementById('imgModal').onclick = function() {
				this.style.display = 'none';
						};
				});
		</script>
		


		<!-- 음식점명 & 별점 -->
		<div class="res-title">
			${restaurant.res_subject} <span class="res-score">★
				${restaurant.res_score} <%-- 리뷰/ ${restaurant.user_ratings_total}개 --%>
			</span>
		</div>
		<table class="info-table">
			<tr>
				<th>주소</th>
				<td>${restaurant.res_address}</td>
			</tr>
			<tr>
				<th>전화</th>
				<td><c:out value="${restaurant.res_tel}" default="-" /></td>
			</tr>
			<tr>
				<th>가격대</th>
				<td><c:choose>
						<c:when test="${restaurant.res_price_level == 0}">무료~저렴</c:when>
						<c:when test="${restaurant.res_price_level == 1}">저렴</c:when>
						<c:when test="${restaurant.res_price_level == 2}">중간</c:when>
						<c:when test="${restaurant.res_price_level == 3}">비쌈</c:when>
						<c:when test="${restaurant.res_price_level == 4}">매우 비쌈</c:when>
						<c:otherwise>정보 없음</c:otherwise>
					</c:choose></td>
			</tr>
			<tr>
				<th>영업상태</th>
				<td>${restaurant.res_status} (<c:choose>
						<c:when test="${restaurant.res_open=='true'}">영업중</c:when>
						<c:otherwise>휴업</c:otherwise>
					</c:choose>)
				</td>
			</tr>
			<tr>
				<th>영업시간</th>
				<td><pre style="margin: 0; font-family: inherit;">${restaurant.res_open_hours}</pre></td>
			</tr>
		</table>
		<!-- 버튼 그룹 -->
		<div class="button-group">
			<c:if test="${not empty restaurant.res_website}">
				<a href="${restaurant.res_website}" target="_blank" class="btn">
					공식 웹사이트 바로가기 </a>
			</c:if>
			<a href="restaurants" class="btn"> 목록으로 </a>
		</div>
		<!-- 지도 & 리뷰 영역 전체를 감싸는 container -->
		<div class="detail-container">
			<!-- 지도 -->
			<div class="section" style="text-align: center;">
				<!-- 라벨을 block으로 위에 고정 -->
				<span class="label">위치 지도</span>
				<c:if
					test="${not empty restaurant.res_latitude && not empty restaurant.res_longitude}">
					<iframe width=90% height="320"
						style="border-radius: 13px; border: 1.5px solid #eee; margin-top: 10px;"
						frameborder="0" style="border:0"
						src="https://maps.google.com/maps?q=${restaurant.res_latitude},${restaurant.res_longitude}&z=17&output=embed"
						allowfullscreen> </iframe>
				</c:if>
			</div>

		</div>


		<!-- 리뷰 영역 전체 -->
		<div class="review-section">
			<div class="review-header">
				<h3>리뷰</h3>
				<!-- 필요시 리뷰 개수, 글자수 카운트 등 추가 가능 -->
			</div>
			<!-- 리뷰 입력 폼 -->
			<div class="review-form">
				<c:choose>
					<c:when test="${not empty sessionScope.loginMember}">
						<form action="${pageContext.request.contextPath}/reviewwrite" method="post" enctype="multipart/form-data">
							<input type="hidden" name="res_id" value="${restaurant.res_id}" />
							<select name="review_score1" id="review_score1" required style="width: 90px; min-width: 70px; padding: 10px 6px; font-size: 15px; border: 1px solid #ddd; border-radius: 4px; margin-right: 8px;">
									<option value="">별점</option>
									<option value="5">★★★★★</option>
									<option value="4">★★★★</option>
									<option value="3">★★★</option>
									<option value="2">★★</option>
									<option value="1">★</option>
								</select>
							<div class="review-form-wrapper">
								
								<textarea name="review_content1" id="review_content1" maxlength="500" required placeholder="리뷰를 입력하세요..." style="flex-grow:1;"></textarea>
								<button type="submit">작성</button>
							</div>
							<div style="margin-top: 8px;">
								<label for="review_file1" style="font-weight: normal; color: #666; margin-right: 8px;">첨부파일</label>
								<input type="file" name="review_file11" id="review_file1" accept="image/*">
							</div>
						</form>
					</c:when>
					<c:otherwise>
						<div class="review-login-prompt">
							<a href="${pageContext.request.contextPath}/login" style="color:#3498db; font-weight:bold; text-decoration:underline;">로그인</a> 후 리뷰 작성이 가능합니다.
						</div>
					</c:otherwise>
				</c:choose>
			</div>
			<!-- 리뷰 리스트 -->
			<ul class="review-list">
				<c:forEach var="rev" items="${reviewlist}">
					<li class="review-item">
						<div class="review-body">
							<div class="review-author-line">
								<span class="review-author"><c:out value="${rev.mem_name}" /></span>
								<span class="review-info">${rev.review_register1}</span>
								<span style="color: #ffa500; letter-spacing: 1px;">
									<c:forEach var="i" begin="1" end="${rev.review_score1}">★</c:forEach>
									<c:forEach var="i" begin="${rev.review_score1+1}" end="5">☆</c:forEach>
								</span>
							</div>
							<div class="review-text">
								<c:out value="${rev.review_content1}" />
							</div>
							<c:if test="${not empty rev.review_file1}">
								<div style="margin: 8px 0 0 0;">
									<img src="/reviewfileview?filename=${rev.review_file1}&origin=${rev.review_file1}" alt="첨부이미지" style="max-width: 120px; border-radius: 8px; box-shadow: 0 1px 8px #eee;">
								</div>
							</c:if>
							<c:if test="${not empty sessionScope.loginMember and sessionScope.loginMember.memNo == rev.mem_no}">
								<div class="review-actions">
									<button type="button" class="reviewEditBtn" data-reviewid="${rev.review_id1}">수정</button>
									<a href="${pageContext.request.contextPath}/reviewdelete?review_id1=${rev.review_id1}&res_id=${rev.res_id}" onclick="return confirm('정말 삭제하시겠습니까?');" class="delete-btn">삭제</a>
								</div>
							</c:if>
							<div id="reviewEditForm${rev.review_id1}" class="review-edit-form" style="display: none; background: #f8f9fa; border: 1px solid #ccc; border-radius: 9px; padding: 20px; margin-top: 10px;">
								<form action="${pageContext.request.contextPath}/reviewedit" method="post" enctype="multipart/form-data">
									<input type="hidden" name="review_id1" value="${rev.review_id1}" />
									<input type="hidden" name="res_id" value="${rev.res_id}" />
									<input type="hidden" name="old_file" value="${rev.review_file1}" />
									<div>
										<label>별점</label>
										<select name="review_score1" required>
											<option value="5" <c:if test="${rev.review_score1 == 5}">selected</c:if>>★★★★★</option>
											<option value="4" <c:if test="${rev.review_score1 == 4}">selected</c:if>>★★★★</option>
											<option value="3" <c:if test="${rev.review_score1 == 3}">selected</c:if>>★★★</option>
											<option value="2" <c:if test="${rev.review_score1 == 2}">selected</c:if>>★★</option>
											<option value="1" <c:if test="${rev.review_score1 == 1}">selected</c:if>>★</option>
										</select>
									</div>
									<div>
										<label>내용</label>
										<textarea name="review_content1" required>${rev.review_content1}</textarea>
									</div>
									<div>
										<label>사진 첨부</label>
										<input type="file" name="review_file11" accept="image/*" />
										<c:if test="${not empty rev.review_file1}">
											<div>기존: <img src="/reviewfileview?filename=${rev.review_file1}&origin=${rev.review_file1}" style="max-width: 70px; vertical-align: middle;"></div>
										</c:if>
									</div>
									<div style="margin-top: 10px;">
										<input type="submit" value="수정완료" style="padding: 7px 22px;">
										<button type="button" onclick="closeReviewEditForm('${rev.review_id1}')" style="padding: 7px 22px;">취소</button>
									</div>
								</form>
							</div>
						</div>
					</li>
				</c:forEach>
				<c:if test="${empty reviewlist}">
					<li style="text-align: center; color: #aaa; padding: 30px 0;">등록된 리뷰가 없습니다.</li>
				</c:if>
			</ul>
		</div>
	</div>
	<!-- map & review detail-container 닫는 태그 -->

	<!-- 페이지네이션 -->
	<c:if test="${totalpage > 1}">
		<div style="text-align: center; margin: 30px 0;">
			<c:forEach var="i" begin="1" end="${totalpage}">
				<c:choose>
					<c:when test="${page == i}">
						<span style="color: #222; font-weight: bold; padding: 0 10px;">${i}</span>
					</c:when>
					<c:otherwise>
						<a href="restaurantDetail?res_id=${restaurant.res_id}&page=${i}"
							style="color: #666; text-decoration: none; padding: 0 10px;">${i}</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</div>
	</c:if>

	<!-- 리뷰 작성/수정 폼 toggle JS -->
	<script>
		// 리뷰수정 폼 (여러 개, 버튼 클릭 시)
		document.addEventListener('DOMContentLoaded', function() {
			document.querySelectorAll('.reviewEditBtn').forEach(
					function(btn) {btn.addEventListener('click',
					function() {document.querySelectorAll('.review-edit-form').forEach(
					function(div) {div.style.display = 'none';
								});
						var id = btn.getAttribute('data-reviewid');
						document.getElementById('reviewEditForm'
						+ id).style.display = 'block';
							});
					});
		});

		function closeReviewEditForm(id) {
			document.getElementById('reviewEditForm' + id).style.display = 'none';
		}
	</script>


</body>
</html>
