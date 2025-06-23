<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
/* 공통 CSS 파일 (예: main.css)에 추가하세요) */

.tabs-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-top: 2px solid #000;
  border-bottom: 2px solid #000;
  padding: 0 16px;
  margin: 20px auto;            /* 위아래 여백과 중앙 정렬 */
  font-size: 1.1rem;
  max-width: 850px;             /* 검색바와 동일한 최대 폭 */
}

.category-nav a,
.sort-nav a {
  text-decoration: none;
  color: #696969;               /* 기본은 dimgray */
  transition: color 0.2s;
}

.category-nav a.current,
.sort-nav a.active {
  color: #000000;               /* 선택된 항목은 black */
  font-weight: bold;
  text-decoration: underline;
}

.category-nav .divider {
  color: #ccc;                  /* 구분선도 밝은 회색으로 */
  margin: 0 12px;
}

</style>
</head>
<body>

<!-- /WEB-INF/views/common/tabs.jsp -->
<div class="tabs-container">
  <!-- 좌측: 카테고리 -->
  <div class="category-nav">
    <a href="${pageContext.request.contextPath}/allList"
       class="${mainCategory=='all' ? 'current' : ''}">
      전체목록
    </a>
    <span class="divider">|</span>
    <a href="${pageContext.request.contextPath}/exhibitionlist"
       class="${mainCategory=='전시/미술' ? 'current' : ''}">
      전시/미술
    </a>
    <span class="divider">|</span>
    <a href="${pageContext.request.contextPath}/performancelist"
       class="${mainCategory=='공연' ? 'current' : ''}">
      공연
    </a>
    <span class="divider">|</span>
    <a href="${pageContext.request.contextPath}/eventlist"
       class="${mainCategory=='축제/행사' ? 'current' : ''}">
      축제/행사
    </a>
  </div>

  <!-- 우측: 정렬 -->
  <div class="sort-nav">
    <a href="#" data-sort="mostViewed"
       class="${sort=='mostViewed'  ? 'active' : ''}">
      *인기순
    </a>
    <a href="#" data-sort="newest"
       class="${sort=='newest'      ? 'active' : ''}">
      *최신순
    </a>
    <a href="#" data-sort="endingSoon"
       class="${sort=='endingSoon'  ? 'active' : ''}">
      *마감임박
    </a>
  </div>
</div>

</body>
</html>