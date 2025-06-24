<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>데이터 업데이트 결과</title>
</head>
<body>
    <h2>데이터 업데이트 결과</h2>
    <p>
        <c:out value="${message}" />
    </p>
    <p>
        <a href="<c:url value='/culturemain' />">메인으로 돌아가기</a>
    </p>
</body>
</html>






