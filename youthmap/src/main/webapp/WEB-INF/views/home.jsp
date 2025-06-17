<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>홈</title>
</head>
<body>
	<!-- 환영 메시지 -->
	<c:if test="${not empty sessionScope.loginMember}">
		<p>환영합니다 ${sessionScope.loginMember.memName}님</p>
	</c:if>

	<a href="${pageContext.request.contextPath}/mypage">마이페이지</a>
	<a href="${pageContext.request.contextPath}/logout">로그아웃</a>

	<c:if test="${not empty withdrawSuccess}">
		<script>
			alert("회원 탈퇴가 완료되었습니다.");
		</script>
	</c:if>

</body>
</html> 