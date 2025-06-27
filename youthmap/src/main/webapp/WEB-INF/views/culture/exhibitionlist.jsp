<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전시/미술 리스트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" />
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/culture/list.css">

</head>
<body>
  <%@ include file="/WEB-INF/views/header.jsp" %>
  <%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>
  <%@ include file="/WEB-INF/views/culture/tabs.jsp" %>
<div id="card-container">
  <div class="cards">
    <c:if test="${empty exhibitionlist}">
      검색 결과가 없습니다.
    </c:if>
    <c:if test="${!empty exhibitionlist}">
      <c:forEach var="cul" items="${exhibitionlist}">
        <!-- url 파라미터 붙이기 -->
        <c:url var="urlWithParams" value="${pageContext.request.contextPath}/exhibitioncont">
          <c:param name="con_id" value="${cul.con_id}" />
          <c:param name="page" value="${page}" />
        </c:url>
        <a class="card-link" href="${urlWithParams}">
          <div class="card">
            <!-- 카테고리 뱃지 -->
            <div class="badge exhibitionlist">${cul.category_name}</div>
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
  
   <!-- 전시/미술 페이징 처리 -->
   <c:if test="${empty keyword }">
    <c:if test="${page > 1}">
      <a href="exhibitionlist?page=1">&laquo;</a>
    </c:if>
    <c:if test="${startpage > 10}">
      <a href="exhibitionlist?page=${startpage-10}">[이전]</a>
    </c:if>
    <c:forEach var="i" begin="${startpage}" end="${endpage}">
      <c:choose>
        <c:when test="${i == page}">
          <span class="current">${i}</span>
        </c:when>
        <c:otherwise>
          <a href="exhibitionlist?page=${i}">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
    <c:if test="${endpage < pagecount}">
      <a href="exhibitionlist?page=${startpage+10}">[다음]</a>
    </c:if>
    <c:if test="${page < pagecount}">
      <a href="exhibitionlist?page=${pagecount}">&raquo;</a>
    </c:if>
    </c:if>
    
   <!-- 전시/미술 검색 페이징 처리 -->
   <c:if test="${!empty keyword }">
    <c:if test="${page > 1}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=exhibition&search=${search}&keyword=${keyword}&page=1">&laquo;</a>
    </c:if>
    <c:if test="${startpage > 10}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=exhibition&search=${search}&keyword=${keyword}&page=${startpage-10}">[이전]</a>
    </c:if>
    <c:forEach var="i" begin="${startpage}" end="${endpage}">
      <c:choose>
        <c:when test="${i == page}">
          <span class="current">${i}</span>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=exhibition&search=${search}&keyword=${keyword}&page=${i}">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
    <c:if test="${endpage < pagecount}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=exhibition&search=${search}&keyword=${keyword}&page=${startpage+10}">[다음]</a>
    </c:if>
    <c:if test="${page < pagecount}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=exhibition&search=${search}&keyword=${keyword}&page=${pagecount}">&raquo;</a>
    </c:if>
   </c:if>
  </div>
 </div>

</body>
</html>
