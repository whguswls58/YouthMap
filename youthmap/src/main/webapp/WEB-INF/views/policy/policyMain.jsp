<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정책 통합 검색 페이지</title>

<style>
	.search-container {
	  text-align: center;
	  margin: 20px 0;
	}
	
	/* 폼 전체 */
	.search-form {
	  display: inline-block;
	}
	
	/* 검색 박스 래퍼 */
	.search-box {
	  display: inline-flex;
	  align-items: center;
	  border: 1px solid #000;
	  border-radius: 6px;
	  background: #eee;
	  overflow: hidden;
	}
	
	/* 셀렉트 박스 */
	.category-select {
	  padding: 8px;
	  border: none;
	  background: transparent;
	  font-size: 1em;
	}
	
	/* 검색어 입력창 */
	.search-input {
	  width: 800px;
	  padding: 8px;
	  border: none;
	  outline: none;
	  font-size: 1em;
	  background: transparent;
	}
	
	/* 검색 버튼 */
	.search-button {
	  border: none;
	  background: #fff;
	  padding: 8px 16px;
	  cursor: pointer;
	  font-size: 1em;
	}
	

  a {
    text-decoration: none;
    color: #007bff;
    margin: 0 5px;
  }
  a:hover {
    text-decoration: underline;
  }	
</style>


</head>
<body>
<input type=button value="첫 화면" onclick="location.href='/'"> <br>

<div class="search-container">
  <form action="${pageContext.request.contextPath}/search" method="get" class="search-form">
    <div class="search-box">
      <!-- 카테고리 선택 -->
      <input type="hidden" name="mainCategory" value="youthPolicy" />
      <select name="mainCategory" class="category-select" disabled>
        <option value="youthPolicy" selected>청년정책</option>
        <option value="culture">문화생활</option>
        <option value="food">맛집</option>
      </select>

      <!-- 검색어 입력 -->
      <input
        type="text"
        name="q"
        class="search-input"
        placeholder="검색어를 입력하세요"
      />

      <!-- 검색 버튼 -->
      <button type="submit" class="search-button">검색</button>
    </div>
  </form>
</div>

검색 된 결과 : ${listcount }개
<table border=1 width=800 align=center>
	<caption><a href="#"><h2></h2></a></caption>
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
						<a href="/policyContent?plcy_no=${p.plcy_no }">${p.plcy_nm}</a>
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

<div id="paginationContainer" align=center>
	<!-- 시작 페이지 -->
	<a href="policyMain?page=1">&lt</a>	
			
	<!-- 이전 페이지 -->
	<c:if test="${startpage > 6 }">
		<a href="policyMain?page=${startpage-6 }">[이전]</a>	
	</c:if>	
	<!-- 페이지 번호 -->
	<c:forEach var="i" begin="${startpage}" end="${endpage }">
		<c:if test="${i == page }">[${i}]</c:if>
		<c:if test="${i != page }"><a href="policyMain?page=${i }">[${i}]</a></c:if>
	</c:forEach>
		
	<!-- 다음 페이지 -->	
	<c:if test="${endpage < pagecount }">
		<a href="policyMain?page=${startpage+6 }">[다음]</a>	
	</c:if>
	<!-- 마지막 페이지 -->
	<a href="policyMain?page=${pagecount }">&gt</a>
</div>
</body>
</html>