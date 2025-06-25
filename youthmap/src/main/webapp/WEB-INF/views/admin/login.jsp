<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 로그인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <style>
        .login-container {
            width: 400px;
            margin: 100px auto;
            padding: 30px;
            background-color: #f4f4f4;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
            font-family: sans-serif;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .login-btn {
            width: 100%;
            padding: 10px;
            background-color: #444;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .error-msg {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="login-container">
    <h2>관리자 로그인</h2>

    <c:if test="${not empty error}">
        <div class="error-msg">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/loginProc" method="post">
        <label>아이디</label>
        <input type="text" name="adminId" required>

        <label>비밀번호</label>
        <input type="password" name="adminPass" required>

        <button type="submit" class="login-btn">로그인</button>
    </form>
</div>

</body>
</html> 