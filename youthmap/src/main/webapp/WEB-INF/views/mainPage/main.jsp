<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="true"%>

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
		<!-- 헤더 전체 시작 -->
		<header class="main-header">
			<div class="header-top">
				<div class="logo">
					<a href="/"><img src="../img/YouthMap_logo.png"
						alt="YouthMap 로고" /></a>
				</div>
				<nav class="main-nav">
					<ul>
						<li><a href="/policy">정책</a></li>
						<li><a href="/culture">문화</a></li>
						<li><a href="/food">맛집</a></li>
						<li><a href="/board">유저게시판</a></li>
					</ul>
				</nav>
				<div class="auth-box">
					<c:choose>
						<c:when test="${not empty sessionScope.mem_id}">
							<div class="welcome-msg">${sessionScope.mem_id}님환영합니다.</div>
							<div class="auth-links">
								<a href="/mypage">마이페이지</a> | <a href="/logout">로그아웃</a>
							</div>
						</c:when>
						<c:otherwise>
							<a href="/login" class="login-btn">로그인</a>
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<!-- 드롭다운 영역 -->
			<div class="mega-dropdown">
				<div class="mega-dropdown-inner">
					<div class="dropdown-column">
						<h4>정책</h4>
						<a href="/policy/support">지원</a> <a href="/policy/housing">주거</a>
						<a href="/policy/benefit">혜택</a>
					</div>
					<div class="dropdown-column">
						<h4>문화</h4>
						<a href="/culture/theater">뮤지컬/연극</a> <a href="/culture/exhibit">전시회/미술관</a>
						<a href="/culture/festival">대회/축제</a>
					</div>
					<div class="dropdown-column">
						<h4>맛집</h4>
						<a href="/food/gangnam">강남구</a> <a href="/food/gangbuk">강북구</a> <a
							href="/food/gangseo">강서구</a> <a href="/food/gangdong">강동구</a>
					</div>
					<div class="dropdown-column">
						<h4>유저 게시판</h4>
						<a href="/board">유저 게시판</a>
					</div>
				</div>
			</div>
		</header>

		<!-- 헤더 전체 끝 -->

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
            <li>
                ■ / ${notice.memId} /
                <a href="/boardview?no=${notice.boardNo}">
                    ${notice.boardSubject}
                </a> /
                <fmt:formatDate value="${notice.boardDate}" pattern="yyyy.MM.dd a hh:mm" /> /
                ${notice.boardReadcount}
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