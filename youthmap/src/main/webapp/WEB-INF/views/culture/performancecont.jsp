<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.example.demo.util.KakaoKeyUtil" %>

<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>
<%@ include file="/WEB-INF/views/culture/tabs.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>VIVAMAP</title>
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
  

  <!-- ① 카카오 JS SDK: YOUR_APP_KEY 부분에 자바스크립트 키를 넣으세요 -->
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=<%= KakaoKeyUtil.getApiKey() %>&libraries=services"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/culture/cont.css"> 
<!-- ② map.js 파일만 import (내부에 SDK 자동로딩 있음) -->
<script src="${pageContext.request.contextPath}/js/culture/map.js"></script>
</head>
<body>

<hr>


<c:set var="ctx" value="${pageContext.request.contextPath }"/>

  <!-- ② 모델로 넘어온 단일 객체를 cul 변수로 셋업 -->
  <c:set var="cul" value="${performancecont}" />

  <div class="containerer">
    <!-- 제목 -->
    <h2>${cul.con_title}</h2>

    <!-- 이미지 + 상세 정보 표 -->
    <div class="detail-flex">
      <div class="thumb">
        <img src="${cul.con_img}" alt="${cul.con_title}" />
      </div>
      <table class="detail-table">
        <tr><th>장소</th>
            <td>${cul.con_location}</td>
        </tr>
        <tr><th>기간</th>
            <td>${cul.con_start_date} ~ ${cul.con_end_date}</td>
        </tr>
        <tr><th>시간</th>
            <td>${cul.con_time}</td>
        </tr>
        <tr><th>대상</th>
            <td>${cul.con_age}</td>
        </tr>
        <tr><th>요금</th>
            <td>${cul.con_cost}</td>
        </tr>
        <tr><th>문의</th>
            <td>
              <a href="${cul.con_link}" target="_blank">홈페이지 바로가기</a>
            </td>
        </tr>
      </table>
    </div>

     <!-- ② 지도 표시 영역 -->
    <div id="map"></div>

<!-- ① 동적 데이터 전달: 위도, 경도, API 키만 전역 변수로 선언 (★ EL/JSTL 값만!) -->
<script>
	// api 제공 데이터가 위도 경도 값이 반대로 되어 있어서 추가함!
  var mapLat = "${cul.con_lot}";     // 위도(lot), 꼭 서버 값!
  var mapLng = "${cul.con_lat}";     // 경도(lat)
  var mapApiKey = "<%= KakaoKeyUtil.getApiKey() %>";
  
</script>
    
    	<!-- 뒤로가기 -->
    <div class="back-container">
  		<a class="back-link" href="#" onclick="href='/performancelist'">
  		  ← 목록으로 돌아가기
  		</a>
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
						<form action="${pageContext.request.contextPath}/performancecont/reviewwrite" method="post" enctype="multipart/form-data">
							<input type="hidden" name="con_id" value="${performancecont.con_id}" />
							<select name="review_score2" id="review_score2" required style="width: 90px; min-width: 70px; padding: 10px 6px; font-size: 15px; border: 1px solid #ddd; border-radius: 4px; margin-right: 8px;">
									<option value="">별점</option>
									<option value="5">★★★★★</option>
									<option value="4">★★★★</option>
									<option value="3">★★★</option>
									<option value="2">★★</option>
									<option value="1">★</option>
								</select>
							<div class="review-form-wrapper">
								
								<textarea name="review_content2" id="review_content2" maxlength="500" required placeholder="리뷰를 입력하세요..." style="flex-grow:1;"></textarea>
								<button type="submit">작성</button>
							</div>
							<div style="margin-top: 8px;">
								<label for="review_file2" style="font-weight: normal; color: #666; margin-right: 8px;">첨부파일</label>
								<input type="file" name="review_file22" id="review_file2" accept="image/*">
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
								<span class="review-info">${rev.review_register2}</span>
								<span style="color: #ffa500; letter-spacing: 1px;">
									<c:forEach var="i" begin="1" end="${rev.review_score2}">★</c:forEach>
									<c:forEach var="i" begin="${rev.review_score2+1}" end="5">☆</c:forEach>
								</span>
							</div>
							<div class="review-text">
								<c:out value="${rev.review_content2}" />
							</div>
							<c:if test="${not empty rev.review_file2}">
								<div style="margin: 8px 0 0 0;">
									<img src="/images/${rev.review_file2}" alt="첨부이미지" style="max-width: 120px; border-radius: 8px; box-shadow: 0 1px 8px #eee;">
								</div>
							</c:if>
							<c:if test="${not empty sessionScope.loginMember and sessionScope.loginMember.memNo == rev.mem_no}">
								<div class="review-actions">
									<button type="button" class="reviewEditBtn" data-reviewid="${rev.review_id2}">수정</button>
									<a href="${pageContext.request.contextPath}/performancecont/reviewdelete?review_id2=${rev.review_id2}&con_id=${rev.con_id}" onclick="return confirm('정말 삭제하시겠습니까?');" class="delete-btn">삭제</a>
								</div>
							</c:if>
							<div id="reviewEditForm${rev.review_id2}" class="review-edit-form" style="display: none; background: #f8f9fa; border: 1px solid #ccc; border-radius: 9px; padding: 20px; margin-top: 10px;">
								<form action="${pageContext.request.contextPath}/performancecont/reviewedit" method="post" enctype="multipart/form-data">
									<input type="hidden" name="review_id2" value="${rev.review_id2}" />
									<input type="hidden" name="con_id" value="${rev.con_id}" />
									<input type="hidden" name="old_file2" value="${rev.review_file2}" />
									<div>
										<label>별점</label>
										<select name="review_score2" required>
											<option value="5" <c:if test="${rev.review_score2 == 5}">selected</c:if>>★★★★★</option>
											<option value="4" <c:if test="${rev.review_score2 == 4}">selected</c:if>>★★★★</option>
											<option value="3" <c:if test="${rev.review_score2 == 3}">selected</c:if>>★★★</option>
											<option value="2" <c:if test="${rev.review_score2 == 2}">selected</c:if>>★★</option>
											<option value="1" <c:if test="${rev.review_score2 == 1}">selected</c:if>>★</option>
										</select>
									</div>
									<div>
										<label>내용</label>
										<textarea name="review_content2" required>${rev.review_content2}</textarea>
									</div>
									<div>
										<label>사진 첨부</label>
										<input type="file" name="review_file22" accept="image/*" />
										<c:if test="${not empty rev.review_file2}">
											<div>기존: <img src="/images/${rev.review_file2}" style="max-width: 70px; vertical-align: middle;"></div>
										</c:if>
									</div>
									<div style="margin-top: 10px;">
										<input type="submit" value="수정완료" style="padding: 7px 22px;">
										<button type="button" onclick="closeReviewEditForm('${rev.review_id2}')" style="padding: 7px 22px;">취소</button>
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
						<a href="performancecont?con_id=${performancecont.con_id}&page=${i}"
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
<!-- 푸터 -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
