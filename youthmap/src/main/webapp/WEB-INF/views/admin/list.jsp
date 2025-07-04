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
        <a href="${pageContext.request.contextPath}/admin/posts">게시물 관리</a>
        <a href="${pageContext.request.contextPath}/admin/list" class="active">공지 관리</a>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="admin-main-content">
        <div class="section-header">
            <h2 class="admin-section-title">공지사항 관리</h2>
            <a href="${pageContext.request.contextPath}/admin/list/write" class="action-btn btn-manage">공지사항 작성</a>
        </div>

        <!-- 공지사항 테이블 -->
        <table class="board-table">
            <thead>
            <tr>
                <th>No</th>
                <th>글쓴이</th>
                <th>제목</th>
                <th>작성일</th>
                <th>조회수</th>
                <th style="width:300px;">관리</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="notice" items="${noticelist}" varStatus="status">
                <tr>
                    <td>${listcount - ((page-1) * 10) - status.index}</td>
                    <td>${notice.memName}</td>
                    <td><a href="${pageContext.request.contextPath}/admin/list/view?no=${notice.boardNo}">${notice.boardSubject}</a></td>
                    <td><fmt:formatDate value="${notice.boardDate}" pattern="yyyy.MM.dd"/></td>
                    <td>${notice.boardReadcount}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/list/edit?no=${notice.boardNo}" class="action-btn btn-edit" style="min-width:50px; margin-right:5px;">수정</a>
                        <a href="${pageContext.request.contextPath}/admin/list/delete?no=${notice.boardNo}" class="action-btn btn-delete" style="min-width:50px;">삭제</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- 페이징 -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <!-- 첫 페이지로 이동 -->
                <c:if test="${page > 1}">
                    <a href="/admin/list?page=1" class="page-link"><<</a>
                </c:if>
                
                <!-- 이전 페이지 -->
                <c:if test="${page > 1}">
                    <a href="/admin/list?page=${page-1}" class="page-link"><</a>
                </c:if>
                
                <!-- 페이지 번호들 -->
                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <c:when test="${i == page}">
                            <span class="page-link active">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="/admin/list?page=${i}" class="page-link">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <!-- 다음 페이지 -->
                <c:if test="${page < totalPages}">
                    <a href="/admin/list?page=${page+1}" class="page-link">></a>
                </c:if>
                
                <!-- 마지막 페이지로 이동 -->
                <c:if test="${page < totalPages}">
                    <a href="/admin/list?page=${totalPages}" class="page-link">>></a>
                </c:if>
            </div>
        </c:if>

    </div>
</div>
<!-- 푸터 -->
	<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html> 