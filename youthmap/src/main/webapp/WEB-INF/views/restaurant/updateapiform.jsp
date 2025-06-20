<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>api 동기</title>
</head>
<body>
<form action="updateapi" method="post">
    <button class="btn" type="submit">API로 동기화 실행</button>
</form>

<c:if test="${not empty insertCnt}">
    <div>
        <span class="insert">신규 추가: <span class="num">${insertCnt}</span></span><br>
        <span class="update">기존 업데이트: <span class="num">${updateCnt}</span></span>
    </div>
</c:if>

</body>
</html>