<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
</head>
<body>
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- 관리자 대시보드 레이아웃 -->
<div class="admin-dashboard-container">
    <!-- 사이드바 -->
    <div class="admin-sidebar">
        <div class="admin-title">
            관리자 대시보드
        </div>
        
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">대시보드</a>
        <a href="${pageContext.request.contextPath}/admin/users">회원 관리</a>
        <a href="${pageContext.request.contextPath}/admin/posts">게시물 관리</a>
        <a href="${pageContext.request.contextPath}/admin/list">공지 관리</a>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="admin-main-content">
        <!-- 통계 카드 -->
        <div class="dashboard-stats">
            <div class="stat-card">
                <h3>전체 회원 수</h3>
                <div class="stat-number">${userCount}</div>
                <div class="stat-description">가입된 회원</div>
            </div>
            <div class="stat-card">
                <h3>전체 게시물 수</h3>
                <div class="stat-number">${postCount}</div>
                <div class="stat-description">작성된 게시물</div>
            </div>
            <div class="stat-card">
                <h3>전체 댓글 수</h3>
                <div class="stat-number">${commentCount}</div>
                <div class="stat-description">작성된 댓글</div>
            </div>
            <div class="stat-card">
                <h3>등록된 정책</h3>
                <div class="stat-number">${policyCount}</div>
                <div class="stat-description">데이터베이스</div>
            </div>
            <div class="stat-card">
                <h3>등록된 문화</h3>
                <div class="stat-number">${cultureCount}</div>
                <div class="stat-description">데이터베이스</div>
            </div>
            <div class="stat-card">
                <h3>등록된 맛집</h3>
                <div class="stat-number">${restaurantCount}</div>
                <div class="stat-description">데이터베이스</div>
            </div>
        </div>

        <!-- API 갱신 -->
        <div class="api-form">
            <h3>API 수동 갱신</h3>
            <div class="api-buttons">
                <form action="${pageContext.request.contextPath}/admin/updateApi" method="post" style="display:inline;">
                    <button type="submit" name="apiType" value="policy" class="action-btn success">정책 API 갱신</button>
                    <button type="submit" name="apiType" value="restaurant" class="action-btn success">맛집 API 갱신</button>
                    <button type="submit" name="apiType" value="culture" class="action-btn success">문화 API 갱신</button>
                </form>
            </div>
        </div>
    </div>
</div>

<footer>
    ⓒ 2025 YOUTHMAP. All Rights Reserved.
</footer>
</body>
</html> 