<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>구글 로그인 성공</title>
</head>
<body>
  <h2>환영합니다, ${name}님!</h2>
  <p>이메일: ${email}</p>
  <a href="${pageContext.request.contextPath}/home">메인으로</a>
</body>
</html> 