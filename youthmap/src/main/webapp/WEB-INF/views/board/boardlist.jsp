<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 목록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>
<body>
<div class="topbar">
  <div class="menu">
    <a href="#">CART</a>
    <a href="#">MY PAGE</a>
    <a href="#">JOIN</a>
  </div>
</div>

<div class="navbar">
  <div class="navbar-left">
    <a href="#" class="nav-link">About</a>
    <a href="#" class="nav-link">Facility</a>
    <a href="#" class="nav-link active">Food</a>
    <a href="#" class="nav-link">Community</a>
    <a href="#" class="nav-link">Contact</a>
  </div>
  <div class="navbar-center">
    <a href="${pageContext.request.contextPath}/home" class="logo">YOUTHMAP</a>
  </div>
  <div class="navbar-right">
    <a href="#" class="nav-link">CART</a>
    <a href="#" class="nav-link">MY PAGE</a>
    <a href="#" class="nav-link">JOIN</a>
  </div>
</div>

<div class="hero-section">
  <div class="category-tabs">
    <a href="/boardlist" class="${empty category ? 'active' : ''}">전체</a>
    <a href="/boardlist?category=공지사항" class="${category == '공지사항' ? 'active' : ''}">공지</a>
    <a href="/boardlist?category=정책" class="${category == '정책' ? 'active' : ''}">정책</a>
    <a href="/boardlist?category=문화" class="${category == '문화' ? 'active' : ''}">문화</a>
    <a href="/boardlist?category=맛집" class="${category == '맛집' ? 'active' : ''}">맛집</a>
    <a href="/boardlist?category=유저게시판" class="${category == '유저게시판' ? 'active' : ''}">유저게시판</a>
  </div>
</div>

  <div class="write-btn-wrap">
    <c:choose>
      <c:when test="${empty sessionScope.loginMember}">
        <button onclick="alert('로그인이 필요합니다.'); location.href='/login';">글작성</button>
      </c:when>
      <c:otherwise>
        <form action="/boardwrite" method="get">
          <button type="submit">글작성</button>
        </form>
      </c:otherwise>
    </c:choose>
  </div>

  <table class="board-table">
    <thead>
      <tr>
        <th>No</th>
        <th>제목</th>
        <th>글쓴이</th>
        <th>작성일</th>
        <th>조회수</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="notice" items="${topNotices}">
        <tr class="notice-row">
          <td>📢</td>
          <td><a href="boardview?no=${notice.boardNo}">[공지] ${notice.boardSubject}</a></td>
          <td>${notice.memId}</td>
          <td><fmt:formatDate value="${notice.boardDate}" pattern="yyyy.MM.dd"/></td>
          <td>${notice.boardReadcount}</td>
        </tr>
      </c:forEach>
      <c:forEach var="b" items="${boardlist}">
        <tr>
          <td>${b.boardNo}</td>
          <td><a href="boardview?no=${b.boardNo}">${b.boardSubject}</a></td>
          <td>${b.memId}</td>
          <td><fmt:formatDate value="${b.boardDate}" pattern="yyyy.MM.dd"/></td>
          <td>${b.boardReadcount}</td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
   <form action="/boardlist" method="get" class="search-form">
    <input type="hidden" name="category" value="${category}" />
    <select name="searchType">
      <option value="subject" ${searchType == 'subject' ? 'selected' : ''}>제목</option>
      <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
      <option value="writer" ${searchType == 'writer' ? 'selected' : ''}>작성자</option>
    </select>
    <input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력" />
    <button type="submit">🔍</button>
  </form>
  
  
  
  <div class="footer">
  <div class="footer-icons">
    <a href="#"><img src="/img/face.png" alt="facebook"></a>
    <a href="#"><img src="/img/insta.png" alt="instagram"></a>
    <a href="#"><img src="/img/twit.svg" alt="twitter"></a>
  </div>

  <p>
    Tel. 000-0000-0000 | Fax. 00-0000-0000 | vivade@vivade.com<br>
    Addr. Seoul, Korea | Biz License 000-00-00000
  </p>

  <p>&copy; 2025 YOUTHMAP. All Rights Reserved.<br>Hosting by YOUTHMAP Team</p>
</div>
</div>
</body>
</html>
