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

    <!-- 댓글 섹션 -->
    <input type="hidden" id="boardNo" value="${board.boardNo}" />
    <h3>댓글</h3>
    <div id="commentBox">
        <div id="commentList"></div>
        <form id="commentForm">
            <c:choose>
                <c:when test="${not empty sessionScope.loginMember}">
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

    <!-- 액션 버튼 -->
    <div style="text-align: center; margin-top: 20px;">
        <a href="/boardlist?page=${page}">목록으로</a>
        <c:if test="${sessionScope.loginMember.memId == board.memId 
                   or sessionScope.loginMember.memType == 'ADMIN'}">
            <!-- 수정 -->
            <a href="/boardupdateform?no=${board.boardNo}">수정</a>
            <!-- 삭제 -->
            <a href="javascript:void(0);"
               onclick="if(confirm('정말 삭제하시겠습니까?'))
                          location.href='/boarddelete?boardNo=${board.boardNo}';">
                삭제
            </a>
        </c:if>
    </div>

    <!-- 디버그 로그 -->
    <script>
        console.log("boardNo =", '${board.boardNo}');
        console.log("board object =", '${board}');
        console.log("board.boardNo type =", typeof '${board.boardNo}');
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
