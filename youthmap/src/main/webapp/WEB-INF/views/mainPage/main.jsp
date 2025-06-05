<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- main.jsp -->
<!DOCTYPE html>
<html>
<head>
<title>YouthMap - 메인 페이지</title>
<link rel="stylesheet" href="../css/main.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="wrapper">
		<header class="sticky-header">
			<div class="header-container">
				<div class="logo">
					<a href="/"> <img src="/img/YouthMap_logo.png" alt="로고" />
					</a>
				</div>
				<nav class="main-nav">
					<div class="nav-item">정책</div>
					<div class="nav-item">문화</div>
					<div class="nav-item">맛집</div>
					<div class="nav-item">
						<a href="/board">유저 게시판</a>
					</div>

					<div class="dropdown-full">
						<div class="dropdown-column">
							<strong>정책</strong> <a href="/policy/support">지원</a> <a
								href="/policy/housing">주거</a> <a href="/policy/benefit">혜택</a>
						</div>
						<div class="dropdown-column">
							<strong>문화</strong> <a href="/culture/theater">뮤지컬/연극</a> <a
								href="/culture/exhibit">전시회/미술관</a> <a href="/culture/festival">대회/축제</a>
						</div>
						<div class="dropdown-column">
							<strong>맛집</strong> <a href="/food/gangnam">강남구</a> <a
								href="/food/gangseo">강서구</a>
						</div>
					</div>
				</nav>
				<div class="user-menu">
					<c:choose>
						<c:when test="${empty sessionScope.loginUser}">
							<a href="/login">로그인</a>
						</c:when>
						<c:otherwise>
							<div>${sessionScope.loginUser.nickname}님환영합니다.</div>
							<div>
								<a href="/mypage">마이페이지</a> | <a href="/logout">로그아웃</a>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</header>

		<div class="slider-login-row">
			<section class="slider-section">
				<div class="slider">
					<div class="slide">YouthMap에 오신 것을 환영합니다</div>
					<div class="slide">
						<a href="/policy">정책 보러가기</a>
					</div>
					<div class="slide">
						<a href="/culture">문화 즐기기</a>
					</div>
					<div class="slide">
						<a href="/food">맛집 탐방</a>
					</div>
				</div>
			</section>

			<section class="login-box">
				<img src="../img/Profile_icon.png" alt="Profile_icon"> <a
					href="/login" class="login-button">로그인</a>
				<div class="login-links">
					<a href="/find-id">아이디 찾기</a> | <a href="/find-pw">비밀번호 찾기</a> | <a
						href="/signup">회원가입</a>
				</div>
			</section>
		</div>

		<section class="category-banner">
			<div class="category-tabs">
				<button class="tab policy">정책</button>
				<button class="tab culture">문화</button>
				<button class="tab food">맛집</button>
				<button class="tab board">유저 게시판</button>
			</div>
			<div class="subcategories">
				<div class="subcategory">예: 주거, 혜택...</div>
			</div>
		</section>

		<section class="notice-board">
			<h2>공지사항</h2>
			<ul class="notice-list">
				<c:forEach var="notice" items="${noticeList}">
					<li>■ / ${notice.writer} / <a
						href="/board/detail?id=${notice.post_id}">${notice.title}</a> /
						${notice.date} / ${notice.views}
					</li>
				</c:forEach>
			</ul>
		</section>

		<section class="team-section">
			<div class="team-member">
				<img src="../img/Profile_icon.png" alt="member">
				<p>홍길동</p>
			</div>
			<div class="team-member">
				<img src="../img/Profile_icon.png" alt="member">
				<p>홍길동</p>
			</div>
			<div class="team-member">
				<img src="../img/Profile_icon.png" alt="member">
				<p>홍길동</p>
			</div>
			<div class="team-member">
				<img src="../img/Profile_icon.png" alt="member">
				<p>홍길동</p>
			</div>
			<div class="team-member">
				<img src="../img/Profile_icon.png" alt="member">
				<p>홍길동</p>
			</div>
		</section>

		<footer>
			<div class="footer-text">© 2025 YouthMap Team | SNS 링크 | etc</div>
		</footer>
	</div>

	<script src="../js/main.js"></script>
</body>
</html>