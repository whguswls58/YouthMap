<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>📍 맛집 검색 결과</title>
    <style>
        .region-title {
            font-size: 24px;
            margin-top: 40px;
            border-bottom: 2px solid #333;
            padding-bottom: 8px;
        }
        .restaurant-box {
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 15px;
            margin: 15px 0;
            width: 700px;
        }
        img {
            max-width: 100%;
            border-radius: 8px;
        }
        .photo-thumbnails img {
            width: 100px;
            height: 100px;
            margin: 5px;
            object-fit: cover;
            border: 1px solid #aaa;
        }
    </style>
</head>
<body>

<h1>🍽️ 지역별 맛집 리스트</h1>

<c:forEach var="entry" items="${regionMap}">
    <div class="region-title">${entry.key}</div>

    <c:forEach var="r" items="${entry.value}">
        <div class="restaurant-box">

            <!-- 대표 사진 -->
            <c:if test="${not empty r.res_photoUrl}">
                <img src="${r.res_photoUrl}" alt="${r.res_subject} 대표 사진"><br><br>
            </c:if>

            <!-- 썸네일 여러 개 -->
            <c:if test="${not empty r.res_photoUrls}">
                <div class="photo-thumbnails">
                    <c:forEach var="p" items="${r.res_photoUrls}">
                        <img src="${p}" alt="추가 사진">
                    </c:forEach>
                </div>
                <br>
            </c:if>

            <strong>${r.res_subject}</strong><br>
            ⭐ 평점: ${r.res_score} / 총 리뷰 수: ${r.userRatingsTotal}<br>
            📍 주소: ${r.res_address}<br>
            ☎ 전화: ${r.res_tel}<br>
            ⏰ 영업중: 
            <c:choose>
                <c:when test="${r.res_open eq 'true'}">예</c:when>
                <c:otherwise>아니오</c:otherwise>
            </c:choose><br>
            🕒 영업시간:<br>
            <pre style="white-space: pre-wrap;">${r.res_openHours}</pre>
            <c:choose>
    <c:when test="${r.res_priceLevel == -1}">
        💰 가격대: 정보 없음
    </c:when>
    <c:otherwise>
        💰 가격대: ${r.res_priceLevel}
    </c:otherwise>
</c:choose>
            🌐 <a href="${r.res_website}" target="_blank">웹사이트</a> |
            🗺️ <a href="${r.res_mapUrl}" target="_blank">지도 보기</a>
        </div>
    </c:forEach>

</c:forEach>

</body>
</html>
