<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 상세보기</title>
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
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
        <a href="/policyMain?mainCategory=일자리">일자리</a>
        <a href="/policyMain?mainCategory=주거">주거</a>
        <a href="/policyMain?mainCategory=교육">교육</a>
      </div>
      </div>
      <div class="nav-item">
    <a href="/culturemain" class="nav-link">문화</a>
    <div class="dropdown">
       <a href="/exhibitionlist">전시/미술</a>
       <a href="/performancelist">공연</a>
      <a href="/eventlist">축제/행사</a>
    </div>
    </div>
    <div class="nav-item">
    <a href="/res_main" class="nav-link">맛집</a>
    <div class="dropdown">
       <a href="/res_main?res_gu=강남구">강남구</a>
       <a href="/res_main?res_gu=강북구">강북구</a>
       <a href="/res_main?res_gu=강서구">강서구</a>
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
      <input type="hidden" id="session-start-time" value="${sessionScope.loginStartTime}" />
      <span style="color: #333; font-size: 12px;">환영합니다 <b>${sessionScope.loginMember.memName}</b>님</span>
      <span id="login-timer" style="font-weight: bold; color: #d33; font-size: 14px;"></span>
    </c:if>
  </div>
</div>
<!-- Hero 이미지 영역 -->
<div class="hero-section">
  <img src="${pageContext.request.contextPath}/img/123.jpg" alt="Hero Image" class="hero-img" />
</div>
<div class ="container">
<div class="container">
<div class="content-container">
 <h2>게시글 상세보기</h2>
    <table border="1">
        <!-- 번호 숨김 처리 -->
        <input type="hidden" name="boardNo" value="${board.boardNo}" />
        <tr>
            <th>작성자</th>
            <td>${board.memName}</td>
        </tr>
        <tr>
            <th>카테고리</th>
            <td>${board.boardCategory}</td>
        </tr>
        <tr>
            <th>제목</th>
            <td>${board.boardSubject}</td>
        </tr>
        <tr>
            <th>작성일</th>
            <td>
                <fmt:formatDate value="${board.boardDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
            </td>
        </tr>
        <tr>
            <th>조회수</th>
            <td>${board.boardReadcount}</td>
        </tr>
        <tr>
            <th>내용</th>
            <td style="height: 200px;">
                ${board.boardContent}
            </td>
        </tr>
        <c:if test="${not empty fileList}">
            <tr>
                <th>첨부파일</th>
                <td>
                    <ul>
                        <c:forEach var="file" items="${fileList}">
                            <li>
                                <a href="/filedownload?filename=${file.userFilPath}&origin=${file.userFileName}">
                                    ${file.userFileName}
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </td>
            </tr>
        </c:if>
    </table>

    <!-- 게시물 수정/삭제 버튼 -->
    <c:if test="${sessionScope.loginMember.memId == board.memId 
               or sessionScope.loginMember.memType == 'ADMIN'}">
        <div style="text-align: right; margin: 20px 0;">
            <!-- 수정 -->
            <a href="/boardupdateform?no=${board.boardNo}" class="board-action-btn">수정</a>
            <!-- 삭제 -->
            <a href="javascript:void(0);"
               onclick="if(confirm('정말 삭제하시겠습니까?'))
                          location.href='/boarddelete?boardNo=${board.boardNo}';"
               class="board-action-btn">
                삭제
            </a>
        </div>
    </c:if>

    <!-- 댓글 섹션 -->
 <!-- 숨겨진 게시글 번호 -->
<input type="hidden" id="boardNo" value="${board.boardNo}" />

<!-- 댓글 섹션 -->
<div class="comment-section">
  <!-- 헤더 -->
  <div class="comment-header">
    <h3>댓글 ${commentCount}</h3>
    <div class="comment-meta">
      ${currentBytes} / 600 bytes (한글 300자)
    </div>
  </div>

  <!-- ① 댓글 입력 폼 (리스트 위로 이동) -->
  <form id="commentForm" class="comment-form">
    <c:choose>
      <c:when test="${not empty sessionScope.loginMember}">
        <div class="comment-form-wrapper">
          <textarea
            id="commentInput"
            name="content"
            placeholder="댓글을 입력하세요..."
            oninput="updateByteCount()"
          ></textarea>
          <button type="submit">등록</button>
        </div>
      </c:when>
      <c:otherwise>
        <div class="comment-login-prompt">
          로그인 후 댓글 작성이 가능합니다.
        </div>
      </c:otherwise>
    </c:choose>
  </form>

  <!-- ② 댓글 리스트 -->
  <ul class="comment-list" id="commentList">
    <!-- JS 또는 JSP forEach 로 <li class="comment-item">…</li> 추가 -->
  </ul>
</div>


    <!-- 액션 버튼 -->
    <div class="action-buttons">
        <a href="/boardlist?page=${page}">목록으로</a>
    </div>
</div>
</div>

    <!-- 디버그 로그 -->
    <script>
        console.log("boardNo =", '${board.boardNo}');
        console.log("board object =", '${board}');
        console.log("board.boardNo type =", typeof '${board.boardNo}');
        
        // 댓글 기능에 필요한 JavaScript 변수 정의
        var loginUserId = '${sessionScope.loginMember.memId}';
        var loginUserRole = '${sessionScope.loginMember.memType}';
        
        console.log("loginUserId =", loginUserId);
        console.log("loginUserRole =", loginUserRole);
    </script>

    <!-- 댓글 기능 JS -->
    <script src="/js/JYjs/comment.js"></script>

    <!-- 로그인 유도 JS -->
    <script>
        function checkLoginBeforeComment() {
            alert("댓글 작성은 로그인 후 이용 가능합니다.");
            location.href = "/login";
        }
    </script>
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



