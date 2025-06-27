<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원관리</title>
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
        
        .member-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .member-table th,
        .member-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .member-table th {
            background-color: #3498db;
            color: white;
            font-weight: bold;
        }
        
        .member-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .member-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }
    </style>
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
        
        <a href="${pageContext.request.contextPath}/admin/dashboard">대시보드</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="active">회원 관리</a>
        <a href="${pageContext.request.contextPath}/admin/posts">게시물 관리</a>
        <a href="${pageContext.request.contextPath}/admin/list">공지 관리</a>
    </div>


  <!-- 메인 콘텐츠 -->
  <div class="admin-main-content">

    <h2 class="admin-section-title">회원관리</h2>

    <table class="member-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>이름</th>
          <th>게시물 수</th>
          <th>댓글 수</th>
          <th>가입일</th>
          <th>상태</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${members}" var="member">
          <tr>
            <td>${member.memId}</td>
            <td>${member.memName}</td>
            <td>${member.postCount}</td>
            <td>${member.commentCount}</td>
            <td><fmt:formatDate value="${member.memDate}" pattern="yyyy-MM-dd" /></td>
            <td>${member.memStatus}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

  </div>
</div>

</body>
</html>