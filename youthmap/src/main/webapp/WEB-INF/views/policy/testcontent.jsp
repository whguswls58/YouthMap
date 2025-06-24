<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Bootstrap Example</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script> 
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
  
<style>
/* 메인 정책 상세 페이지 스타일 - 순수 CSS 기반 */

body {
  font-family: 'Playfair Display', serif;
  margin: 0;
  padding: 0;
  background-color: #fff;
  color: #333;
}

.container-fluid {
  display: flex;
  justify-content: center;
  padding: 0 40px;
  box-sizing: border-box;
}

.col-sm-2,
.col-md-2 {
  width: 200px;
  box-sizing: border-box;
}

.col-sm-8 {
  flex-grow: 1;
  max-width: 800px;
  padding: 0 20px;
  box-sizing: border-box;
}

.text-center {
  text-align: center;
}

.text-left {
  text-align: left;
}

/* 사이드바 고정 위치 */
.sidebar-fixed {
  position: fixed;
  top: 30%;
  transform: translateY(-50%);
  right: 30px;
  width: 200px;
}

.sidebar-fixed.left {
  left: 30px;
  right: auto;
}

.panel {
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: #ffffff;
}

.p-heading {
  background-color: #f5f0e6;
  color: #333;
  font-size: 14px;
  font-family: 'Playfair Display', serif;
  padding: 10px 15px;
  border-bottom: 1px solid #ccc;
  border-top-left-radius: 6px;
  border-top-right-radius: 6px;
}

.panel-body ul {
  list-style: none;
  margin: 0;
  padding: 0;
}

.panel-body li a {
  display: block;
  padding: 10px 15px;
  color: #337ab7;
  text-decoration: none;
  font-size: 14px;
  font-family: 'Playfair Display', serif;
  transition: background-color 0.2s;
  border-radius: 6px;
}

.panel-body li a:hover {
  background-color: #eee;
}

.policy-table {
  margin: 20px auto;
  width: 100%;
  max-width: 700px;
  border-collapse: collapse;
  font-family: 'Playfair Display', serif;
  font-size: 14px;
  border-top: 2px solid #000;
}

.policy-table th,
.policy-table td {
  padding: 10px;
  text-align: left;
  border-bottom: 1px solid #ccc;
}

.policy-table th {
  width: 150px;
  white-space: nowrap;
  vertical-align: top;
}

.policy-header h2 {
  font-weight: 500;
  font-size: 24px;
  margin-bottom: 10px;
}

.policy-meta {
  font-size: 13px;
  color: #777;
  margin-bottom: 20px;
}

.policy-content {
  font-family: 'Playfair Display', serif;
  font-size: 15px;
  line-height: 1.8;
  color: #333;
  padding: 0 10px;
  text-align: center;
  max-width: 700px;
  margin: 0 auto 40px;
}

.policy-summary-block {
  background: #f9f9f9;
  border-top: 2px solid #000;
  padding: 40px 20px;
  margin-top: 60px;
  display: flex;
  justify-content: space-around;
  flex-wrap: wrap;
  text-align: center;
}

.policy-summary-block .summary-box {
  flex: 1 1 300px;
  padding: 20px;
}

.policy-summary-block h4 {
  font-weight: 600;
  margin-bottom: 10px;
  font-size: 18px;
}

.policy-summary-block p {
  font-size: 14px;
  color: #666;
}

.btn.btn-outline {
  border: 1px solid #ccc;
  background: white;
  color: #333;
  padding: 6px 15px;
  border-radius: 20px;
  transition: all 0.3s;
  display: inline-block;
  text-align: center;
}

.btn.btn-outline:hover {
  background-color: #f1f1f1;
  color: #000;
}

.title {
  text-align: center;
  font-weight: bold;
  font-size: 18px;
  margin-top: 40px;
  margin-bottom: 10px;
}

footer {
  background-color: #555;
  color: white;
  padding: 15px;
  text-align: center;
  margin-top: 40px;
}

/* 상단 바 */
.topbar2 {
  background: #f5f0e6;
  padding: 10px 40px;
}
.topbar2 .menu {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: flex-end;
  gap: 20px;
  font-size: 14px;
}
.topbar2 .menu a {
  color: #444;
  text-decoration: none;
}

.navbar2 {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 40px;
  background: #fff;
  position: sticky;
  top: 0;
  z-index: 1000;
  border-bottom: 1px solid #eee;
}

.navbar2-left,
.navbar2-right {
  display: flex;
  gap: 18px;
}

.navbar2-center {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
}

.nav-link {
  font-size: 15px;
  color: #222;
  text-decoration: none;
}

.nav-link:hover,
.nav-link.active {
  border-bottom: 2px solid #222;
  padding-bottom: 2px;
}

.logo {
  font-size: 20px;
  font-weight: bold;
  letter-spacing: 1px;
  color: #111;
  font-family: 'Playfair Display', serif;
}

/* 반응형 */
@media (max-width: 768px) {
  .container-fluid {
    flex-direction: column;
  }
  .sidebar-fixed,
  .sidebar-fixed.left {
    position: static;
    transform: none;
    margin-bottom: 20px;
  }
  .navbar2 {
    flex-direction: column;
    align-items: flex-start;
  }
  .navbar2-left,
  .navbar2-right,
  .navbar2-center {
    flex-direction: column;
    align-items: flex-start;
  }
  .navbar2-center {
    position: static;
    transform: none;
    margin-top: 10px;
  }
  .policy-summary-block {
    flex-direction: column;
    align-items: center;
  }
  .policy-summary-block .summary-box {
    width: 100%;
  }
  .policy-table {
    width: 100%;
  }
}


</style>
</head>
<body>
<!-- 상단 베이지 바 --<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container-fluid text-center">
	<div class="col-sm-2 sidenav">
		<div class="sidebar-fixed left panel panel-default">
			<div class="p-heading">정부 사이트</div>
			<div class="panel-body">
				<ul class="nav nav-pills nav-stacked">
					<li><a href="https://www.work24.go.kr/cm/main.do">고용24</a></li>
					<li><a href="https://www.2030db.go.kr/">청년인재DB</a></li>
					<li><a href="https://yw.work24.go.kr/main.do">청년일경험포털</a></li>
					<li><a href="https://www.worldjob.or.kr/new_index.do">월드잡플러스</a></li>
					<li><a href="https://nysc.or.kr/nysc/">중앙청년지원센터</a></li>
					<li><a href="https://www.keis.or.kr/keis/ko/index.do">한국고용정보원</a></li>
				</ul>
			</div>
		</div>
	</div>

	<div class="col-sm-8 text-left">
		<input type=button value="목록" onclick="location.href='policyMain'">
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
		<table class="policy-table policy-nm">
			<tr>
				
			</tr>
			<tr>
				<th colspan=4>${plcy.plcy_nm}</th>
			</tr>
			<tr>
				<th>최종 수정일</th>
				<td>${plcy.last_mdfcn_dt}</td>
				<td align=right>조회수</td>
				<td align=right>${plcy.inq_cnt }</td>
			</tr>
			<tr>
				<td colspan=4>
					<c:forEach var="keyword" items="${keywords}">
					    <span class="policy-tag">${keyword}</span>
					</c:forEach>
				</td>
			</tr>
		</table>
		<br><br>
		
		<p class="policy-content" align=center>${plcy.plcy_expln_cn }</p><br>
				
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
			<div class="p-heading">정책 메뉴</div>
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


<footer class="container-fluid text-center">
	<p>Footer Text</p>
</footer>


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
