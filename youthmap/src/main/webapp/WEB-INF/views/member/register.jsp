<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원가입</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <!-- 카카오 주소 API -->
  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>

  <h2>회원가입</h2>

  <!-- 오류 메시지 출력 -->
  <c:if test="${not empty error}">
    <div style="color: red;">
      <p>${error}</p>
    </div>
  </c:if>

  <form action="${pageContext.request.contextPath}/register" method="post">

    <!-- 아이디 + 중복확인 -->
    <label>아이디:</label><br>
    <input type="text" name="memId" id="memId" required>
    <button type="button" id="checkIdBtn">중복확인</button>
    <span id="idCheckResult" style="margin-left:8px;"></span>
    <br><br>

    <!-- 비밀번호 + 확인 -->
    <label>비밀번호:</label><br>
    <input type="password" name="memPass" id="memPass" required><br><br>
    <label>비밀번호 확인:</label><br>
    <input type="password" id="memPassConfirm" required>
    <span id="passCheckResult" style="margin-left:8px;"></span>
    <br><br>

    <!-- 이름 -->
    <label>이름:</label><br>
    <input type="text" name="memName" required><br><br>

    <!-- 생년월일 -->
    <label>생년월일:</label><br>
    <input type="date" name="birthDate"><br><br>

    <!-- 성별 -->
    <label>성별:</label><br>
    <input type="radio" name="memGen" value="M" id="male"> <label for="male">남성</label>
    <input type="radio" name="memGen" value="F" id="female"> <label for="female">여성</label>
    <br><br>

    <!-- 이메일 -->
    <label>이메일:</label><br>
    <input type="text" name="emailId" id="emailId" required> @
    <input type="text" name="emailDomain" id="emailDomain" value="naver.com" readonly required>
    <select id="emailSelect">
      <option value="naver.com">naver.com</option>
      <option value="gmail.com">gmail.com</option>
      <option value="daum.net">daum.net</option>
      <option value="custom">직접입력</option>
    </select>
    <br><br>

    <!-- 핸드폰번호 -->
    <label>핸드폰번호:</label><br>
    <select name="phonePrefix" id="phonePrefix" required>
      <option value="010">010</option>
      <option value="011">011</option>
      <option value="017">012</option>
      <option value="070">070</option>
    </select>
    - <input type="text" name="phoneMiddle" id="phoneMiddle" maxlength="4" placeholder="0000" required>
    - <input type="text" name="phoneLast" id="phoneLast" maxlength="4" placeholder="0000" required>
    <br><br>

    <!-- 주소 -->
    <label>주소:</label><br>
    <input type="text" id="memAddress" name="memAddress" readonly required>
    <button type="button" id="addrBtn">주소 검색</button>
    <br><br>

    <!-- 상세주소 -->
    <label>상세주소:</label><br>
    <input type="text" name="memAddDetail"><br><br>

    <button type="submit">회원가입</button>
  </form>

  <p><a href="${pageContext.request.contextPath}/login">이미 계정이 있으신가요? 로그인</a></p>

  <script>
    $(function(){

      // 1) 이메일 도메인 select 처리
      $("#emailSelect").change(function(){
        const v = $(this).val();
        if(v === "custom"){
          $("#emailDomain")
            .val("")
            .prop("readonly", false)
            .focus();
        } else {
          $("#emailDomain")
            .val(v)
            .prop("readonly", true);
        }
      });

      // 2) 카카오 주소검색
      $("#addrBtn").click(function(){
        new daum.Postcode({
          oncomplete: function(data) {
            $("#memAddress").val(data.address);
          }
        }).open();
      });

      // 3) 아이디 중복 확인
      $("#checkIdBtn").click(function(){
        const memId = $("#memId").val().trim();
        console.log("중복검사 클릭 - 입력된 아이디:", memId);
        
        if(!memId){
          $("#idCheckResult")
            .css("color","red")
            .text("아이디를 입력해주세요.");
          return;
        }
        
        const url = "${pageContext.request.contextPath}/check-id";
        console.log("요청 URL:", url);
        console.log("요청 파라미터:", { memId: memId });
        
        $.get(url, { memId: memId })
          .done(function(response){
            console.log("응답 타입:", typeof response);
            console.log("응답 값:", response);
            console.log("응답 문자열:", String(response));
            
            // 응답을 boolean으로 변환
            const isDuplicate = response === true;
            console.log("변환된 중복여부:", isDuplicate);
            
            if(isDuplicate){
              $("#idCheckResult")
                .css("color","red")
                .text("이미 사용 중인 아이디입니다.");
            } else {
              $("#idCheckResult")
                .css("color","green")
                .text("사용 가능한 아이디입니다.");
            }
          })
          .fail(function(xhr, status, error){
            console.error("중복검사 실패:", status, error);
            console.error("응답 상태:", xhr.status);
            console.error("응답 텍스트:", xhr.responseText);
            alert("중복 확인에 실패했습니다. 오류: " + error);
          });
      });

      // 4) 비밀번호 일치 여부 실시간 체크
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

      // 5) 핸드폰번호 입력 처리
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