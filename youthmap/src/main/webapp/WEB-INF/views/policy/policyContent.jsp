<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Bootstrap Example</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<style>
.policy-table {
	width: 700px;
	font-family: '맑은 고딕', sans-serif;
	font-size: 14px;
	border-top: 2px solid #000;
	border-collapse: collapse;
	margin-top: 20px;
}

.policy-table tr {
	border-bottom: 1px solid #ccc;
}

.policy-table th {
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

/* 템플릿 */
.navbar {
	margin-bottom: 0;
	border-radius: 0;
}

.row.content {
	height: 450px
}

.sidenav {
	padding-top: 20px;
	background-color: #f1f1f1;
	height: 100%;
}

footer {
	background-color: #555;
	color: white;
	padding: 15px;
}

@media screen and (max-width: 767px) {
	.sidenav {
		height: auto;
		padding: 15px;
	}
	.row.content {
		height: auto;
	}
}

/* 우측 네비게이션 고정 스타일 */
.sidebar-fixed {
	position: fixed;
	top: 80px;
	right: 30px;
	width: 200px;
}
</style>
</head>
<body>

	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#myNavbar">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="#">Logo</a>
			</div>
			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav">
					<li class="active"><a href="#">Home</a></li>
					<li><a href="#">About</a></li>
					<li><a href="#">Projects</a></li>
					<li><a href="#">Contact</a></li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li><a href="#"><span class="glyphicon glyphicon-log-in"></span>
							Login</a></li>
				</ul>
			</div>
		</div>
	</nav>

	<div class="container-fluid text-center">
		<div class="row content">
			<div class="col-sm-2 sidenav">
				<p>
					<a href="https://www.work24.go.kr/cm/main.do">고용24</a>
				</p>
				<p>
					<a href="https://www.2030db.go.kr/">청년인재DB</a>
				</p>
				<p>
					<a href="https://yw.work24.go.kr/main.do">청년일경험포털</a>
				</p>
				<p>
					<a href="https://www.worldjob.or.kr/new_index.do">월드잡플러스</a>
				</p>
				<p>
					<a href="https://nysc.or.kr/nysc/">중앙청년지원센터</a>
				</p>
				<p>
					<a href="https://www.keis.or.kr/keis/ko/index.do">한국고용정보원</a>
				</p>
			</div>
			
			<div class="col-sm-8 text-left">
				<input type=button value="목록" onclick="location.href='policyMain'">

				<table class="policy-table policy-nm">
					<tr>
					<div class="policy-labels" data-end-date="${plcy.aply_ymd_end}">
					        <!-- 신청 시작일이 null이면 -->
					    <c:choose>
					        <c:when test="${empty plcy.aply_ymd_strt}">
					            <span class="policy-label">상시</span>
					        </c:when>
					        <c:otherwise>
					            <span class="policy-label dday-text"></span>
					        </c:otherwise>
					    </c:choose>
					    <span class="policy-label">${plcy.lclsf_nm}</span><br>
					</div>
					</tr>
					<tr>
						<th>${plcy.plcy_nm}</th>
					</tr>
					<tr>
						<th>최종 수정일</th>
						<td>${plcy.last_mdfcn_dt}</td>
						<td align=right>조회수</td>
						<td align=right>${plcy.inq_cnt }</td>
					</tr>
					<tr>
						<td>
							<c:forEach var="keyword" items="${keywords}">
							    <span class="policy-tag">${keyword}</span>
							</c:forEach>
						</td>
					</tr>
				</table>
				<br><br>
				
				<p class="conts-wrap bbs-info">
					${plcy.plcy_expln_cn }
				</p>
				<br>
				
				<div id="summary" class="title">한 눈에 보는 정책 요약</div>

				<table class="policy-table policy-summary">
					<tr>
						<th>정책번호</th>
						<td>${plcy.plcy_no}</td>
					</tr>
					<tr>
						<th>정책분야</th>
						<td>${plcy.lclsf_nm}</td>
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
						<td>${plcy.sprt_scl_cnt} 명</td>
					</tr>
				</table>
				<br><br>
				<div id="qualification" class="title">신청 자격</div>
				
				<table class="policy-table policy-qualification">
					<tr>
						<th>연령</th>
						<td>
						 <c:choose>
				            <%-- 둘 다 null 또는 0인 경우 --%>
				            <c:when test="${empty plcy.sprt_trgt_min_age and empty plcy.sprt_trgt_max_age 
				                          or (plcy.sprt_trgt_min_age == 0 and plcy.sprt_trgt_max_age == 0)}">
				                제한없음
				            </c:when>
				
				            <%-- min만 null 또는 0 --%>
				            <c:when test="${(empty plcy.sprt_trgt_min_age or plcy.sprt_trgt_min_age == 0) 
				                            and (not empty plcy.sprt_trgt_max_age and plcy.sprt_trgt_max_age != 0)}">
				                ${plcy.sprt_trgt_max_age}세 미만
				            </c:when>
				
				            <%-- max만 null --%>
				            <c:when test="${(not empty plcy.sprt_trgt_min_age and plcy.sprt_trgt_min_age != 0) 
				                            and (empty plcy.sprt_trgt_max_age or plcy.sprt_trgt_max_age == 0)}">
				                ${plcy.sprt_trgt_min_age}세 이상
				            </c:when>
				
				            <%-- 둘 다 존재하는 경우 --%>
				            <c:otherwise>
				                ${plcy.sprt_trgt_min_age}세 ~ ${plcy.sprt_trgt_max_age}세
				            </c:otherwise>
				        </c:choose>
						</td>
					</tr>
					<tr>
						<th>거주구역</th>
						<td>${plcy.lclsf_nm}</td>
					</tr>
					<tr>
						<th>소득</th>
						<td>
						<c:choose>
							<c:when test="${plcy.earn_cnd_se_cd == '0043003' and not empty plcy.earn_max_amt}">
								${plcy.earn_etc_cn }
							</c:when>
						
				            <%-- 둘 다 null 또는 0인 경우 --%>
				            <c:when test="${empty plcy.earn_min_amt and empty plcy.earn_max_amt 
				                          or (plcy.earn_min_amt == 0 and plcy.earn_max_amt == 0)}">
				                무관
				            </c:when>
				
				            <%-- min만 null 또는 0 --%>
				            <c:when test="${(empty plcy.earn_min_amt or plcy.earn_min_amt == 0) 
				                            and (not empty plcy.earn_max_amt and plcy.earn_max_amt != 0)}">
				                ${plcy.earn_max_amt}만원 미만
				            </c:when>
				
				            <%-- max만 null --%>
				            <c:when test="${(not empty plcy.earn_min_amt and plcy.earn_min_amt != 0) 
				                            and (empty plcy.earn_max_amt or plcy.earn_max_amt == 0)}">
				                ${plcy.earn_min_amt}만원 이상
				            </c:when>
				
				            <%-- 둘 다 존재하는 경우 --%>
				            <c:otherwise>
				                ${plcy.earn_min_amt}만원 이상 ~ ${plcy.earn_max_amt}만원 미만
				            </c:otherwise>
				        </c:choose>
						</td>
					</tr>
					<tr>
						<th>학력</th>
						<td>
							${plcy.school_cd }
						</td>
					</tr>
					<tr>
						<th>전공</th>
						<td>${plcy.plcy_major_cd}</td>
					</tr>
					<tr>
						<th>취업상태</th>
						<td>${plcy.job_cd}</td>
					</tr>
					<tr>
						<th>특화분야</th>
						<td>${plcy.s_biz_cd}</td>
					</tr>
					<tr>
						<th>추가사항</th>
						<td>${plcy.add_aply_qlfc_cnd_cn}</td>
					</tr>
					<tr>
						<th>참여제한 대상</th>
						<td>${plcy.ptcp_prp_trgt_cn}</td>
					</tr>
				</table>
				
				<br>
					
				<div id="method" class="title">신청방법</div>
				<table class="policy-table policy-method">
					<tr>
						<th>신청절차</th>
						<td>${plcy.plcy_aply_mthd_cn}</td>
					</tr>
					<tr>
						<th>심사 및 발표</th>
						<td>${plcy.srng_mthd_cn}</td>
					</tr>
					<tr>
						<th>신청 사이트</th>
						<td><a href='${plcy.aply_url_addr}'>${plcy.aply_url_addr}</a></td>
					</tr>
					<tr>
						<th>제출 서류</th>
						<td>${plcy.sbmsn_dcmnt_cn}</td>
					</tr>
				</table>
				<br><br>

				<div id="etc" class="title">기타</div>
				<table class="policy-table policy-etc">
					<tr>
						<th>기타 정보</th>
						<td>${plcy.etc_mttr_cn}</td>
					</tr>
					<tr>
						<th>참고 사이트 1</th>
						<td><a href='${plcy.ref_url_addr1}'>${plcy.ref_url_addr1}</a></td>
					</tr>
					<tr>
						<th>참고 사이트 2</th>
						<td><a href='${plcy.ref_url_addr2}'>${plcy.ref_url_addr2}</a></td>
					</tr>
				</table>
				<br><br>
			</div>
			
			
			<div class="col-md-2 sidenav">
				<div class="sidebar-fixed panel panel-default">
					<div class="panel-heading">정책 메뉴</div>
					<div class="panel-body">
						<ul class="nav nav-pills nav-stacked">
							<li><a href="#summary">정책 요약</a></li>
							<li><a href="#qualification">신청자격</a></li>
							<li><a href="#method">신청방법</a></li>
							<li><a href="#etc">기타</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>

	<footer class="container-fluid text-center">
		<p>Footer Text</p>
	</footer>

<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script>
	// D-Day 출력
	function getDday(dateStr) {
 		
		if (!dateStr) return "";
 		
		const endDate = new Date(dateStr.slice(0, 4), dateStr.slice(4, 6) - 1, dateStr.slice(6, 8));
	    const today = new Date();
		
	    // 시차 제거
	    endDate.setHours(0, 0, 0, 0);
	    today.setHours(0, 0, 0, 0);

	    const diffTime = endDate.getTime() - today.getTime();
	    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

		// 출력 포맷
		if (diffDays > 0) {
		    return `D-\${diffDays}`;
		} else if (diffDays === 0) {
			return "D-Day";
		} else {
			return `D+\${Math.abs(diffDays || 0)}`;
		}
	}
 	
	// 모든 dday-text 요소에 대해 D-Day 계산 후 삽입
    document.querySelectorAll('.policy-labels').forEach(label => {
        const date = label.getAttribute('data-end-date');
        const ddaySpan = label.querySelector('.dday-text');
        if (ddaySpan && date) {
            ddaySpan.textContent = getDday(date);
        }
    });
	
</script>

</body>
</html>
