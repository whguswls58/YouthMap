<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/culture/header.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전체 콘텐츠 목록</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/culture/list.css">
</head>
<body>

<%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>
<%@ include file="/WEB-INF/views/culture/tabs.jsp" %>

<div id="card-container">
  <div class="cards">
    <c:if test="${empty allList}">
      검색 결과가 없습니다.
    </c:if>

    <c:if test="${!empty allList}">
      <c:forEach var="item" items="${allList}">
        <div class="card">
          <!-- 카테고리별 뱃지와 상세페이지 링크 분기 -->
          <c:choose>
            <c:when test="${item.category_name == '전시/미술'}">
              <div class="badge exhibitionlist">${item.category_name}</div>
              <c:set var="detailUrl" value="${pageContext.request.contextPath}/exhibitioncont"/>
            </c:when>
            <c:when test="${item.category_name == '콘서트'
                        or item.category_name == '연극'
                        or item.category_name == '뮤지컬/오페라'
                        or item.category_name == '국악'
                        or item.category_name == '독주회'
                        or item.category_name == '클래식'
                        or item.category_name == '무용'}">
              <div class="badge performancelist">${item.category_name}</div>
              <c:set var="detailUrl" value="${pageContext.request.contextPath}/performancecont"/>
            </c:when>
            <c:otherwise>
              <div class="badge eventlist">${item.category_name}</div>
              <c:set var="detailUrl" value="${pageContext.request.contextPath}/eventcont"/>
            </c:otherwise>
          </c:choose>
          <!-- url 파라미터 붙이기 -->
		  <c:url var="urlWithParams" value="${detailUrl}">
		    <c:param name="con_id" value="${item.con_id}" />
		    <c:param name="page" value="${page}" />
		  </c:url>

		  <!-- 카드 전체에 링크 -->
		  <a class="card-link" href="${urlWithParams}">
		      <!-- 뱃지는 위에서 이미 출력됨 -->
		      <div class="img-wrap">
		        <img src="${item.con_img}" alt="${item.con_title}" />
		      </div>
		      <div class="card-info">
		        <div class="title">${item.con_title}</div>
		        <div class="period">${item.con_start_date} ~ ${item.con_end_date}</div>
		        <div class="location">${item.con_location}</div>
		      </div>
		  </a>
        </div>
      </c:forEach>
    </c:if>
  </div>
</div>

<!-- 페이징 UI (공통 형태) -->
<div class="pager">
  <c:if test="${empty keyword}">
    <c:if test="${page > 1}">
      <a href="${pageContext.request.contextPath}/allList?page=1">&laquo;</a>
    </c:if>
    <c:if test="${startpage > 10}">
      <a href="${pageContext.request.contextPath}/allList?page=${startpage-10}">[이전]</a>
    </c:if>
    <c:forEach var="i" begin="${startpage}" end="${endpage}">
      <c:choose>
        <c:when test="${i == page}">
          <span class="current">${i}</span>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/allList?page=${i}">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
    <c:if test="${endpage < pagecount}">
      <a href="${pageContext.request.contextPath}/allList?page=${startpage+10}">[다음]</a>
    </c:if>
    <c:if test="${page < pagecount}">
      <a href="${pageContext.request.contextPath}/allList?page=${pagecount}">&raquo;</a>
    </c:if>
  </c:if>
  <c:if test="${!empty keyword}">
    <c:if test="${page > 1}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=all&search=${search}&keyword=${keyword}&page=1">&laquo;</a>
    </c:if>
    <c:if test="${startpage > 10}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=all&search=${search}&keyword=${keyword}&page=${startpage-10}">[이전]</a>
    </c:if>
    <c:forEach var="i" begin="${startpage}" end="${endpage}">
      <c:choose>
        <c:when test="${i == page}">
          <span class="current">${i}</span>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=all&search=${search}&keyword=${keyword}&page=${i}">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
    <c:if test="${endpage < pagecount}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=all&search=${search}&keyword=${keyword}&page=${startpage+10}">[다음]</a>
    </c:if>
    <c:if test="${page < pagecount}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=all&search=${search}&keyword=${keyword}&page=${pagecount}">&raquo;</a>
    </c:if>
  </c:if>
</div>

<!-- 팝업 레이어(고유 기능) -->
<div id="miniModal" style="
  display:none; position:fixed; left:0; top:0; width:100vw; height:100vh;
  z-index:1000; background:rgba(30,40,50,0.11); backdrop-filter: blur(2.5px);">
  <div style="
    position:absolute; left:50%; top:52%; transform:translate(-50%,-50%);
    background:#fff; border-radius:28px;
    box-shadow:0 10px 38px 0 rgba(30,60,90,0.20), 0 2px 8px 0 rgba(0,0,0,0.07);
    min-width:390px; max-width:540px; max-height:80vh; overflow-y:auto;
    border:none; padding:0 0 18px 0;">
    <button id="closeModalBtn" style="
      position:absolute; top:15px; right:16px; z-index:10;
      background:none; border:none; font-size:2.1rem; color:#b5b5b5; cursor:pointer;">
      &times;
    </button>
    <div id="miniModalHeader">실시간 인기 콘텐츠</div>
    <div id="miniModalContent" style="padding:28px 22px 16px 22px;">
      <!-- AJAX로 콘텐츠 미니리스트 들어옴 -->
    </div>
  </div>
</div>

<!-- jQuery 및 팝업/정렬 스크립트(고유 기능) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function(){
  $('.sort-nav a').click(function(e){
    e.preventDefault();
    var sort = $(this).data('sort');
    var ctx  = '${pageContext.request.contextPath}';
    var url  = ctx + '/allList-mini?sort=' + sort;
    var headerMsg = "실시간 인기 콘텐츠";
    if(sort == 'newest')     headerMsg = "최신 등록 콘텐츠";
    if(sort == 'endingSoon') headerMsg = "마감 임박 콘텐츠";
    $('#miniModalHeader').text(headerMsg);
    $.get(url, function(html){
      $('#miniModalContent').html(html);
      $('#miniModal').fadeIn(180);
    });
  });

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
