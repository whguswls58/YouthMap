<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 목록</title>
</head>
<body>

<!-- 로그인 정보 표시 -->
<c:if test="${not empty sessionScope.memId}">
    <p>어서오세요, ${sessionScope.memId}님!</p>
    <c:if test="${sessionScope.memRole == 'ADMIN'}">
    <p style="color:red;">[관리자 로그인 중]</p>
</c:if>
</c:if>

    <!-- 글작성 버튼 -->
<c:choose>
    <c:when test="${empty sessionScope.memId}">
        <button type="button" onclick="alert('로그인이 필요합니다.'); location.href='/login';">글작성</button><br>
    </c:when>
    <c:otherwise>
        <form action="/boardwrite" method="get" style="display:inline;">
    <button type="submit">글작성</button>
</form>
    </c:otherwise>
</c:choose><br>
    글갯수 : ${listcount} 개
    
    <!-- 카테고리 필터 -->
<div style="text-align:center; margin: 10px 0;">
    <a href="/boardlist" ${empty category ? 'style="font-weight:bold;"' : ''}>전체</a> |
    <a href="/boardlist?category=공지사항"${category == '공지사항' ? 'style="font-weight:bold;"' : ''}>공지</a> |
    <a href="/boardlist?category=정책" ${category == '정책' ? 'style="font-weight:bold;"' : ''}>정책</a> |
    <a href="/boardlist?category=문화" ${category == '문화' ? 'style="font-weight:bold;"' : ''}>문화</a> |
    <a href="/boardlist?category=맛집" ${category == '맛집' ? 'style="font-weight:bold;"' : ''}>맛집</a> |
    <a href="/boardlist?category=유저게시판" ${category == '유저게시판' ? 'style="font-weight:bold;"' : ''}>유저게시판</a>
</div>

<!-- 검색 폼 (boardlist.jsp 위쪽에 배치 추천) -->
<form action="/boardlist" method="get" style="text-align:center; margin: 20px 0;">
    <input type="hidden" name="category" value="${category}" /> <!-- 현재 카테고리 유지 -->
    
    <select name="searchType">
        <option value="subject" ${searchType == 'subject' ? 'selected' : ''}>제목</option>
        <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
        <option value="writer" ${searchType == 'writer' ? 'selected' : ''}>작성자</option>
    </select>
    <input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력" />
    <button type="submit">검색</button>
</form>

<!-- 📌 게시판 테이블 (공지 + 일반 글 함께 출력) -->
<table border="1" align="center" width="800">
    <caption><h3>📋 게시판 목록</h3></caption>
    <tr>
        <th>번호</th>
        <th>작성자</th>
        <th>제목</th>
        <th>날짜</th>
        <th>조회수</th>
    </tr>

    <!-- 🔸 공지사항 출력 (최대 3개) -->
    <c:forEach var="notice" items="${topNotices}">
        <tr style="background-color: #ffffe0; font-weight: bold;">
            <td>📢(공지)</td>
            <td>${notice.memId}</td>
            <td>
                <a href="boardview?no=${notice.boardNo}">
                    [${notice.boardCategory}] ${notice.boardSubject}
                </a>
            </td>
            <td><fmt:formatDate value="${notice.boardDate}" pattern="yyyy.MM.dd a hh:mm"/></td>
            <td>${notice.boardReadcount}</td>
        </tr>
    </c:forEach>

    <!-- 🔹 일반 게시글 출력 (7개 페이징) -->
    <c:forEach var="b" items="${boardlist}">
        <tr>
            <td>
                <c:choose>
                	<c:when test="${b.boardCategory == '공지' || b.boardCategory == '공지사항'}">📢(공지)</c:when>
                    <c:when test="${b.boardCategory == '정책'}">📰(정책)</c:when>
                    <c:when test="${b.boardCategory == '문화'}">🎨(문화)</c:when>
                    <c:when test="${b.boardCategory == '맛집'}">🍽️(맛집)</c:when>
                    <c:when test="${b.boardCategory == '유저게시판'}">👤(유저)</c:when>
                    <c:otherwise>❓</c:otherwise>
                </c:choose>
            </td>
            <td>${b.memId}</td>
            <td>
                <a href="boardview?no=${b.boardNo}">
                    [${b.boardCategory}] ${b.boardSubject}
                </a>
            </td>
            <td><fmt:formatDate value="${b.boardDate}" pattern="yyyy.MM.dd a hh:mm"/></td>
            <td>${b.boardReadcount}</td>
        </tr>
    </c:forEach>
</table>
    
    <!-- 페이지 처리 -->
    <center>
    <c:if test="${listcount > 0}">
        <a href="boardlist?page=1" style="text-decoration:none"> < </a>
        
        <c:if test="${startpage > 10}">
            <a href="boardlist?page=${startpage - 10}">[이전]</a>
        </c:if>
        
        <c:forEach var="i" begin="${startpage}" end="${endpage}">
            <c:if test="${i == page}">
                [${i}]
            </c:if>
            <c:if test="${i != page}">
                <a href="boardlist?page=${i}&category=${category}">[${i}]</a>
            </c:if>
        </c:forEach>
        
        <c:if test="${endpage < pagecount}">
            <a href="boardlist?page=${startpage + 10}">[다음]</a>
        </c:if>
        
        <a href="boardlist?page=${pagecount}" style="text-decoration:none"> > </a>
    </c:if>
    </center>
</body>
</html>