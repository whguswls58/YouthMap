<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>정책 상세 페이지</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/policy/policy-detail.css" />
</head>
<body>
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="policy-container text-center">
	<div class="policy-left-side sidenav">
		<div class="sidebar-fixed left sidebar-panel panel-default">
			<div class="p-heading">정부 사이트</div>
			<div class="panel-body">
				<ul>
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

	<div class="policy-content text-left">
		<div class="policy-labels" data-end-date="${plcy.aply_ymd_end}">
				    <!-- 신청 시작일이 null이면 -->
		    <c:choose>
		        <c:when test="${empty plcy.aply_ymd_strt}">
		            <br><span class="policy-label">상시</span>
		        </c:when>
		        <c:otherwise>
		            <br><span class="policy-label dday-text"></span>
		        </c:otherwise>
		    </c:choose>
		    <c:forEach var="lc" items="${lclsf}">
			    <span class="policy-label">${lc}</span>		    
		    </c:forEach>
		</div>
		<table class="policy-table policy-nm">
			
			<tr>
				<th>제목</th>
				<td colspan=3>${plcy.plcy_nm}</td>
			</tr>
			<tr>
				<th>최종 수정일</th>
				<td>${plcy.last_mdfcn_dt}</td>
				<td align=right>조회수</td>
				<td align=right>${plcy.inq_cnt }</td>
			</tr>
			<tr>
				<th>분류</th>
				<td colspan=3>
					<c:forEach var="keyword" items="${keywords}">
					    <span class="policy-tag">${keyword}</span>
					</c:forEach>
				</td>
			</tr>
		</table>
		
		<p class="policy-explane" align=center>${plcy.plcy_expln_cn }</p>
				
		<div id="summary" class="policy-table-title">한 눈에 보는 정책 요약</div>
		<table class="policy-table policy-summary">
			<tr>
				<th>정책번호</th>
				<td>${plcy.plcy_no}</td>
			</tr>
			<tr>
				<th>정책분야</th>
				<td>
					<c:forEach var="lc" items="${lclsf}">
					    <span>${lc}</span>		    
				    </c:forEach>
				
				</td>
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
		<div id="qualification" class="policy-table-title">신청 자격</div>
		
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
					
		<div id="method" class="policy-table-title">신청방법</div>
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

		<div id="etc" class="policy-table-title">기타</div>
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
	</div>
			
	<div class="policy-right-side sidenav">
		<div class="sidebar-fixed sidebar-panel panel-default">
			<div class="p-heading">정책 메뉴</div>
			<div class="panel-body">
				<ul>
					<li><a href="#summary">정책 요약</a></li>
					<li><a href="#qualification">신청자격</a></li>
					<li><a href="#method">신청방법</a></li>
					<li><a href="#etc">기타</a></li>
					<li><a href="policyMain">목록</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>

<script src="${pageContext.request.contextPath}/js/policy-detail.js"></script>
<!-- 푸터 -->
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
