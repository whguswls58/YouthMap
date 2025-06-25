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


		<!-- 숨겨진 리뷰작성 폼 -->
		<div id="reviewFormWrap" style="display: none;">
			<div class="review-form-container"
				style="max-width: 400px; margin: 20px auto;">
				<h2 style="text-align: center; margin-bottom: 20px;">리뷰 작성</h2>
				<form action="reviewwrite" method="post"
					enctype="multipart/form-data">
					<input type="hidden" name="res_id" value="${restaurant.res_id}" />

					<div class="review-form-row" style="margin-bottom: 16px;">
						<label for="review_writer">아이디</label> <input type="text"
							name="review_writer" id="review_writer" maxlength="30" required
							placeholder="작성자 닉네임 또는 아이디" style="width: 100%; padding: 8px;">
					</div>

					<div class="review-form-row" style="margin-bottom: 16px;">
						<label for="review_score1">별점</label> <select name="review_score1"
							id="review_score1" required style="width: 100%; padding: 8px;">
							<option value="">선택</option>
							<option value="5">★★★★★ (5점)</option>
							<option value="4">★★★★ (4점)</option>
							<option value="3">★★★ (3점)</option>
							<option value="2">★★ (2점)</option>
							<option value="1">★ (1점)</option>
						</select>
					</div>

					<div class="review-form-row" style="margin-bottom: 16px;">
						<label for="review_content1">내용</label>
						<textarea name="review_content1" id="review_content1"
							maxlength="500" required placeholder="리뷰 내용을 입력해주세요."
							style="width: 100%; padding: 8px;"></textarea>
					</div>

					<div class="review-form-row" style="margin-bottom: 16px;">
						<label for="review_file1">사진 첨부</label> <input type="file"
							name="review_file11" id="review_file1" accept="image/*" />
					</div>

					<div class="review-form-btns" style="text-align: center;">
						<input type="submit" value="작성완료"
							style="padding: 8px 28px; border-radius: 6px; border: none; background: #888; color: #fff; font-size: 16px; cursor: pointer;">
						<button type="button" onclick="closeReviewForm()"
							style="padding: 8px 28px; border-radius: 6px; border: none; background: #888; color: #fff; font-size: 16px; cursor: pointer;">취소</button>
					</div>
				</form>
			</div>
		</div>

		<script>
			// "리뷰 작성" 버튼 클릭 시 폼 보이기
			document.addEventListener('DOMContentLoaded', function() {
				var btn = document.getElementById('reviewWriteBtn');
				var formDiv = document.getElementById('reviewFormWrap');
				if (btn && formDiv) {
					btn.onclick = function() {
						formDiv.style.display = 'block';
						btn.style.display = 'none';
					}
				}
			});
			// 취소 누르면 폼 닫기
			function closeReviewForm() {
				document.getElementById('reviewFormWrap').style.display = 'none';
				document.getElementById('reviewWriteBtn').style.display = 'inline-block';
			}
		</script>

		<!-- ★ 리뷰 리스트와 수정 폼 반복 -->
		<div class="detail-container">
			<!-- 리뷰작성 버튼 -->
			<div style="text-align: right; margin: 18px 0;">
				<button id="reviewWriteBtn"
					style="padding: 7px 20px; border-radius: 7px; background: #888; color: #fff; border: none; font-size: 16px; cursor: pointer;">
					리뷰 작성</button>
			</div>
			<h2 style="font-size: 2em; margin-bottom: 16px;">방문자 평가</h2>
			<c:forEach var="rev" items="${reviewlist}">
				<div
					style="border-bottom: 1px solid #eee; padding: 16px 0 10px 0; margin-bottom: 0;">
					<!-- 작성자 & 별점 -->
					<div
						style="display: flex; justify-content: space-between; align-items: center;">
						<span style="font-weight: bold; font-size: 17px;"><c:out
								value="${rev.review_writer}" /></span> <span
							style="color: #555; font-size: 14px;"> <c:out
								value="${rev.review_register1}" />
						</span> <span style="color: #ffa500; letter-spacing: 1px;"> <c:forEach
								var="i" begin="1" end="${rev.review_score1}">★</c:forEach> <c:forEach
								var="i" begin="${rev.review_score1+1}" end="5">☆</c:forEach>
						</span>
					</div>

					<!-- 리뷰 내용 -->
					<div
						style="margin: 10px 0 6px 0; line-height: 1.7; font-size: 16px; color: #333;">
						<c:out value="${rev.review_content1}" />
					</div>
					<!-- 첨부 이미지 -->
					<c:if test="${not empty rev.review_file1}">
						<div style="margin: 8px 0 0 0;">
							<img src="/images/${rev.review_file1}" alt="첨부이미지"
								style="max-width: 120px; border-radius: 8px; box-shadow: 0 1px 8px #eee;">
						</div>
					</c:if>
					<!-- ★ 버튼 영역 (수정/삭제/수정폼 토글) -->
					<div style="text-align: right; margin-top: 7px;">
						<button type="button" class="reviewEditBtn"
							data-reviewid="${rev.review_id1}"
							style="padding: 3px 13px 4px 13px; border-radius: 5px; background: #7f8c8d; color: #fff; border: none; cursor: pointer; font-size: 14px;">
							수정</button>
						<a
							href="reviewdelete?review_id1=${rev.review_id1}&res_id=${rev.res_id}"
							onclick="return confirm('정말 삭제하시겠습니까?');">
							<button
								style="padding: 3px 13px 4px 13px; border-radius: 5px; background: #c0392b; color: #fff; border: none; cursor: pointer; font-size: 14px;">
								삭제</button>
						</a>
					</div>
					<!-- ★ 리뷰 수정 폼 (리스트 내, 처음엔 숨김) -->
					<div id="reviewEditForm${rev.review_id1}" class="review-edit-form"
						style="display: none; background: #f8f9fa; border: 1px solid #ccc; border-radius: 9px; padding: 20px; margin-top: 10px;">
						<form action="reviewedit" method="post"
							enctype="multipart/form-data">
							<input type="hidden" name="review_id1" value="${rev.review_id1}" />
							<input type="hidden" name="res_id" value="${rev.res_id}" /> <input
								type="hidden" name="old_file" value="${rev.review_file1}" />
							<div>
								<label>별점</label> <select name="review_score1" required>
									<option value="5"
										<c:if test="${rev.review_score1 == 5}">selected</c:if>>★★★★★
										(5점)</option>
									<option value="4"
										<c:if test="${rev.review_score1 == 4}">selected</c:if>>★★★★
										(4점)</option>
									<option value="3"
										<c:if test="${rev.review_score1 == 3}">selected</c:if>>★★★
										(3점)</option>
									<option value="2"
										<c:if test="${rev.review_score1 == 2}">selected</c:if>>★★
										(2점)</option>
									<option value="1"
										<c:if test="${rev.review_score1 == 1}">selected</c:if>>★
										(1점)</option>
								</select>
							</div>
							<div>
								<label>내용</label>
								<textarea name="review_content1" required>${rev.review_content1}</textarea>
							</div>
							<div>
								<label>사진 첨부</label> <input type="file" name="review_file11"
									accept="image/*" />
								<c:if test="${not empty rev.review_file1}">
									<div>
										기존: <img src="/images/${rev.review_file1}"
											style="max-width: 70px; vertical-align: middle;">
									</div>
								</c:if>
							</div>
							<div style="margin-top: 10px;">
								<input type="submit" value="수정완료" style="padding: 7px 22px;">
								<button type="button"
									onclick="closeReviewEditForm('${rev.review_id1}')"
									style="padding: 7px 22px;">취소</button>
							</div>
						</form>
					</div>
				</div>
			</c:forEach>
			<c:if test="${empty reviewlist}">
				<div style="text-align: center; color: #aaa;">등록된 리뷰가 없습니다.</div>
			</c:if>
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
		// 리뷰작성 폼
		document.addEventListener('DOMContentLoaded', function() {
			var btn = document.getElementById('reviewWriteBtn');
			var formDiv = document.getElementById('reviewFormWrap');
			if (btn && formDiv) {
				btn.onclick = function() {
					formDiv.style.display = 'block';
					btn.style.display = 'none';
				}
			}

			// 리뷰수정 폼 (여러 개, 버튼 클릭 시)
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
		function closeReviewForm() {
			document.getElementById('reviewFormWrap').style.display = 'none';
			document.getElementById('reviewWriteBtn').style.display = 'inline-block';
		}
	</script>


</body>
</html>
