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
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

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
						<label for="uploadFile">첨부파일 (선택사항, 최대 10MB)</label> 
						<input type="file" name="uploadFile" id="uploadFile" accept="image/*,.pdf,.doc,.docx,.txt">
						<small style="color: #666;">지원 형식: 이미지, PDF, Word, 텍스트 파일</small>
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
