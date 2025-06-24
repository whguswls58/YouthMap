<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전체 콘텐츠 목록</title>
 <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">


  <style>
.cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);  /* 명확히 한 줄에 4개의 카드 고정 */
  gap: 20px;
  width: 100%;               /* 부모 컨테이너의 전체 너비를 사용 */
  max-width: 1200px;         /* 좀 더 여유 있게 설정 (기존 1000px → 1200px) */
  margin: 0 auto;
  box-sizing: border-box;
}


.card {
  position: relative;
  box-sizing: border-box;
  border: 1px solid #ddd;
  border-radius: 8px;
  overflow: hidden;
  background: #fff;
  text-align: center;
  width: 90%;
}

.img-wrap {
 width: 100%;
	display: flex;
	justify-content: center;
	align-items: center; /* 가로·세로 중앙 정렬 */
	overflow: hidden;
	height: 300px;
	text-align: center;
	
}
.img-wrap img {
  max-width: 90%; /* 래퍼 폭을 넘지 않음 */
	max-height: 90%; /* 래퍼 높이를 넘지 않음 */
	border-radius: 8px;
}
.card-info {
  padding: 10px;
  box-sizing: border-box;
}


.card-info .period,
.card-info .location {
  width: 100%;
  white-space: nowrap;
  overflow: hidden;
    color: #555;
  text-overflow: ellipsis;
  font-size: 0.9rem;
}

.card-info .title {
  font-weight: bold;
  margin-bottom: 4px;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
/*──────────────────────────────────────────────
   뱃지 (기본 스타일)
──────────────────────────────────────────────*/
.badge {
  position: absolute;
  top: 7px;
  right: 7px;
  color: #fff;
  background: #008060;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: bold;
  white-space: nowrap;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2);
  z-index: 10;
}

/*──────────────────────────────────────────────
   카테고리별 뱃지 색상
──────────────────────────────────────────────*/
.badge.exhibitionlist    { background: #008060; } /* 전시/미술 */
.badge.performancelist   { background: #a83279; } /* 공연 */
.badge.eventlist         { background: #0066cc; } /* 축제/행사 */
/* 추가 카테고리가 있으면 아래에 더 정의하세요. */


/*──────────────────────────────────────────────
   페이지네이션
──────────────────────────────────────────────*/
.pager {
  text-align: center;
  margin: 20px auto;
}

.pager a,
.pager span {
  display: inline-block;
  margin: 0 6px;
  padding: 4px 8px;
  text-decoration: none;
  color: #000;
}

.pager .current {
  font-weight: bold;
}


  </style>
</head>
<body>

<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>
  <%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>

 
  <!-- 우측: 정렬 -->
  <div class="sort-nav">
    <a href="#" data-sort="mostViewed"
       class="${sort == 'mostViewed' ? 'active' : ''}">• 인기순</a>
    <a href="#" data-sort="newest"
       class="${sort == 'newest' ? 'active' : ''}">• 최신순</a>
    <a href="#" data-sort="endingSoon"
       class="${sort == 'endingSoon' ? 'active' : ''}">• 마감임박</a>
  </div>

  <h2 style="text-align:center; margin:20px 0;">
    전체 콘텐츠 목록 (${page}/${pagecount})
  </h2><br>

<div class="cards">
  <c:if test="${empty allList }">
    검색 결과가 없습니다.
  </c:if>

  <c:if test="${!empty allList}">
    <c:forEach var="item" items="${allList}">

      <!-- 상세페이지 URL 설정 -->
      <c:choose>
        <c:when test="${item.category_name == '전시/미술'}">
          <c:set var="detailUrl" value="${pageContext.request.contextPath}/exhibitioncont"/>
        </c:when>
        <c:when test="${item.category_name == '콘서트' 
                      or item.category_name == '연극' 
                      or item.category_name == '뮤지컬/오페라'
                      or item.category_name == '국악'
                      or item.category_name == '독주회'
                      or item.category_name == '클래식'
                      or item.category_name == '무용'}">
          <c:set var="detailUrl" value="${pageContext.request.contextPath}/performancecont"/>
        </c:when>
        <c:otherwise>
          <c:set var="detailUrl" value="${pageContext.request.contextPath}/eventcont"/>
        </c:otherwise>
      </c:choose>

      <!-- URL 파라미터 설정 -->
      <c:url var="urlWithParams" value="${detailUrl}">
        <c:param name="con_id" value="${item.con_id}" />
        <c:param name="page" value="${page}" />
      </c:url>

      <!-- 카드 구성 -->
      <div class="card">
        
        <!-- 🔗 이미지에만 링크 -->
        <a href="${urlWithParams}">
          <div class="img-wrap">
            <img src="${item.con_img}" alt="${item.con_title}" />
          </div>
        </a>

        <div class="card-info">
          <!-- 🔗 제목에만 링크 -->
          <div class="title">
            <a href="${urlWithParams}" style="text-decoration:none; color:inherit;">
              ${item.con_title}
            </a>
          </div>
          <div class="period">${item.con_start_date} ~ ${item.con_end_date}</div>
          <div class="location">${item.con_location}</div>
        </div>

      </div>

    </c:forEach>
  </c:if>
</div>

  <!-- 페이징 UI -->
  <div class="pager">
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
  </div>
  
  
</body>
</html>
