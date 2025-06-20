<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>검색바</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

<style>
  /* 검색 */
.search-wrapper {
  display: flex;
  justify-content: center;
  margin: 50px 0;
  z-index: 1;
  position: relative;
}
.search-bar {
  display: flex;
  align-items: center;
  background: #f2f2f2;
  padding: 20px 40px;
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.05);
  gap: 12px;
  width: 800px;
  justify-content: center;
}
.search-combined {
  display: flex;
  background-color: #fff;
  border-radius: 6px;
  overflow: hidden;
  border: 1px solid #ccc;
  flex-grow: 1;
  max-width: 900px;
  position: relative;
  z-index: 10;
}
.search-combined select {
  border: none;
  padding: 12px 16px;
  font-size: 14px;
  background-color: #fff;
  border-right: 1px solid #ccc;
  position: relative;
  z-index: 10;
}
.search-combined select option {
  z-index: 1000;
  position: relative;
}
.search-combined input[type="text"] {
  border: none;
  padding: 12px 16px;
  font-size: 14px;
  width: 100%;
  outline: none;
}
.search-bar input[type="submit"] {
  padding: 12px 20px;
  background-color: #888;
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: bold;
  cursor: pointer;
}
.search-bar input[type="submit"]:hover {
  background-color: #666;
}
</style>


</head>
<body>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="mainCategory" value="${mainCategory}" />
<c:set var="search"        value="${search}" />
<c:set var="keyword"       value="${keyword}" />

<div class="search-wrapper">
  <form class="search-bar" action="${ctx}/culturesearch" method="get">
    <div class="search-combined">
      <!-- 1) 메인 카테고리 -->
      <select name="mainCategory">
        <option value="all"
          <c:if test="${mainCategory=='all'}">selected</c:if>>
          전체
        </option>
        <option value="exhibition"
          <c:if test="${mainCategory=='exhibition'}">selected</c:if>>
          전시/미술
        </option>
        <option value="performance"
          <c:if test="${mainCategory=='performance'}">selected</c:if>>
          공연
        </option>
        <option value="event"
          <c:if test="${mainCategory=='event'}">selected</c:if>>
          축제/행사
        </option>
      </select>

      <!-- 2) 검색 대상 -->
      <select name="search">
        <option value="con_title"
          <c:if test="${search=='con_title'}">selected</c:if>>
          제목
        </option>
        <option value="con_location"
          <c:if test="${search=='con_location'}">selected</c:if>>
          위치
        </option>
      </select>

      <!-- 3) 키워드 -->
      <input type="text"
             name="keyword"
             value="${keyword}"
             placeholder="검색어를 입력하세요" />
    </div>

    <!-- 4) 검색 버튼 -->
    <input type="submit" value="검색" />
  </form>
</div>



<!-- ✅ 검색 -->
<%-- <div class="search-wrapper">
  <form class="search-bar" action="${ctx}/culturesearch" method="get">
    <div class="search-combined">
      <select name="mainCategory">
        <option value="all"
          <c:if test="${mainCategory=='all'}">selected</c:if>>
          전체
        </option>
        <option value="exhibition"
          <c:if test="${mainCategory=='exhibition'}">selected</c:if>>
          전시/미술
        </option>
        <option value="performance"
          <c:if test="${mainCategory=='performance'}">selected</c:if>>
          공연
        </option>
        <option value="event"
          <c:if test="${mainCategory=='event'}">selected</c:if>>
          축제/행사
        </option>
      </select>
      <input type="text" name="keyword" placeholder="검색어 입력">
    </div>
    <input type="submit" value="검색">
  </form>
</div> --%>


</body>
</html>
