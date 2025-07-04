<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>VIVAMAP</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/culture/list.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" />
</head>
<body>
 <%@ include file="/WEB-INF/views/header.jsp" %>
 <%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>
 <%@ include file="/WEB-INF/views/culture/tabs.jsp" %>

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
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=event&search=${search}&keyword=${keyword}&page=1">«</a>
    </c:if>
    <c:if test="${startpage > 10}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=event&search=${search}&keyword=${keyword}&page=${startpage-10}">‹</a>
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
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=event&search=${search}&keyword=${keyword}&page=${startpage+10}">›</a>
    </c:if>
    <c:if test="${page < pagecount}">
      <a href="${pageContext.request.contextPath}/culturesearch?mainCategory=event&search=${search}&keyword=${keyword}&page=${pagecount}">»</a>
    </c:if>
   </c:if>
  </div>
 </div>
<!-- 푸터 -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
