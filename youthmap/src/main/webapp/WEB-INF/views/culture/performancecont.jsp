<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.example.demo.util.KakaoKeyUtil" %>
<%@ include file="/WEB-INF/views/culture/header.jsp" %>


<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${performancecont.con_title} 상세</title>

  <!-- ① 카카오 JS SDK: YOUR_APP_KEY 부분에 자바스크립트 키를 넣으세요 -->
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=<%= KakaoKeyUtil.getApiKey() %>&libraries=services"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/culture/cont.css"> 
</head>
<body>

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
    <div id="map" style="width:100%;height:400px;"></div>

    <!-- ③ SDK 로드 후 안전하게 호출 -->
    <script>
      kakao.maps.load(function() {
        // EL 값은 문자열로 감싸서 parseFloat
        var lng = parseFloat("${cul.con_lat}");
        var lat = parseFloat("${cul.con_lot}");

        var map = new kakao.maps.Map(
          document.getElementById('map'),
          {
            center: new kakao.maps.LatLng(lat, lng),
            level: 3
          }
        );
        new kakao.maps.Marker({
          position: new kakao.maps.LatLng(lat, lng),
          map: map
        });
      });
    </script>
    
    	<!-- 뒤로가기 -->
    <div class="back-container">
  		<a class="back-link" href="#" onclick="history.go(-1); return false;">
  		  ← 목록으로 돌아가기
  		</a>
	</div>
    
    
 <!-- 리뷰작성 버튼 -->
<!-- 				여기서부터 리뷰 기능 추가한 코드 				-->  
<!-- 숨겨진 리뷰작성 폼 -->
<div class="visitor-review-container">
<div id="reviewFormWrap" style="display:none;">
    <div class="review-form-container" style="max-width: 400px; margin: 20px auto;">
        <h2 style="text-align:center; margin-bottom: 20px;">리뷰 작성</h2>
        <form action="${pageContext.request.contextPath}/exhibitioncont/reviewwrite" 
			 method="post" enctype="multipart/form-data">
            <input type="hidden" name="con_id" value="${exhibitioncont.con_id}" />
            <input type="hidden" name="page" value="${page }">
            <div class="review-form-row" style="margin-bottom:16px;">
                <label for="review_writer2">작성자</label>
                <input type="text" name="review_writer2" id="review_writer2" maxlength="30" required placeholder="작성자 닉네임 또는 아이디" style="width:100%;padding:8px;">
            </div>

            <div class="review-form-row" style="margin-bottom:16px;">
                <label for="review_score2">별점</label>
                <select name="review_score2" id="review_score2" required style="width:100%;padding:8px;">
                    <option value="">선택</option>
                    <option value="5">★★★★★ (5점)</option>
                    <option value="4">★★★★ (4점)</option>
                    <option value="3">★★★ (3점)</option>
                    <option value="2">★★ (2점)</option>
                    <option value="1">★ (1점)</option>
                </select>
            </div>

            <div class="review-form-row" style="margin-bottom:16px;">
                <label for="review_content2">내용</label>
                <textarea name="review_content2" id="review_content2" maxlength="500" required placeholder="리뷰 내용을 입력해주세요." style="width:100%;padding:8px;"></textarea>
            </div>

            <div class="review-form-row" style="margin-bottom:16px;">
                <label for="review_file2">사진 첨부</label>
                <input type="file" name="review_file22" id="review_file2" accept="image/*" />
            </div>

            <div class="review-form-btns" style="text-align:center;">
                <input type="submit" value="작성완료" style="padding:8px 28px; border-radius:6px; border:none; background:#888; color:#fff; font-size:16px; cursor:pointer;">
                <button type="button" onclick="closeReviewForm()" style="padding:8px 28px; border-radius:6px; border:none; background: #888; color:#fff; font-size:16px; cursor:pointer;">취소</button>
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
<div style="text-align:right; margin: 18px 0;">
    <button id="reviewWriteBtn" style="padding:7px 20px; border-radius:7px; background:#888; color:#fff; border:none; font-size:16px; cursor:pointer;">
        리뷰 작성
    </button>
