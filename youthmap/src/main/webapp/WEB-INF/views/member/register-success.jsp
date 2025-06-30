<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>VIVAMAP</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
</head>
<body>

<script>
    alert("회원가입이 완료되었습니다 🎉\n로그인 페이지로 이동합니다.");
    window.location.href = "${pageContext.request.contextPath}/login";
</script>

</body>
</html> 