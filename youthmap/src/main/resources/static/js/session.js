 // 세션 타이머 기능
  document.addEventListener('DOMContentLoaded', function() {
    var timerElement = document.getElementById('login-timer');
    var sessionStartTimeInput = document.getElementById('session-start-time');
    
    console.log('타이머 요소:', timerElement);
    console.log('세션 시작 시간 요소:', sessionStartTimeInput);
    
    if (timerElement && sessionStartTimeInput) {
      var sessionStartTime = parseInt(sessionStartTimeInput.value);
      console.log('세션 시작 시간:', sessionStartTime);
      
      var sessionTimeout = 30 * 60 * 1000; // 30분 (밀리초)
      
      function updateTimer() {
        var now = Date.now();
        var elapsed = now - sessionStartTime;
        var remaining = sessionTimeout - elapsed;
        
        console.log('현재 시간:', now, '경과 시간:', elapsed, '남은 시간:', remaining);
        
        if (remaining <= 0) {
          clearInterval(timerInterval);
          alert("로그인 시간이 만료되었습니다. 자동 로그아웃됩니다.");
          location.href = "/logout";
          return;
        }
        
        var minutes = Math.floor(remaining / 60000);
        var seconds = Math.floor((remaining % 60000) / 1000);
        
        var timerText = "남은 시간: " + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
        timerElement.textContent = timerText;
        console.log('타이머 텍스트:', timerText);
      }
      
      // 1초마다 갱신
      var timerInterval = setInterval(updateTimer, 1000);
      updateTimer(); // 즉시 실행
      
      // 페이지 이동 시 타이머 정리
      window.addEventListener('beforeunload', function() {
        clearInterval(timerInterval);
      });
    } else {
      console.log('타이머 요소나 세션 시작 시간을 찾을 수 없습니다.');
    }
  });
