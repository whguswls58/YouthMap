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
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        
        .content-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
        }
        
        th {
            background-color: #f5f5f5;
            font-weight: bold;
            width: 120px;
        }
        
        .board-action-btn {
            display: inline-block;
            margin-left: 10px;
            padding: 5px 12px;
            text-decoration: none;
            color: #007bff;
            border: 1px solid #007bff;
            border-radius: 3px;
            font-size: 12px;
        }
        
        .board-action-btn:hover {
            background-color: #007bff;
            color: white;
        }
        
        .comment-section {
            margin-top: 30px;
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
        }
        
        .comment-form {
            margin-top: 15px;
        }
        
        .comment-form textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 3px;
            resize: vertical;
            margin-bottom: 10px;
        }
        
        .comment-form-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }
        
        .comment-form-wrapper textarea {
            flex: 1;
            margin-right: 10px;
            margin-bottom: 0;
        }
        
        .comment-form button {
            padding: 8px 16px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            white-space: nowrap;
        }
        
        .comment-form button:hover {
            background-color: #0056b3;
        }
        
        .comment-item {
            margin-bottom: 15px;
            padding: 10px;
            border-bottom: 1px solid #eee;
            position: relative;
        }
        
        .comment-header {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }
        
        .comment-content {
            margin-bottom: 5px;
            padding-right: 60px; /* 삭제 버튼 공간 확보 */
        }
        
        .comment-delete-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 3px 8px;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .comment-delete-btn:hover {
            background-color: #c82333;
        }
        
        .action-buttons {
            text-align: center;
            margin-top: 20px;
        }
        
        .action-buttons a {
            display: inline-block;
            margin: 0 10px;
            padding: 8px 16px;
            text-decoration: none;
            color: #007bff;
            border: 1px solid #007bff;
            border-radius: 3px;
        }
        
        .action-buttons a:hover {
            background-color: #007bff;
            color: white;
        }
        
        .error-message {
            color: #dc3545;
            font-style: italic;
        }
    </style>
</head>
<body>
   
    <!-- 상단 베이지 바 -->
<div class="topbar">
  <div class="menu">
    <a href="#">CART</a>
    <a href="#">MY PAGE</a>
    <a href="#">JOIN</a>
  </div>
</div>

<!-- 네비게이션 -->
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

<div class="content-container">
 <h2>게시글 상세보기</h2>
    <table border="1" width="800" align="center">
        <!-- 번호 숨김 처리 -->
        <input type="hidden" name="boardNo" value="${board.boardNo}" />
        <tr>
            <th>작성자</th>
            <td>${board.memId}</td>
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
    <input type="hidden" id="boardNo" value="${board.boardNo}" />
    <div class="comment-section">
        <h3>댓글</h3>
        <div id="commentList"></div>
        <form id="commentForm" class="comment-form">
            <c:choose>
                <c:when test="${not empty sessionScope.loginMember}">
                    <div class="comment-form-wrapper">
                        <textarea id="commentInput" rows="3" placeholder="댓글을 입력하세요."></textarea>
                        <button type="submit">등록</button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="comment-form-wrapper">
                        <textarea rows="3" placeholder="로그인 후 댓글 작성이 가능합니다." disabled></textarea>
                        <button type="button" onclick="checkLoginBeforeComment()">등록</button>
                    </div>
                </c:otherwise>
            </c:choose>
        </form>
    </div>

    <!-- 액션 버튼 -->
    <div class="action-buttons">
        <a href="/boardlist?page=${page}">목록으로</a>
    </div>
</div>

    <!-- 디버그 로그 -->
    <script>
        console.log("boardNo =", '${board.boardNo}');
        console.log("board object =", '${board}');
        console.log("board.boardNo type =", typeof '${board.boardNo}');
        
        // ✅ 댓글 기능에 필요한 JavaScript 변수 정의
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
</body>
</html>



