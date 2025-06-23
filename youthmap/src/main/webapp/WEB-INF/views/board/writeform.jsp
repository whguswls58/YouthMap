<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/board.css">
</head>
<body>

	<!-- 상단 베이지 바 -->
	<div class="topbar">
		<div class="menu">
			<c:choose>
				<c:when test="${empty sessionScope.loginMember}">
					<a href="/login">로그인</a>
					<a href="/register">회원가입</a>
				</c:when>
				<c:otherwise>
					<a href="/mypage">마이페이지</a>
					<a href="/logout">로그아웃</a>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<!-- ✅ 네비게이션 구조 -->
	<div class="navbar">
		<div class="navbar-left">
			<div class="nav-item">
				<a href="/policyMain" class="nav-link">정책</a>
				<div class="dropdown">
					<a href="/policyMain?mainCategory=일자리">일자리</a> <a
						href="/policyMain?mainCategory=주거">주거</a> <a
						href="/policyMain?mainCategory=교육">교육</a>
				</div>
			</div>
			<div class="nav-item">
				<a href="/culturemain" class="nav-link">문화</a>
				<div class="dropdown">
					<a href="/exhibitionlist">전시/미술</a> <a href="/performancelist">공연</a>
					<a href="/eventlist">축제/행사</a>
				</div>
			</div>
			<div class="nav-item">
				<a href="/res_main" class="nav-link">맛집</a>
				<div class="dropdown">
					<a href="/res_main?res_gu=강남구">강남구</a> <a
						href="/res_main?res_gu=강북구">강북구</a> <a href="/res_main?res_gu=강서구">강서구</a>
					<a href="/res_main?res_gu=강동구">강동구</a>
				</div>
			</div>
			<div class="nav-item">
				<a href="/boardlist" class="nav-link">유저게시판</a>
			</div>

		</div>
		<div class="navbar-center">
			<a href="${pageContext.request.contextPath}/home" class="logo">YOUTHMAP</a>
		</div>

		<div class="navbar-right">
			<c:if test="${not empty sessionScope.loginMember}">
				<input type="hidden" id="session-start-time"
					value="${sessionScope.loginStartTime}" />
				<span style="color: #333; font-size: 12px;">환영합니다 <b>${sessionScope.loginMember.memName}</b>님
				</span>
				<span id="login-timer"
					style="font-weight: bold; color: #d33; font-size: 14px;"></span>
			</c:if>
		</div>
	</div>

	<!-- Hero 이미지 영역 -->
	<div class="hero-section">
		<img src="${pageContext.request.contextPath}/img/123.jpg"
			alt="Hero Image" class="hero-img" />
	</div>
	<div class="container">
		<div class="write-outer">
			<div class="write-container">

				<h2>게시글 작성</h2>

				<!-- 폼 제출 시 /boardwrite 로 POST 전송 -->
				<form class="write-form" action="/boardwrite" method="post"
					enctype="multipart/form-data">

					<div class="title-row">
						<select name="boardCategory" required>
							<option value="">카테고리 선택</option>
							<option value="정책">정책</option>
							<option value="문화">문화</option>
							<option value="맛집">맛집</option>
							<option value="자유게시판">자유게시판</option>
						</select>

						<div class="title-input-wrap">
							<input type="text" name="boardSubject" maxlength="60"
								placeholder="제목을 입력하세요" oninput="updateByteCount(this)">
							<span class="byte-count"><span id="byteNow">0</span> / 60
								bytes (한글 30자)</span>
						</div>
					</div>

					<div class="content-wrap">
						<textarea name="boardContent" placeholder="내용을 입력하세요" required></textarea>
					</div>

					<div class="file-wrap">
						<label for="uploadFile">첨부파일</label> <input type="file"
							name="uploadFile" id="uploadFile">
					</div>

					<div class="btn-group">
						<a href="/boardlist" class="cancel-btn">취소</a>
						<button type="submit" class="submit-btn">등록</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- ✅ 푸터 -->
<div class="footer">
  <div class="footer-icons">
    <a href="#"><img src="${pageContext.request.contextPath}/img/face.png" alt="facebook"></a>
    <a href="#"><img src="${pageContext.request.contextPath}/img/insta.png" alt="instagram"></a>
    <a href="#"><img src="${pageContext.request.contextPath}/img/twit.svg" alt="twitter"></a>
  </div>

  <p>
    Tel. 000-0000-0000 | Fax. 00-0000-0000 | vivade@vivade.com<br>
    Addr. Seoul, Korea | Biz License 000-00-00000
  </p>

  <p>&copy; 2025 YOUTHMAP. All Rights Reserved.<br>Hosting by YOUTHMAP Team</p>
</div>
		<script src="/js/session.js"></script>
</body>
</html>
