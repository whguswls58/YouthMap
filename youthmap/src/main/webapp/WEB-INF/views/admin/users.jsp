<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원관리</title>
</head>
<body>
<h2>회원관리</h2>

<table border="1">
    <tr>
        <th>ID</th>
        <th>이름</th>
        <th>게시물 수</th>
        <th>댓글 수</th>
        <th>가입일</th>
        <th>상태</th>
    </tr>
    <c:forEach items="${members}" var="member">
        <tr>
            <td>${member.memId}</td>
            <td>${member.memName}</td>
            <td>${member.postCount}</td>
            <td>${member.commentCount}</td>
            <td>${member.memDate}</td>
            <td>${member.memStatus}</td>
        </tr>
    </c:forEach>
</table>
</body>
</html> 