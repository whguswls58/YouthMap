<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 작성</title>
</head>
<body>

    <h2>게시글 작성</h2>

    <!-- 폼 제출 시 /boardwrite 로 POST 전송 -->
    <form action="/boardwrite" method="post" enctype="multipart/form-data">
        <table border="1" width="600" align="center">
            <tr>
                <th>카테고리</th>
                <td>
                    <select name="boardCategory" required>
                        <option value="">선택</option>
                        <c:if test="${sessionScope.loginRole eq 'ADMIN'}">
                		<option value="공지사항">공지사항</option>
            			</c:if>
                        <option value="정책">정책</option>
                        <option value="문화">문화</option>
                        <option value="맛집">맛집</option>
                        <option value="유저게시판">유저게시판</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>작성자</th>
                <td>
                    <input type="text" name="memId" value="${sessionScope.loginId}" readonly />
                </td>
            </tr>
            <tr>
                <th>제목</th>
                <td>
                    <input type="text" name="boardSubject" required style="width: 95%;" />
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                    <textarea name="boardContent" rows="10" style="width: 95%;" required></textarea>
                </td>
            </tr>
            <!-- memNo가 필요하면 hidden으로 전달 -->
            <c:if test="${not empty sessionScope.loginMemNo}">
                <input type="hidden" name="memNo" value="${sessionScope.loginMemNo}" />
            </c:if>
            <!-- ✅ 첨부파일 입력 추가 -->
        <tr>
            <th>첨부파일</th>
            <td><input type="file" name="uploadFile" /></td>
        </tr>
        </table>

        <div style="text-align: center; margin-top: 20px;">
            <button type="submit">작성 완료</button>
            <a href="/boardlist">취소</a>
        </div>
    </form>

</body>
</html>