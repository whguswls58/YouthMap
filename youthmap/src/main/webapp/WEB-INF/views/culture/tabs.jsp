<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
#miniModalHeader {
  border-bottom:1.5px solid #ececec;
  padding:24px 18px 14px 28px;
  font-size:1.13em; font-weight:700; color:#333;
  background:rgba(245,240,230,0.94);
  border-radius:24px 24px 0 0;
  letter-spacing:-1px;
  text-align:left;
  /* 추가 강조 */
  box-shadow: 0 2px 4px rgba(0,0,0,0.04);
}
.tabs-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1150px;
  margin: 20px auto;
  padding: 3px 0;
  font-size: 1.1rem;
 /*  border-top: 2px solid #000;  	상하 라인 
  border-bottom: 2px solid #000; */
}

/* 카테고리 (좌측) */
.category-nav {
  display: flex;
  gap: 3px;
  padding : 18px 0;
  background-color :white;
  color: #555;
}

.category-nav a {
  text-decoration: none;
  color: #555;
  font-size: 16px;
  padding: 10px 15px;
  position: relative;
  transition: 0.3s;
}

.category-nav a:hover {
  color: #111;
}

.category-nav a.current {
  font-weight: bold;
  color: #000;  /* 연한 회색 */
/*   background: #f7f7f7;   *//* 배경도 연하게 하고 싶으면 추가 */
}

.category-nav a.current::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 3px;
  background-color: black;
}

/* 정렬 (우측) */
.sort-nav {
  display: flex;
  gap: 10px;
}

.sort-nav a {
  text-decoration: none;
  color: #555;
  font-size: 16px;
  padding: 5px;
  position: relative;
  transition: 0.3s;
}

.sort-nav a:hover {
  color: #111;
}

.sort-nav a.active {
  font-weight: bold;
  color: #000;
}

.sort-nav a.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 3px;
  background-color: black;
}
</style>
</head>
<body>
<!-- ========================= -->
<!-- Tabs with Sort Links     -->
<!-- ========================= -->
<div class="tabs-container">
  <!-- 좌측: 카테고리 -->
  <div class="category-nav">
    <a href="${pageContext.request.contextPath}/allList"
       class="${mainCategory == 'all' ? 'current' : ''}">전체목록</a>
    <a href="${pageContext.request.contextPath}/exhibitionlist"
       class="${mainCategory == '전시/미술' ? 'current' : ''}">전시/미술</a>
    <a href="${pageContext.request.contextPath}/performancelist"
       class="${mainCategory == '공연' ? 'current' : ''}">공연</a>
    <a href="${pageContext.request.contextPath}/eventlist"
       class="${mainCategory == '축제/행사' ? 'current' : ''}">축제/행사</a>
  </div>

  <!-- 우측: 정렬 -->
  <div class="sort-nav">
    <a href="#" data-sort="mostViewed"
       class="${sort == 'mostViewed' ? 'active' : ''}">• 인기순</a>
    <a href="#" data-sort="newest"
       class="${sort == 'newest' ? 'active' : ''}">• 최신순</a>
    <a href="#" data-sort="endingSoon"
       class="${sort == 'endingSoon' ? 'active' : ''}">• 마감임박</a>
  </div>
</div>

<!-- ========================= -->
<!-- 팝업 + AJAX 스크립트 -->
<!-- ========================= -->
<div id="miniModal" style="
  display:none; position:fixed; left:0; top:0; width:100vw; height:100vh;
  z-index:1000; background:rgba(30,40,50,0.12); backdrop-filter: blur(2px);">
  <div style="
    position:absolute; left:50%; top:52%; transform:translate(-50%,-50%);
    background:#fff; border-radius:24px;
    box-shadow:0 8px 32px rgba(0,0,0,0.16), 0 1.5px 4px rgba(0,0,0,0.06);
    min-width:390px; max-width:540px; max-height:80vh; overflow-y:auto; border:none;
    padding:0 0 18px 0;">
    <button id="closeModalBtn" style="
      position:absolute; top:15px; right:16px; z-index:10;
      background:none; border:none; font-size:2.1rem; color:#b5b5b5; cursor:pointer;">
      &times;
    </button>
    <!-- ★★ 팝업 상단 문구 header 추가! ★★ -->
    <div id="miniModalHeader"
         style="border-bottom:1.5px solid #ececec; padding:24px 18px 14px 28px; font-size:1.13em; font-weight:700; color:#333; background:rgba(245,240,230,0.94); border-radius:24px 24px 0 0; letter-spacing:-1px; text-align:left; box-shadow:0 2px 4px rgba(0,0,0,0.04);">
      실시간 인기 콘텐츠
    </div>
    <div id="miniModalContent" style="padding:38px 22px 16px 22px;"></div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- 직접 작성한 팝업/정렬 스크립트 -->
<script>
$(function() {
  $('.sort-nav a').click(function(e) {
    e.preventDefault();
    var sort = $(this).data('sort');
    var ctx  = '${pageContext.request.contextPath}';
    var url  = ctx + '/allList-mini?sort=' + sort;

    // 동적 header 변경
    var headerMsg = "실시간 인기 콘텐츠";
    if(sort === "newest") headerMsg = "최신 등록 콘텐츠";
    if(sort === "endingSoon") headerMsg = "마감 임박 콘텐츠";
    $('#miniModalHeader').text(headerMsg);

    // 탭 UI 동적 표시
    $('.sort-nav a').removeClass('active');
    $(this).addClass('active');

    $.get(url, function(html) {
      $('#miniModalContent').html(html);
      $('#miniModal').fadeIn(180);
      $('body').css('overflow','hidden');
    });
  });

  $('#closeModalBtn, #miniModal').on('click', function(e){
    if(e.target === this) {
      $('#miniModal').fadeOut(180);
      $('body').css('overflow','auto');
    }
  });

  $(document).on('keyup', function(e){
    if(e.key === "Escape") {
      $('#miniModal').fadeOut(180);
      $('body').css('overflow','auto');
    }
  });
});
</script>

</body>
</html>