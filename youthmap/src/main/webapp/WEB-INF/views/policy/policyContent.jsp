<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정책 상세 페이지</title>
<style>
.policy-summary {
	width: 700px;
	font-family: '맑은 고딕', sans-serif;
	font-size: 14px;
	border-top: 2px solid #000;
	border-collapse: collapse;
	margin-top: 20px;
}

.policy-summary tr {
	border-bottom: 1px solid #ccc;
}

.policy-summary th {
	width: 150px;
	text-align: left;
	padding: 10px;
	vertical-align: top;
	white-space: nowrap;
}

.policy-summary td {
	padding: 10px;
}

.title {
	font-size: 16px;
	font-weight: bold;
	margin-bottom: 10px;
}
</style>
</head>
<body>
	<input type=button value="목록" onclick="location.href='policyMain'">
	<div class="title">한 눈에 보는 정책 요약</div>

	<table class="policy-summary">
		<tr>
			<th>정책번호</th>
			<td>${plcy.plcy_no}</td>
		</tr>
		<tr>
			<th>정책분야</th>
			<td>${plcy.plcy_kywd_nm}</td>
		</tr>
		<tr>
			<th>지원내용</th>
			<td>${plcy.plcy_sprt_cn}</td>
		</tr>
		<tr>
			<th>사업 운영 기간</th>
			<td>${plcy.biz_prd_bgng_ymd}~ ${plcy.biz_prd_end_ymd}</td>
		</tr>
		<tr>
			<th>사업 신청기간</th>
			<td>${plcy.aply_ymd_strt}~ ${plcy.aply_ymd_end}</td>
		</tr>
		<tr>
			<th>지원 규모(명)</th>
			<td>${plcy.sprt_scl_cnt}</td>
		</tr>
	</table>

</body>
</html>