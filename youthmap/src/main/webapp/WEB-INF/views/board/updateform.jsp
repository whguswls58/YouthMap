<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
</head>
<body>

    <h2>게시글 수정</h2>

    <form action="/boardupdate" method="post" enctype="multipart/form-data">
        <table border="1" width="600" align="center">
            <tr>
                <th>번호</th>
                <td>
                    ${board.boardNo}
                    <input type="hidden" name="boardNo" value="${board.boardNo}" />
                </td>
            </tr>
            <tr>
                <th>카테고리</th>
                <td>
                    <select name="boardCategory" required>
                        <option value="정책" ${board.boardCategory == '정책' ? 'selected' : ''}>정책</option>
                        <option value="문화" ${board.boardCategory == '문화' ? 'selected' : ''}>문화</option>
                        <option value="맛집" ${board.boardCategory == '맛집' ? 'selected' : ''}>맛집</option>
                        <option value="공지" ${board.boardCategory == '공지' ? 'selected' : ''}>공지</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>작성자</th>
                <td>
                    ${board.memId}
                    <input type="hidden" name="memId" value="${board.memId}" />
                </td>
            </tr>
            <tr>
                <th>제목</th>
                <td>
                    <input type="text" name="boardSubject" value="${board.boardSubject}" required style="width: 95%;" />
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                    <textarea name="boardContent" rows="10" style="width: 95%;" required>${board.boardContent}</textarea>
                </td>
            </tr>
            
            <!-- 기존 첨부파일 표시 (삭제 가능) -->
<c:if test="${not empty fileList}">
    <tr>
        <th>기존 첨부파일</th>
        <td>
            <c:forEach var="file" items="${fileList}">
                <span>${file.userFileName}</span>
                <input type="checkbox" name="deleteFile" value="${file.userFilPath}"> 삭제<br/>
            </c:forEach>
        </td>
    </tr>
</c:if>

<!-- 새 첨부파일 업로드 -->
<tr>
    <th>새 첨부파일</th>
    <td><input type="file" name="uploadFile" /></td>
</tr>
        </table>

        <div style="text-align: center; margin-top: 20px;">
            <button type="submit">수정 완료</button>
            <a href="/boardlist">취소</a>
        </div>
    </form>

</body>
</html>