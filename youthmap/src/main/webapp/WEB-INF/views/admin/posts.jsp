<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>VIVAMAP</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
</head>
<body>

<!-- 헤더 -->
<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- 관리자 레이아웃 -->
<div class="admin-dashboard-container">
    <!-- 사이드바 -->
    <div class="admin-sidebar">
        <div class="admin-title">관리자 대시보드</div>
        <a href="${pageContext.request.contextPath}/admin/dashboard">대시보드</a>
        <a href="${pageContext.request.contextPath}/admin/users">회원 관리</a>
        <a href="${pageContext.request.contextPath}/admin/posts" class="active">게시물 관리</a>
        <a href="${pageContext.request.contextPath}/admin/list">공지 관리</a>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="admin-main-content">
        <div class="section-header">
            <h2 class="admin-section-title">게시물 관리</h2>
            <!-- 검색 기능 -->
            <div class="search-container">
                <form action="${pageContext.request.contextPath}/admin/posts" method="get" style="display: inline-block;">
                    <input type="text" name="search" value="${param.search}" placeholder="제목 또는 글쓴이 검색" 
                           style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; width: 200px; margin-right: 10px;">
                    <button type="submit" style="padding: 8px 16px; background-color: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer;">검색</button>
                </form>
            </div>
        </div>

        <!-- 게시판 테이블 -->
        <table class="board-table">
            <thead>
            <tr>
                <th>No</th>
                <th>글쓴이</th>
                <th>카테고리</th>
                <th>제목</th>
                <th>작성일</th>
                <th>조회수</th>
            </tr>
            </thead>
            <tbody>
            <!-- 📄 일반 게시글 -->
            <c:forEach var="b" items="${boardlist}" varStatus="status">
                <tr>
                    <td>${listcount - ((page-1) * 10) - status.index}</td>
                    <td>${b.memName}</td>
                    <td>${b.boardCategory}</td>
                    <td><a href="${pageContext.request.contextPath}/admin/posts/view?no=${b.boardNo}">${b.boardSubject}</a></td>
                    <td><fmt:formatDate value="${b.boardDate}" pattern="yyyy.MM.dd"/></td>
                    <td>${b.boardReadcount}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- 페이징 -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <!-- 첫 페이지로 이동 -->
                <c:if test="${page > 1}">
                    <a href="/admin/posts?page=1&search=${param.search}" class="page-link"><<</a>
                </c:if>
                
                <!-- 이전 페이지 -->
                <c:if test="${page > 1}">
                    <a href="/admin/posts?page=${page-1}&search=${param.search}" class="page-link"><</a>
                </c:if>
                
                <!-- 페이지 번호들 -->
                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <c:when test="${i == page}">
                            <span class="page-link active">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="/admin/posts?page=${i}&search=${param.search}" class="page-link">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <!-- 다음 페이지 -->
                <c:if test="${page < totalPages}">
                    <a href="/admin/posts?page=${page+1}&search=${param.search}" class="page-link">></a>
                </c:if>
                
                <!-- 마지막 페이지로 이동 -->
                <c:if test="${page < totalPages}">
                    <a href="/admin/posts?page=${totalPages}&search=${param.search}" class="page-link">>></a>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

</body>
</html>
