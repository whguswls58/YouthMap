<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문화생활 메인</title>
</head>
<body>


<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="mainCategory" value="${mainCategory}" />
<c:set var="search"        value="${search}" />
<c:set var="keyword"       value="${keyword}" />

<div style="text-align:center; margin:20px 0;">
  <form action="${ctx}/search" method="get" style="display:inline-block;">

    <div style="
      display:inline-flex; align-items:center;
      border:1px solid #000; border-radius:6px;
      background:#eee; overflow:hidden;
    ">
      <!-- 1) 메인 카테고리 -->
      <select name="mainCategory"
              style="padding:8px; border:none; font-size:1em;">
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
      <select name="search"
              style="padding:8px; border:none; font-size:1em;">
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
      <input type="text" name="keyword" value="${keyword}"
             placeholder="검색어를 입력하세요"
             style="
               width:300px; padding:8px;
               border:none; font-size:1em;
               background:transparent;
             " />

      <!-- 4) 검색 버튼 -->
      <button type="submit" style="
        border:none; background:#fff;
        padding:8px 16px; cursor:pointer;
        font-size:1em;
      ">
        검색
      </button>
    </div>
  </form>
</div>
</body>
</html>
