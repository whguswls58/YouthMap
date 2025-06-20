<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드</title>
    <style>
        .dashboard-container {
            max-width: 1000px;
            margin: 50px auto;
            padding: 30px;
            background-color: #fafafa;
            border-radius: 10px;
            box-shadow: 0 0 10px #ddd;
            font-family: sans-serif;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
        }

        .stats {
            display: flex;
            justify-content: space-around;
            margin-bottom: 30px;
        }

        .card {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 5px #ccc;
            width: 200px;
            text-align: center;
        }

        .card h3 {
            margin: 10px 0;
        }

        .buttons {
            display: flex;
            justify-content: space-evenly;
            flex-wrap: wrap;
            gap: 20px;
        }

        .buttons a,
        .buttons button {
            padding: 12px 25px;
            background-color: #444;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="dashboard-container">
    <h2>관리자 대시보드</h2>

    <div class="stats">
        <div class="card">
            <h3>회원 수</h3>
            <p>${userCount}</p>
        </div>
        <div class="card">
            <h3>게시물 수</h3>
            <p>${postCount}</p>
        </div>
        <div class="card">
            <h3>댓글 수</h3>
            <p>${commentCount}</p>
        </div>
    </div>

    <div class="buttons">
        <a href="${pageContext.request.contextPath}/admin/users">회원 관리</a>
        <a href="${pageContext.request.contextPath}/admin/posts">게시물 관리</a>
        <a href="${pageContext.request.contextPath}/admin/comments">댓글 관리</a>
        <form action="${pageContext.request.contextPath}/admin/updateApi" method="post" style="display:inline;">
            <button type="submit">API 수동 갱신 정책</button>
            <button type="submit">API 수동 갱신 문생</button>
        </form>
    </div>
</div>

</body>
</html> 