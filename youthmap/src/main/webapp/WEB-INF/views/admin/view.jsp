<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>VIVAMAP</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
    <style>
        .notice-detail {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .notice-header {
            border-bottom: 2px solid #3498db;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        
        .notice-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .notice-meta {
            color: #666;
            font-size: 14px;
        }
        
        .notice-meta span {
            margin-right: 20px;
        }
        
        .notice-content {
            line-height: 1.8;
            color: #333;
            font-size: 16px;
            min-height: 200px;
            white-space: pre-wrap;
        }
        
        .btn-group {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .btn-edit {
            background-color: #3498db;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
            text-decoration: none;
        }
        
        .btn-delete {
            background-color: #e74c3c;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
            text-decoration: none;
        }
        
        .btn-list {
            background-color: #95a5a6;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
        }
        
        .btn-edit:hover {
            background-color: #2980b9;
        }
        
        .btn-delete:hover {
            background-color: #c0392b;
        }
        
        .btn-list:hover {
            background-color: #7f8c8d;
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
        <a href="${pageContext.request.contextPath}/admin/posts">게시물 관리</a>
        <a href="${pageContext.request.contextPath}/admin/list" class="active">공지 관리</a>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="admin-main-content">
        <h2 class="admin-section-title">공지사항 상세</h2>
        
        <div class="notice-detail">
            <div class="notice-header">
                <div class="notice-title">${notice.boardSubject}</div>
                <div class="notice-meta">
                    <span><strong>작성자:</strong> ${notice.memName}</span>
                    <span><strong>작성일:</strong> <fmt:formatDate value="${notice.boardDate}" pattern="yyyy년 MM월 dd일 HH:mm"/></span>
                    <span><strong>조회수:</strong> ${notice.boardReadcount}</span>
                </div>
            </div>
            
            <div class="notice-content">
                ${notice.boardContent}
            </div>
            
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/admin/list/edit?no=${notice.boardNo}" class="btn-edit">수정</a>
                <a href="${pageContext.request.contextPath}/admin/list/delete?no=${notice.boardNo}" class="btn-delete">삭제</a>
                <a href="${pageContext.request.contextPath}/admin/list" class="btn-list">목록</a>
            </div>
        </div>
    </div>
</div>

</body>
</html> 