</div>
  <h2 style="font-size:2em; margin-bottom:16px;">방문자 평가</h2>
  <c:forEach var="rev" items="${reviewlist}">
        <div style="border-bottom:1px solid #eee;padding:16px 0 10px 0;margin-bottom:0;">
            <!-- 작성자 & 별점 -->
            <div style="display:flex;justify-content:space-between;align-items:center;">
                <span style="font-weight:bold;font-size:17px;"><c:out value="${rev.review_writer2}" /></span>
                <span style="color:#555; font-size:14px;">
            <c:out value="${rev.review_register2}" />
          </span>
                <span style="color:#ffa500;letter-spacing:1px;">
                    <c:forEach var="i" begin="1" end="${rev.review_score2}">★</c:forEach>
                    <c:forEach var="i" begin="${rev.review_score2+1}" end="5">☆</c:forEach>
                </span>
            </div>
            
            <!-- 리뷰 내용 -->
            <div style="margin:10px 0 6px 0;line-height:1.7;font-size:16px;color:#333;">
                <c:out value="${rev.review_content2}" />
            </div>
            <!-- 첨부 이미지 -->
            <c:if test="${not empty rev.review_file2}">
                <div style="margin:8px 0 0 0;">
                    <img src="/images/${rev.review_file2}" alt="첨부이미지"
                         style="max-width:120px;border-radius:8px;box-shadow:0 1px 8px #eee;">
                </div>
            </c:if>
            <!-- ★ 버튼 영역 (수정/삭제/수정폼 토글) -->
            <div style="text-align:right;margin-top:7px;">
                <button type="button" class="reviewEditBtn" data-reviewid="${rev.review_id2}" style="padding:3px 13px 4px 13px;border-radius:5px;background:#7f8c8d;color:#fff;border:none;cursor:pointer;font-size:14px;">
                    수정
                </button>
                <a href="reviewdelete?review_id2=${rev.review_id2}&res_id=${rev.con_id}" onclick="return confirm('정말 삭제하시겠습니까?');">
                    <button style="padding:3px 13px 4px 13px;border-radius:5px;background:#c0392b;color:#fff;border:none;cursor:pointer;font-size:14px;">
                        삭제
                    </button>
                </a>
            </div>
            <!-- ★ 리뷰 수정 폼 (리스트 내, 처음엔 숨김) -->
            <div id="reviewEditForm${rev.review_id2}" class="review-edit-form" style="display:none; background:#f8f9fa; border:1px solid #ccc; border-radius:9px; padding:20px; margin-top:10px;">
                <form action="reviewedit" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="review_id2" value="${rev.review_id2}" />
                    <input type="hidden" name="con_id" value="${rev.con_id}" />
                    <input type="hidden" name="old_file2" value="${rev.review_file2}" />
                    <div>
                        <label>별점</label>
                        <select name="review_score2" required>
                            <option value="5" <c:if test="${rev.review_score2 == 5}">selected</c:if>>★★★★★ (5점)</option>
                            <option value="4" <c:if test="${rev.review_score2 == 4}">selected</c:if>>★★★★ (4점)</option>
                            <option value="3" <c:if test="${rev.review_score2 == 3}">selected</c:if>>★★★ (3점)</option>
                            <option value="2" <c:if test="${rev.review_score2 == 2}">selected</c:if>>★★ (2점)</option>
                            <option value="1" <c:if test="${rev.review_score2 == 1}">selected</c:if>>★ (1점)</option>
                        </select>
                    </div>
                    <div>
                        <label>내용</label>
                        <textarea name="review_content2" required>${rev.review_content2}</textarea>
                    </div>
                    <div>
                        <label>사진 첨부</label>
                        <input type="file2" name="review_file22" accept="image/*" />
                        <c:if test="${not empty rev.review_file2}">
                            <div>기존: <img src="/images/${rev.review_file2}" style="max-width:70px;vertical-align:middle;"></div>
                        </c:if>
                    </div>
                    <div style="margin-top:10px;">
                        <input type="submit" value="수정완료" style="padding:7px 22px;">
                        <button type="button" onclick="closeReviewEditForm('${rev.review_id2}')" style="padding:7px 22px;">취소</button>
                    </div>
                </form>
            </div>
        </div>
    </c:forEach>
    <c:if test="${empty reviewlist}">
        <div style="text-align:center;color:#aaa;">등록된 리뷰가 없습니다.</div>
    </c:if>
  </div>
 </div>
  
 

<!-- 페이지네이션 -->
<c:if test="${totalpage > 1}">
  <div style="text-align:center; margin:30px 0;">
    <c:forEach var="i" begin="1" end="${totalpage}">
      <c:choose>
        <c:when test="${page == i}">
          <span style="color:#222;font-weight:bold;padding:0 10px;">${i}</span>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/exhibitioncont?con_id=${exhibitioncont.con_id}&page=${i}" 
             style="color:#666;text-decoration:none;padding:0 10px;">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
  </div>
</c:if>

<!-- //////////////////////////////////////////////////////////////////////////////// -->


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
        document.querySelectorAll('.reviewEditBtn').forEach(function(btn) {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.review-edit-form').forEach(function(div) {
                    div.style.display = 'none';
                });
                var id = btn.getAttribute('data-reviewid');
                document.getElementById('reviewEditForm'+id).style.display = 'block';
            });
        });
    });

    function closeReviewEditForm(id) {
        document.getElementById('reviewEditForm'+id).style.display = 'none';
    }
    function closeReviewForm() {
        document.getElementById('reviewFormWrap').style.display = 'none';
        document.getElementById('reviewWriteBtn').style.display = 'inline-block';
    }
</script>			<!-- 리뷰댓글 끝 -->

   </div>
  
</body>
</html>
