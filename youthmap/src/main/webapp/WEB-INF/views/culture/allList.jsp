<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전체 콘텐츠 목록</title>
  <!-- 검색바 포함 -->
  <%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>

  <style>
    /* 카드 그리드 */
    .cards {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
      max-width: 880px;
      margin: 20px auto;
      padding: 0;
    }
    /* 카드 하나당 */
    .card {
      position: relative;
      flex: 0 0 calc((100% - 60px) / 4);
      box-sizing: border-box;
      border: 1px solid #ddd;
      border-radius: 8px;
      overflow: hidden;
      background: #fff;
    }
    .card img {
      width: 100%;
      height: 120px;
      object-fit: cover;
      display: block;
    }
    /* 뱃지 기본 */
    .badge {
      position: absolute;
      top: 7px;
      right: 7px;
      color: #fff;
      padding: 4px 12px;
      border-radius: 12px;
      font-size: 0.85rem;
      font-weight: bold;
      white-space: nowrap;
      box-shadow: 0 2px 4px rgba(0,0,0,0.2);
      z-index: 10;
    }
    /* 카테고리별 배경색 */
    .badge-exhibition { background: #008060; }
    .badge-performance { background: #ff6600; }
    .badge-event       { background: #0066cc; }

    .card-info {
      padding: 8px;
    }
    .card-info .title {
      font-size: 1em;
      color: #333;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      margin-bottom: 4px;
    }
    .card-info .period {
      font-size: 0.85em;
      color: #555;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    /* 링크 */
    a.card-link {
      display: block;
      text-decoration: none;
      color: inherit;
      position: relative;
      z-index: 0;
    }
    /* 페이징 */
    .pager {
      text-align: center;
      margin: 20px auto;
    }
    .pager a, .pager span {
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

  <div style="text-align:center; margin:20px 0;">
    <button onclick="location.href='exhibitionlist'" style="width:100px; height:26px; font-size:16px; margin:0 8px;">
      전시/미술
    </button>
    <button onclick="location.href='performancelist'" style="width:100px; height:26px; font-size:16px; margin:0 8px;">
      공연
    </button>
    <button onclick="location.href='eventlist'" style="width:100px; height:26px; font-size:16px; margin:0 8px;">
      축제/행사
    </button>
  </div>
  <hr/>

  <h2 style="text-align:center; margin:20px 0;">
    전체 콘텐츠 목록 (${page}/${pagecount})
  </h2>

<div class="cards">
  <c:if test="${empty allList }">
  		검색 결과가 없습니다.
  </c:if>
  
  <c:if test="${!empty allList }">
  <c:forEach var="item" items="${allList}">
    <div class="card">
      <!-- 전시/미술 뱃지 (해당하면) -->
      <c:if test="${item.category_name == '전시/미술'}">
        <div class="badge badge-exhibition">${item.category_name}</div>
      </c:if>

      <!-- 공연 뱃지 (콘서트·연극·뮤지컬/오페라) -->
      <c:if test="${item.category_name == '콘서트'
         or item.category_name == '연극'
         or item.category_name == '뮤지컬/오페라'}">
  <div class="badge badge-performance">${item.category_name}</div>
</c:if>

<c:if test="${item.category_name == '축제-기타'
         or item.category_name == '축제-시민화합'
         or item.category_name == '축제-자연/경관'
         or item.category_name == '축제-문화/예술'}">
  <div class="badge badge-event">축제/행사</div>
</c:if>

    <!-- 이미지 & 링크 -->    
    <c:set var="detailPage"
       value="${(item.category_name=='전시/미술')?'exhibitioncont'
                :(item.category_name=='콘서트'||item.category_name=='연극'||item.category_name=='뮤지컬/오페라')?'performancecont'
                :(item.category_name=='축제-기타'||item.category_name=='축제-시민화합'||item.category_name=='축제-자연/경관'||item.category_name=='축제-문화/예술')?'eventcont'
                :'defaultcont'}"/>

	<a class="card-link"
  	   href="${pageContext.request.contextPath}/${detailPage}?con_id=${item.con_id}&page=${page}">
  	   <img src="${item.con_img}" title="${item.con_title}"/>
	</a>

      <!-- 제목·기간·위치 -->
      <div class="card-info">
        <div class="title">${item.con_title}</div>
        <div class="period">
          ${item.con_start_date} ~ ${item.con_end_date}<br/>
          ${item.con_location}
        </div>
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
