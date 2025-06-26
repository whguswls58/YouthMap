<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/culture/header.jsp" %>


<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>축제/행사 리스트</title>
</head>
<body>

  <%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>
  <%@ include file="/WEB-INF/views/culture/tabs.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/culture/list.css">
<div id="card-container">
  <div class="cards">
    <c:if test="${empty eventlist}">
      검색 결과가 없습니다.
    </c:if>
    <c:if test="${!empty eventlist}">
      <c:forEach var="cul" items="${eventlist}">
        <!-- url 파라미터 붙이기 -->
        <c:url var="urlWithParams" value="${pageContext.request.contextPath}/eventcont">
          <c:param name="con_id" value="${cul.con_id}" />
          <c:param name="page" value="${page}" />
        </c:url>
        <a class="card-link" href="${urlWithParams}">
          <div class="card">
            <!-- 카테고리 뱃지 -->
            <div class="badge eventlist">${cul.category_name}</div>
            <div class="img-wrap">
              <img src="${cul.con_img}" alt="${cul.con_title}" />
            </div>
            <div class="card-info">
              <div class="title">${cul.con_title}</div>
              <div class="period">${cul.con_start_date} ~ ${cul.con_end_date}</div>
              <div class="location">${cul.con_location}</div>
            </div>
          </div>
        </a>
      </c:forEach>
    </c:if>
  </div>
</div>

  <!-- 페이징 UI -->
  <div class="pager">
   <c:if test="${empty keyword }">
    <c:if test="${page > 1}">
      <a href="eventlist?page=1">&laquo;</a>
    </c:if>
    <c:if test="${startpage > 10}">
      <a href="eventlist?page=${startpage-10}">[이전]</a>
    </c:if>
    <c:forEach var="i" begin="${startpage}" end="${endpage}">
      <c:choose>
        <c:when test="${i == page}">
          <span class="current">${i}</span>
        </c:when>
        <c:otherwise>
          <a href="eventlist?page=${i}">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
    <c:if test="${endpage < pagecount}">
      <a href="eventlist?page=${startpage+10}">[다음]</a>
    </c:if>
    <c:if test="${page < pagecount}">
      <a href="eventlist?page=${pagecount}">&raquo;</a>
    </c:if>
   </c:if>
  
  
  <!-- 축제/행사 검색 페이징 처리 -->
   <c:if test="${!empty keyword }">
    <c:if test="${page > 1}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=event&search=${search}&keyword=${keyword}&page=1">&laquo;</a>
    </c:if>
    <c:if test="${startpage > 10}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=event&search=${search}&keyword=${keyword}&page=${startpage-10}">[이전]</a>
    </c:if>
    <c:forEach var="i" begin="${startpage}" end="${endpage}">
      <c:choose>
        <c:when test="${i == page}">
          <span class="current">${i}</span>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=event&search=${search}&keyword=${keyword}&page=${i}">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
    <c:if test="${endpage < pagecount}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=event&search=${search}&keyword=${keyword}&page=${startpage+10}">[다음]</a>
    </c:if>
    <c:if test="${page < pagecount}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=event&search=${search}&keyword=${keyword}&page=${pagecount}">&raquo;</a>
    </c:if>
   </c:if>
  </div>
 </div>
 
 
   <!-- ❶ jQuery 라이브러리 (한 번만!) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- 미니리스트 결과를 담을 팝업 레이어 -->
<div id="miniModal" style="
  display:none; position:fixed; left:0; top:0; width:100vw; height:100vh;
  z-index:1000; background:rgba(30,40,50,0.11); 
  backdrop-filter: blur(2.5px);">

  <div style="
    position:absolute; left:50%; top:52%; transform:translate(-50%,-50%);
    background:#fff;
    border-radius: 28px;                   /* 더 부드러운 라운드 */
    box-shadow: 0 10px 38px 0 rgba(30,60,90,0.20), 0 2px 8px 0 rgba(0,0,0,0.07);
    min-width: 390px; max-width: 540px;    /* 크기 여유 */
    max-height: 80vh; overflow-y:auto;
    border: none;
    padding: 0 0 18px 0;
    transition: box-shadow 0.2s;
    ">
    <button id="closeModalBtn" style="
      position:absolute; top:15px; right:16px; z-index:10;
      background:none; border:none; font-size:2.1rem; color:#b5b5b5; cursor:pointer; transition:color 0.18s;"
      onmouseover="this.style.color='#008060';"
      onmouseout="this.style.color='#b5b5b5';"
    >&times;</button>
    <!-- 🟡 여기! 문구 박스 추가 -->
    <div id="miniModalHeader" style="
      border-bottom:1.5px solid #ececec; 
      padding:29px 22px 14px 28px; 
      font-size:1.11em; font-weight:600; color:rgba(40,40,44,0.88);  /* 👈 이 부분만 변경! */ 
      background:rgba(245,240,230,0.67); 
      border-radius:28px 28px 0 0;
      letter-spacing:-1px;
    ">
      실시간 인기 콘텐츠
    </div>
    <div id="miniModalContent" style="padding:28px 22px 16px 22px;">
      <!-- AJAX로 결과 들어옴 -->
    </div>
  </div>
</div>

<!-- ❷ 정렬 팝업 AJAX (한 번만!) -->
<script>
$(function(){
	  $('.sort-nav a').click(function(e){
	    e.preventDefault();

	    var sort = $(this).data('sort');
	    var ctx = '${pageContext.request.contextPath}';
	    var url = ctx + '/allList-mini?sort=' + sort;

	    // 🌟 정렬별로 상단 멘트 다르게!
	    var headerMsg = "실시간 인기 콘텐츠";
	    if(sort == 'newest')     headerMsg = "최신 등록 콘텐츠";
	    if(sort == 'endingSoon') headerMsg = "마감 임박 콘텐츠";
	    $('#miniModalHeader').text(headerMsg);

	    // AJAX로 mini 데이터 가져와서 팝업에 삽입
	    $.get(url, function(html){
	      $('#miniModalContent').html(html);
	      $('#miniModal').fadeIn(180);
	    });
	  });

	  // 팝업 닫기(버튼, 바깥 클릭, ESC)
	  $('#closeModalBtn, #miniModal').on('click', function(e){
	    if(e.target === this) $('#miniModal').fadeOut(180);
	  });
	  $(document).on('keyup', function(e){
	    if(e.key === "Escape") $('#miniModal').fadeOut(180);
	  });
	});
</script>

</body>
</html>
