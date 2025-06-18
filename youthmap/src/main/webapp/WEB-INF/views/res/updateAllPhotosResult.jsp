<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>여분 사진 일괄 업데이트 결과</title>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background: #f9f9fa; margin:0; padding:40px;}
        .update-result-box {
            max-width: 400px; margin: 70px auto; background: #fff; border-radius: 15px;
            box-shadow: 0 3px 12px #d4d4d4; text-align: center; padding: 44px 28px;
        }
        .update-result-box h2 { margin-bottom: 26px; font-size: 2em; color: #26a69a;}
        .count-num { color: #333; font-size: 2.6em; font-weight: 700; margin-bottom: 18px; }
        .desc { color: #888; margin-top:18px;}
        .home-link { margin-top:24px; display: inline-block; font-size: 1.1em; text-decoration: none; color: #3896e3;}
        .home-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="update-result-box">
        <h2>여분 사진 일괄 업데이트 결과</h2>
        <div class="count-num">${updateCount}</div>
        <div>개의 맛집에<br>여분 사진이 저장/갱신되었습니다.</div>
        <div class="desc">※ 이미 저장된 곳 중 여분 사진이 없는 경우는 제외됩니다.</div>
        <a href="main" class="home-link">메인으로 돌아가기</a>
    </div>
</body>
</html>
