<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/culture/header.jsp" %>


<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>공연 리스트</title>
  
  
  <style>
   
.cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  max-width: 1200px;
  margin: 0 auto;
  box-sizing: border-box;
  justify-items: center;
}

.card {
  position: relative;
  box-sizing: border-box;
  border: 1px solid #ddd;
  border-radius: 8px;
  overflow: hidden;
  background: #fff;
  text-align: center;
  width: 250px;   /* 카드 크기 고정 */
}

.img-wrap {
  width: 100%;
  height: 300px;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
  text-align: center;
}
.img-wrap img {
  max-width: 90%;
  max-height: 90%;
  border-radius: 8px;
}

.card-info {
  padding: 10px;
  box-sizing: border-box;
  text-align: center;
}

/* 제목(한 줄 말줄임) */
.card-info .title {
  font-weight: bold;
  margin-bottom: 4px;
  text-align: center;
  overflow: hidden;
}
.card-info .title a {
  display: block;         /* 필수: block이나 inline-block */
  width: 100%;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  text-decoration: none !important;
  color: inherit !important;
}

.card-info .period {
  width: 100%;
  font-size: 0.9rem;
  color: #555;
  text-align: center;
  margin-bottom: 2px;
}

.card-info .location {
  text-align: center;
  margin-top: 2px;
  overflow: hidden;
  color: #555;
}
.card-info .location a {
  display: block;         /* 필수 */
  width: 100%;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  text-decoration: none !important;
  color: inherit !important;
}

/* 카드 전체 클릭 가능하게 하는 경우(이미지, 제목, 날짜) */
a.card-link {
  text-decoration: none !important;
  color: inherit !important;
  display: block;
}

/* 뱃지 */
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
.badge.exhibitionlist    { background: #008060; }
.badge.performancelist   { background: #a83279; }
.badge.eventlist         { background: #0066cc; }

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
  /* 카드 호버 애니메이션 추가 */
    .cards .card {
      transition: all 0.3s ease-in-out;
    }
    .cards .card:hover {
      transform: translateY(-4px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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
  </h2><br>

   <!-- 카드 그리드 -->
  <div class="cards">
  <c:forEach var="cul" items="${performancelist}">
    <div class="card">
      <!-- 1) 카테고리 뱃지 -->
      <div class="badge performancelist">${cul.category_name}</div>

      <!-- 2) 이미지에 링크 -->
      <a class="card-link" href="${pageContext.request.contextPath}/performancecont?con_id=${cul.con_id}">
        <div class="img-wrap">
          <img src="${cul.con_img}" alt="${cul.con_title}" />
        </div>
      </a>
      <!-- 3) 카드 정보 -->
      <div class="card-info">
        <!-- 제목에 링크 -->
        <div class="title">
          <a class="card-link" href="${pageContext.request.contextPath}/performancecont?con_id=${cul.con_id}">
            ${cul.con_title}
          </a>
        </div>
        <!-- 날짜+장소에 링크 -->
         <div class="period">
    ${cul.con_start_date} ~ ${cul.con_end_date}
  </div>
  <div class="location">
    <a class="card-link" href="${pageContext.request.contextPath}/performancecont?con_id=${cul.con_id}">
      ${cul.con_location}
    </a>
  </div>
      </div>
    </div>
  </c:forEach>
</div>

  <!-- 페이징 UI -->
  <div class="pager">
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
  </div>

</body>
</html>
