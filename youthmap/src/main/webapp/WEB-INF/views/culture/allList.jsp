<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전체 콘텐츠 목록</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/culture/list.css">
</head>
<body>
<%-- 관리자 모드에서 수동 업데이트 버튼 추가하기
<form action="${pageContext.request.contextPath}/datainput" method="get" style="display:inline;">
  <button type="submit">수동 업데이트 실행</button>
</form> --%>

<%@ include file="/WEB-INF/views/header.jsp" %>
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
      <a href="${pageContext.request.contextPath}/allList?page=1"><<</a>
    </c:if>
    <!-- 이전 페이지 -->
    <c:if test="${page > 1}">
      <a href="${pageContext.request.contextPath}/allList?page=${page-1}"><</a>
    </c:if>
    <!-- 페이지 번호 -->
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
    <!-- 다음 페이지 -->
    <c:if test="${page < pagecount}">
      <a href="${pageContext.request.contextPath}/allList?page=${page+1}">></a>
    </c:if>
    <!-- 마지막 페이지로 이동 -->
    <c:if test="${page < pagecount}">
      <a href="${pageContext.request.contextPath}/allList?page=${pagecount}">>></a>
    </c:if>

  </c:if>
  <c:if test="${!empty keyword}">
    <c:if test="${page > 1}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=all&search=${search}&keyword=${keyword}&page=1"><<</a>
    </c:if>
    <!-- 이전 페이지 -->
    <c:if test="${page > 1}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=all&search=${search}&keyword=${keyword}&page=${page-1}"><</a>
    </c:if>
    <!-- 페이지 번호 -->
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
    <!-- 다음 페이지 -->
    <c:if test="${page < pagecount}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=all&search=${search}&keyword=${keyword}&page=${page+1}">></a>
    </c:if>
    <!-- 마지막 페이지로 이동 -->
    <c:if test="${page < pagecount}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=all&search=${search}&keyword=${keyword}&page=${pagecount}">>></a>
    </c:if>
  </c:if>
</div>

</body>
</html>
