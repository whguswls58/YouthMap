<!-- register.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원가입</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/login.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
</head>
<body>
<!-- 헤더-->
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="login-wrapper">
  <div class="login-box">
    <h2 class="register-title">회원가입</h2>

    <c:if test="${not empty error}">
      <div class="login-error">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post" class="register-form">

      <div class="form-group">
        <label for="memId">아이디</label>
        <div class="input-with-button">
          <input type="text" name="memId" id="memId" required>
          <button type="button" id="checkIdBtn">중복확인</button>
        </div>
        <span id="idCheckResult"></span>
      </div>

      <div class="form-group">
        <label for="memPass">비밀번호</label>
        <input type="password" name="memPass" id="memPass" required>
      </div>

      <div class="form-group">
        <label for="memPassConfirm">비밀번호 확인</label>
        <input type="password" id="memPassConfirm" required>
        <span id="passCheckResult"></span>
      </div>

      <div class="form-group">
        <label for="memName">이름</label>
        <input type="text" name="memName" required>
      </div>

      <div class="form-group">
        <label for="birthDate">생년월일</label>
        <input type="date" name="birthDate">
      </div>

      <div class="form-group">
        <label>성별</label>
        <div class="radio-group">
          <label><input type="radio" name="memGen" value="M"> 남성</label>
          <label><input type="radio" name="memGen" value="F"> 여성</label>
        </div>
      </div>

      <div class="form-group">
        <label>이메일</label>
        <div class="email-group">
          <input type="text" name="emailId" id="emailId" required>
          <span>@</span>
          <input type="text" name="emailDomain" id="emailDomain" value="naver.com" readonly required>
          <select id="emailSelect">
            <option value="naver.com">naver.com</option>
            <option value="gmail.com">gmail.com</option>
            <option value="daum.net">daum.net</option>
            <option value="custom">직접입력</option>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label>핸드폰번호</label>
        <div class="phone-group">
          <select name="phonePrefix" id="phonePrefix" required>
            <option value="010">010</option>
            <option value="011">011</option>
            <option value="017">012</option>
            <option value="070">070</option>
          </select>
          <input type="text" name="phoneMiddle" id="phoneMiddle" maxlength="4" placeholder="0000" required>
          <input type="text" name="phoneLast" id="phoneLast" maxlength="4" placeholder="0000" required>
        </div>
      </div>

      <div class="form-group">
        <label>주소</label>
        <div class="input-with-button">
          <input type="text" id="memAddress" name="memAddress" readonly required>
          <button type="button" id="addrBtn">주소 검색</button>
        </div>
      </div>

      <div class="form-group">
        <label>상세주소</label>
        <input type="text" name="memAddDetail">
      </div>

      <button type="submit" class="login-button">회원가입</button>
    </form>

    <div class="login-register">
      <a href="${pageContext.request.contextPath}/login">이미 계정이 있으신가요? 로그인</a>
    </div>
  </div>
</div>

<script>
  $(function(){
    $("#emailSelect").change(function(){
      const v = $(this).val();
      if(v === "custom"){
        $("#emailDomain").val("").prop("readonly", false).focus();
      } else {
        $("#emailDomain").val(v).prop("readonly", true);
      }
    });

    $("#addrBtn").click(function(){
      new daum.Postcode({
        oncomplete: function(data) {
          $("#memAddress").val(data.address);
        }
      }).open();
    });

    $("#checkIdBtn").click(function(){
      const memId = $("#memId").val().trim();
      if(!memId){
        $("#idCheckResult").css("color","red").text("아이디를 입력해주세요.");
        return;
      }
      const url = "${pageContext.request.contextPath}/check-id";
      $.get(url, { memId: memId })
        .done(function(response){
          const isDuplicate = response === true;
          if(isDuplicate){
            $("#idCheckResult").css("color","red").text("이미 사용 중인 아이디입니다.");
          } else {
            $("#idCheckResult").css("color","green").text("사용 가능한 아이디입니다.");
          }
        })
        .fail(function(xhr, status, error){
          alert("중복 확인에 실패했습니다. 오류: " + error);
        });
    });

    $("#memPass, #memPassConfirm").on("keyup", function(){
      const pass = $("#memPass").val();
      const confirm = $("#memPassConfirm").val();
      const $r = $("#passCheckResult");
      if(!confirm){
        $r.text("");
      } else if(pass === confirm){
        $r.css("color","green").text("비밀번호가 일치합니다.");
      } else {
        $r.css("color","red").text("비밀번호가 일치하지 않습니다.");
      }
    });

    $("#phoneMiddle, #phoneLast").on("input", function(){
      $(this).val($(this).val().replace(/[^0-9]/g, ''));
    });

    $("#phoneMiddle").on("input", function(){
      if($(this).val().length === 4){
        $("#phoneLast").focus();
      }
    });

    $("#phoneLast").on("input", function(){
      if($(this).val().length === 4){
        $(this).blur();
      }
    });
  });
</script>
<!-- 푸터 -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>

