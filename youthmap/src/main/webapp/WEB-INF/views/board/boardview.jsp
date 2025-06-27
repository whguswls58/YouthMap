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
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

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
                
                <!-- 이미지 파일 표시 -->
                <c:if test="${not empty imageFiles}">
                    <div class="image-files">
                        <h4>첨부된 이미지</h4>
                        <div class="image-gallery">
                            <c:forEach var="imageFile" items="${imageFiles}">
                                <div class="image-item">
                                    <img src="/fileview?filename=${imageFile.userFilPath}&origin=${imageFile.userFileName}" 
                                         alt="${imageFile.userFileName}" 
                                         onclick="openImageModal(this.src, '${imageFile.userFileName}')">
                                    <div class="image-caption">${imageFile.userFileName}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </td>
        </tr>
        <c:if test="${not empty otherFiles}">
            <tr>
                <th>첨부파일</th>
                <td>
                    <ul>
                        <c:forEach var="file" items="${otherFiles}">
                            <li>
                                <a href="/filedownload?filename=${file.userFilPath}&origin=${file.userFileName}">
                                    📎 ${file.userFileName}
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
            <!-- 수정 (본인만) -->
            <c:if test="${sessionScope.loginMember.memId == board.memId}">
                <a href="/boardupdateform?no=${board.boardNo}" class="board-action-btn">수정</a>
            </c:if>
            <!-- 삭제 (본인 또는 관리자) -->
            <a href="javascript:void(0);"
               onclick="if(confirm('정말 삭제하시겠습니까?'))
                          location.href='/boarddelete?boardNo=${board.boardNo}';"
               class="board-action-btn ${sessionScope.loginMember.memType == 'ADMIN' ? 'admin-delete-btn' : 'delete-btn'}">
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
          <a href="${pageContext.request.contextPath}/login" style="color:#3498db; font-weight:bold; text-decoration:underline;">
            로그인
          </a>
          후 댓글 작성이 가능합니다.
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

    <!-- 이미지 모달 기능 -->
    <script>
        function openImageModal(imageSrc, fileName) {
            // 모달 생성
            const modal = document.createElement('div');
            modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.8);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 1000;
                cursor: pointer;
            `;
            
            // 이미지 생성
            const img = document.createElement('img');
            img.src = imageSrc;
            img.alt = fileName;
            img.style.cssText = `
                max-width: 90%;
                max-height: 90%;
                object-fit: contain;
                border-radius: 5px;
            `;
            
            // 파일명 표시
            const caption = document.createElement('div');
            caption.textContent = fileName;
            caption.style.cssText = `
                position: absolute;
                bottom: 20px;
                left: 50%;
                transform: translateX(-50%);
                color: white;
                background-color: rgba(0, 0, 0, 0.7);
                padding: 10px 20px;
                border-radius: 5px;
                font-size: 14px;
            `;
            
            modal.appendChild(img);
            modal.appendChild(caption);
            document.body.appendChild(modal);
            
            // 클릭 시 모달 닫기
            modal.onclick = function() {
                document.body.removeChild(modal);
            };
        }
    </script>

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



