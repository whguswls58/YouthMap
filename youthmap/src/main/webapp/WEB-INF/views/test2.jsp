<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출력용 페이지</title>
</head>
<body>
<table border=1 width=800 align=center>
	<caption><a href="#"><h2>글목록</h2></a></caption>
	<tr>
		<th>정책명</th>
		<th>키워드</th>
		<th>등록일</th>
		<th>조회수</th>
	</tr>

	<c:if test="${empty pm}">
		<tr>
			<td colspan="5" align=center>데이터가 없습니다</td>
		</tr>
	</c:if>
			
	<c:if test="${not empty pm}">
	
		<c:forEach var="p" items="${pm }" varStatus="status">
			<c:if test="${status.index < 10}">
				<tr>
					<td>
						<a href="#">${p.plcy_nm}</a>
					</td>
					<td>${p.plcy_kywd_nm}</td>
					<td>
						${p.last_mdfcn_dt}
					</td>
					<td>${p.inq_cnt}</td>
				</tr>			
			</c:if>
		</c:forEach>
	</c:if>
</table>

</body>
</html>