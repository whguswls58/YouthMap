<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 상세보기</title>
</head>
<body>
    <h2>게시글 상세보기</h2>

    <table border="1" width="800" align="center">
        <%-- 번호 표시 제거 (숨김 처리) --%>
<%-- 
<tr>
    <th width="100">번호</th>
    <td>${board.boardNo}</td>
</tr>
--%>

<!-- 내부적으로 값 유지 -->
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
    
   <!-- 세션값 가져오기 -->
<input type="hidden" id="boardNo" value="${board.boardNo}" />
<input type="hidden" id="memId" value="${sessionScope.loginId}" />

<h3>댓글</h3>
<div id="commentBox">
    <div id="commentList"></div>

    <form id="commentForm">
        <c:choose>
    <c:when test="${not empty sessionScope.loginId}">
        <textarea id="commentInput" rows="3" cols="60" placeholder="댓글을 입력하세요."></textarea><br/>
        <button type="submit">등록</button>
    </c:when>
    <c:otherwise>
        <textarea rows="3" cols="60" placeholder="로그인 후 댓글 작성이 가능합니다." disabled></textarea><br/>
        <button type="button" onclick="checkLoginBeforeComment()">등록</button>
    </c:otherwise>
</c:choose>
    </form>
</div>

    <div style="text-align: center; margin-top: 20px;">
    <a href="/boardlist?page=${page}">목록으로</a>

    <c:if test="${sessionScope.loginId == board.memId or sessionScope.loginRole == 'ADMIN'}">
        <a href="/boardupdateform?no=${board.boardNo}">수정</a>
        <a href="javascript:void(0);" onclick="confirmDelete(${board.boardNo})">삭제</a>
    </c:if>
</div>
    
    <script src="/js/JYjs/comment.js"></script>
    
    <script>
    const loginUserId = '${sessionScope.loginId}';
    const loginUserRole = '${sessionScope.loginRole}'; // 관리자 여부 확인용
</script>
    
    <script>
function confirmDelete(boardNo) {
    if (confirm("정말 삭제하시겠습니까?")) {
        window.location.href = "boarddelete?no=" + boardNo;
    }
}
</script>

<!-- 로그인 안 한 사용자용 JS -->
<script>
    function checkLoginBeforeComment() {
        alert("댓글 작성은 로그인 후 이용 가능합니다.");
        location.href = "/login";
    }
</script>


</body>
</html>