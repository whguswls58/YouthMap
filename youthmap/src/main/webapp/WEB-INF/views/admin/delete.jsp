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
        .delete-form {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .delete-warning {
            color: #e74c3c;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        
        .notice-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .notice-info h3 {
            margin: 0 0 10px 0;
            color: #333;
        }
        
        .notice-info p {
            margin: 5px 0;
            color: #666;
        }
        
        .btn-group {
            margin-top: 30px;
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
        }
        
        .btn-cancel {
            background-color: #95a5a6;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
        }
        
        .btn-delete:hover {
            background-color: #c0392b;
        }
        
        .btn-cancel:hover {
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
        <h2 class="admin-section-title">공지사항 삭제</h2>
        
        <div class="delete-form">
            <div class="delete-warning">
                ⚠️ 정말로 이 공지사항을 삭제하시겠습니까?
            </div>
            
            <div class="notice-info">
                <h3>${notice.boardSubject}</h3>
                <p><strong>작성자:</strong> ${notice.memName}</p>
                <p><strong>작성일:</strong> <fmt:formatDate value="${notice.boardDate}" pattern="yyyy년 MM월 dd일"/></p>
                <p><strong>조회수:</strong> ${notice.boardReadcount}</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/admin/list/delete" method="post">
                <input type="hidden" name="boardNo" value="${notice.boardNo}">
                
                <div class="btn-group">
                    <button type="submit" class="btn-delete">삭제 확인</button>
                    <a href="${pageContext.request.contextPath}/admin/list" class="btn-cancel">취소</a>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html> 