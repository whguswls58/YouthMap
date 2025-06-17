<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원정보 수정</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

  <h2>회원정보 수정</h2>
  <form action="${pageContext.request.contextPath}/edit" method="post">
    <div>
      <label>아이디:</label>
      <input type="text" value="${member.memId}" readonly />
    </div>

    <div>
      <label>이름:</label>
      <input type="text" value="${member.memName}" readonly />
    </div>

    <div>
      <label>기존 비밀번호:</label>
      <input type="password" name="currentPass" required />
    </div>

    <div>
      <label>변경할 비밀번호:</label>
      <input type="password" name="newPass" />
    </div>

    <div>
      <label>이메일:</label>
      <input type="email" name="memMail" value="${member.memMail}" required />
    </div>

    <div>
      <label>핸드폰번호:</label>
      <select name="phonePrefix" id="phonePrefix" required>
        <option value="010" ${member.memNum != null && member.memNum.startsWith('010') ? 'selected' : ''}>010</option>
        <option value="011" ${member.memNum != null && member.memNum.startsWith('011') ? 'selected' : ''}>011</option>
        <option value="017" ${member.memNum != null && member.memNum.startsWith('017') ? 'selected' : ''}>017</option>
        <option value="070" ${member.memNum != null && member.memNum.startsWith('070') ? 'selected' : ''}>070</option>
      </select>
      - <input type="text" name="phoneMiddle" id="phoneMiddle" maxlength="4" placeholder="0000" value="${member.memNum != null ? member.memNum.split('-')[1] : ''}" required>
      - <input type="text" name="phoneLast" id="phoneLast" maxlength="4" placeholder="0000" value="${member.memNum != null ? member.memNum.split('-')[2] : ''}" required>
    </div>

    <div>
      <label>주소:</label>
      <input type="text" name="memAddress" value="${member.memAddress}" required />
    </div>

    <div>
      <label>상세주소:</label>
      <input type="text" name="memAddDetail" value="${member.memAddDetail}" required />
    </div>

    <div>
      <button type="submit">수정하기</button>
    </div>
  </form>
  
  <c:if test="${not empty error}">
    <script>
      alert('${error}');
    </script>
  </c:if>

  <script>
    $(function(){
      // 핸드폰번호 입력 처리
      // 숫자만 입력 가능
      $("#phoneMiddle, #phoneLast").on("input", function(){
        $(this).val($(this).val().replace(/[^0-9]/g, ''));
      });

      // 중간번호 4자리 입력 시 마지막 번호로 자동 이동
      $("#phoneMiddle").on("input", function(){
        const value = $(this).val();
        if(value.length === 4){
          $("#phoneLast").focus();
        }
      });

      // 마지막 번호 4자리 입력 시 포커스 해제
      $("#phoneLast").on("input", function(){
        const value = $(this).val();
        if(value.length === 4){
          $(this).blur();
        }
      });
    });
  </script>
  
</body>
</html> 