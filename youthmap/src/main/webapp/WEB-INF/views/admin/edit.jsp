<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>VIVAMAP</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
    <style>
        .write-form {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .form-group textarea {
            height: 300px;
            resize: vertical;
        }
        
        .btn-group {
            text-align: center;
            margin-top: 30px;
        }
        
        .btn-submit {
            background-color: #3498db;
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
        
        .btn-submit:hover {
            background-color: #2980b9;
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
        <h2 class="admin-section-title">공지사항 수정</h2>
        
        <div class="write-form">
            <form action="${pageContext.request.contextPath}/admin/list/edit" method="post">
                <input type="hidden" name="boardNo" value="${notice.boardNo}">
                
                <div class="form-group">
                    <label for="boardSubject">제목</label>
                    <input type="text" id="boardSubject" name="boardSubject" value="${notice.boardSubject}" required>
                </div>
                
                <div class="form-group">
                    <label for="boardContent">내용</label>
                    <textarea id="boardContent" name="boardContent" required>${notice.boardContent}</textarea>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn-submit">공지사항 수정</button>
                    <a href="${pageContext.request.contextPath}/admin/list" class="btn-cancel">취소</a>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html> 