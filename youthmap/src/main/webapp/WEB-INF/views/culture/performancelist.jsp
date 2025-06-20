<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ include file="/WEB-INF/views/culture/header.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>공연 리스트</title>
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
      text-align: left;
    }
    .card img {
      width: 100%;
      height: 120px;
      object-fit: cover;
      display: block;
    }
    /* 뱃지 스타일 (공연 텍스트) */
    .badge {
      position: absolute;
      top: 7px;
      right: 7px;
      background: #ff6600;    /* 주황색 배경 */
      color: #fff;
      padding: 4px 12px;
      border-radius: 12px;
      font-size: 0.85rem;
      font-weight: bold;
      white-space: nowrap;
      box-shadow: 0 2px 4px rgba(0,0,0,0.2);
      z-index: 10;
    }
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
    }
    /* 링크 */
    a.card-link {
      position: relative;
      z-index: 0;
      text-decoration: none;
      color: inherit;
      display: block;
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

<%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>

  <div align="center" style="margin:20px 0;">
	<button onclick="location.href='allList'" style=" width:100px; height:26px; line-height:26px; text-align:center; 
            font-size:18px; margin:0 8px; cursor:pointer;">
      전체 목록
    </button>
  <button type="button" onclick="location.href='exhibitionlist'"
            style="
            width:100px;
            height:26px;
            line-height:26px;			/* 버튼 높이랑 같게 */
            text-align:center;
            font-size:18px;
            margin:0 8px;
            cursor:pointer;">
    전시/미술
  </button>

  <button type="button" onclick="location.href='performancelist'"
	  style="
          width:100px;
          height:26px;
          line-height:26px;
          text-align:center;
          font-size:18px;
          margin:0 8px;
          cursor:pointer; ">
    공연
  </button>

  <button type="button" onclick="location.href='eventlist'"
          style="
            width:100px;
            height:26px;
            line-height:26px;
            text-align:center;
            font-size:18px;
            margin:0 8px;
            cursor:pointer; ">
    축제/행사
  </button>
</div><br><hr>

  <h2 style="text-align:center; margin:20px 0;">
    공연
  </h2>

  <!-- 카드 그리드 -->
  <div class="cards">
    <c:forEach var="cul" items="${performancelist}">
      <div class="card">
        <!-- 카테고리 뱃지 -->
        <div class="badge">${cul.category_name}</div>

        <!-- 카드 링크 & 이미지 -->
        <a class="card-link"
           href="${pageContext.request.contextPath}/performancecont?page=${page}&con_id=${cul.con_id}">
          <img src="${cul.con_img}" alt="${cul.con_title}" />
        </a>

        <!-- 카드 정보 -->
        <div class="card-info">
          <div class="title">${cul.con_title}</div>
          <div class="period"
               style="width:200px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
            ${cul.con_start_date} ~ ${cul.con_end_date}<br/>
            ${cul.con_location}
          </div>
        </div>
      </div>
    </c:forEach>
  </div>

  <!-- 페이징 UI -->
  <div class="pager">
    <c:if test="${page > 1}">
      <a href="performancelist?page=1">&laquo;</a>
    </c:if>
    <c:if test="${startpage > 10}">
      <a href="performancelist?page=${startpage-10}">[이전]</a>
    </c:if>
    <c:forEach var="i" begin="${startpage}" end="${endpage}">
      <c:choose>
        <c:when test="${i == page}">
          <span class="current">${i}</span>
        </c:when>
        <c:otherwise>
          <a href="performancelist?page=${i}">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
    <c:if test="${endpage < pagecount}">
      <a href="performancelist?page=${startpage+10}">[다음]</a>
    </c:if>
    <c:if test="${page < pagecount}">
      <a href="performancelist?page=${pagecount}">&raquo;</a>
    </c:if>
  </div>

</body>
</html>
