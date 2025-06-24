<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>게시물 관리</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
    <style>
        .admin-section-title {
            margin-bottom: 30px;
            color: #2c3e50;
            font-size: 24px;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }
        
        .board-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .board-table th,
        .board-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .board-table th {
            background-color: #3498db;
            color: white;
            font-weight: bold;
        }
        
        .board-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .board-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        .board-table a {
            color: #2c3e50;
            text-decoration: none;
        }
        
        .board-table a:hover {
            color: #3498db;
        }
        
        .notice-row {
            background-color: #fff3cd !important;
        }
        
        .notice-row:hover {
            background-color: #ffeaa7 !important;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
            gap: 10px;
        }
        
        .page-link {
            padding: 8px 12px;
            border: 1px solid #ddd;
            text-decoration: none;
            color: #333;
            border-radius: 4px;
        }
        
        .page-link:hover {
            background-color: #f8f9fa;
        }
        
        .page-link.active {
            background-color: #3498db;
            color: white;
            border-color: #3498db;
        }
    </style>
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
        <a href="${pageContext.request.contextPath}/admin/comments">댓글 관리</a>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="admin-main-content">
        <h2 class="admin-section-title">게시물 관리</h2>

        <!-- 게시판 테이블 -->
        <table class="board-table">
            <thead>
            <tr>
                <th>No</th>
                <th>글쓴이</th>
                <th>제목</th>
                <th>작성일</th>
                <th>조회수</th>
            </tr>
            </thead>
            <tbody>
            <!-- 🔔 공지사항 -->
            <c:forEach var="notice" items="${topNotices}">
                <tr class="notice-row">
                    <td>📢</td>
                    <td>${notice.memName}</td>
                    <td><a href="${pageContext.request.contextPath}/admin/posts/view?no=${notice.boardNo}">[공지] ${notice.boardSubject}</a></td>
                    <td><fmt:formatDate value="${notice.boardDate}" pattern="yyyy.MM.dd"/></td>
                    <td>${notice.boardReadcount}</td>
                </tr>
            </c:forEach>

            <!-- 📄 일반 게시글 -->
            <c:forEach var="b" items="${boardlist}" varStatus="status">
                <tr>
                    <td>${listcount - ((page-1) * 10) - status.index}</td>
                    <td>${b.memName}</td>
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
                <c:if test="${page > 1}">
                    <a href="/admin/posts?page=${page-1}" class="page-link">&lt;</a>
                </c:if>
                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <c:when test="${i == page}">
                            <span class="page-link active">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="/admin/posts?page=${i}" class="page-link">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:if test="${page < totalPages}">
                    <a href="/admin/posts?page=${page+1}" class="page-link">&gt;</a>
                </c:if>
            </div>
        </c:if>

    </div>
</div>

</body>
</html>
