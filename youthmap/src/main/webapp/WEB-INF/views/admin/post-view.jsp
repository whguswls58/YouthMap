<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>게시물 상세 - 관리자</title>
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
        
        .post-detail {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .post-header {
            border-bottom: 2px solid #ecf0f1;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }
        
        .post-title {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .post-meta {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .post-meta span {
            margin-right: 20px;
        }
        
        .post-content {
            line-height: 1.6;
            color: #2c3e50;
            margin-bottom: 30px;
        }
        
        .action-buttons {
            text-align: right;
            margin-top: 20px;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-left: 10px;
        }
        
        .btn-back {
            background-color: #95a5a6;
            color: white;
        }
        
        .btn-edit {
            background-color: #3498db;
            color: white;
        }
        
        .btn-delete {
            background-color: #e74c3c;
            color: white;
        }
        
        .btn:hover {
            opacity: 0.8;
        }
        
        .comments-section {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .comments-title {
            font-size: 20px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 20px;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }
        
        .comment-item {
            border: 1px solid #ecf0f1;
            border-radius: 4px;
            padding: 15px;
            margin-bottom: 10px;
            background-color: #f8f9fa;
        }
        
        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        
        .comment-author {
            font-weight: bold;
            color: #2c3e50;
            font-size: 14px;
        }
        
        .comment-date {
            color: #7f8c8d;
            font-size: 12px;
        }
        
        .comment-content {
            color: #2c3e50;
            line-height: 1.4;
            font-size: 13px;
        }
        
        .comment-actions {
            margin-top: 10px;
            text-align: right;
        }
        
        .btn-comment-delete {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 4px 8px;
            border-radius: 3px;
            cursor: pointer;
            font-size: 11px;
        }
        
        .btn-comment-delete:hover {
            background-color: #c0392b;
        }
        
        .no-comments {
            color: #7f8c8d;
            font-style: italic;
            text-align: center;
            padding: 20px;
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
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="admin-main-content">
        <h2 class="admin-section-title">게시물 상세</h2>

        <!-- 게시물 내용 -->
        <div class="post-detail">
            <div class="post-header">
                <div class="post-title">${board.boardSubject}</div>
                <div class="post-meta">
                    <span>작성자: ${board.memName} (${board.memId})</span>
                    <span>작성일: <fmt:formatDate value="${board.boardDate}" pattern="yyyy-MM-dd HH:mm"/></span>
                    <span>조회수: ${board.boardReadcount}</span>
                    <span>카테고리: ${board.boardCategory}</span>
                </div>
            </div>
            
            <div class="post-content">
                ${board.boardContent}
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/admin/posts" class="btn btn-back">목록으로</a>
                <a href="javascript:void(0);" onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='/boarddelete?boardNo=${board.boardNo}';" class="btn btn-delete">삭제</a>
            </div>
        </div>

        <!-- 댓글 섹션 -->
        <div class="comments-section">
            <div class="comments-title">댓글 목록 (${fn:length(comments)}개)</div>
            
            <c:choose>
                <c:when test="${empty comments}">
                    <div class="no-comments">이 게시물에는 댓글이 없습니다.</div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="comment" items="${comments}">
                        <div class="comment-item">
                            <div class="comment-header">
                                <span class="comment-author">${comment.memName} (${comment.memId})</span>
                                <span class="comment-date">
                                    <fmt:formatDate value="${comment.commDate}" pattern="yyyy-MM-dd HH:mm"/>
                                </span>
                            </div>
                            <div class="comment-content">${comment.commContent}</div>
                            <div class="comment-actions">
                                <form action="${pageContext.request.contextPath}/admin/comments/delete" method="post" style="display: inline;">
                                    <input type="hidden" name="commentNo" value="${comment.commNo}">
                                    <button type="submit" class="btn-comment-delete" 
                                            onclick="return confirm('이 댓글을 삭제하시겠습니까?')">
                                        삭제
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html> 