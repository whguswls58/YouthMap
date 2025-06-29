<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>VIVAMAP</title>
</head>
<body>

    <h2>게시글 삭제 확인</h2>

    <table border="1" width="600" align="center">
        <tr>
            <th>글 번호</th>
            <td>${board.boardNo}</td>
        </tr>
        <tr>
            <th>작성자</th>
            <td>${board.memId}</td>
        </tr>
        <tr>
            <th>제목</th>
            <td>${board.boardSubject}</td>
        </tr>
        <tr>
            <th>내용</th>
            <td>${board.boardContent}</td>
        </tr>
    </table>

    <div style="text-align: center; margin-top: 20px;">
        <form action="/boarddelete" method="get" style="display:inline;">
            <input type="hidden" name="no" value="${board.boardNo}" />
            <button type="submit">삭제하기</button>
        </form>
        <a href="/boardlist">취소</a>
    </div>

</body>
</html>