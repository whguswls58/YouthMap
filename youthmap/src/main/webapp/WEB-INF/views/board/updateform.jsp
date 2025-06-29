<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>
<body>
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- Hero 배너 -->
<section class="hero-banner"></section>

<div class="content-container">
	<div class="write-outer">
		<div class="write-container">
    		<h2>게시글 수정</h2>

    	<form class="write-form" action="/boardupdate" method="post" enctype="multipart/form-data">
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
	                <div class="title-row">
	                    <select name="boardCategory" required>
	                        <option value="정책" ${board.boardCategory == '정책' ? 'selected' : ''}>정책</option>
	                        <option value="문화" ${board.boardCategory == '문화' ? 'selected' : ''}>문화</option>
	                        <option value="맛집" ${board.boardCategory == '맛집' ? 'selected' : ''}>맛집</option>
	                        <option value="공지" ${board.boardCategory == '공지' ? 'selected' : ''}>공지</option>
	                    </select>
	                </div>
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
                	<div class="title-input-wrap">
						<input type="text" name="boardSubject" maxlength="60"
							placeholder="제목을 입력하세요" oninput="updateByteCount(this)" value="${board.boardSubject}" required style="width: 95%;">
					</div>
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                	<div class="content-wrap">
                    	<textarea name="boardContent" rows="10" style="width: 95%;" required>${board.boardContent}</textarea>
                    </div>
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
			    <div class="btn-group" style="text-align: center; margin-top: 20px;">
			        <button class="submit-btn" type="submit">수정 완료</button>
			        <a class="cancel-btn" href="/boardlist">취소</a>
			    </div>
			</form>
		</div>
	</div>
</div>
<!-- ✅ 푸터 -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>