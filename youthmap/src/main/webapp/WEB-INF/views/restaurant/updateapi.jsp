<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
    <title>API 동기화 결과</title>
    <style>
        body { background:#f7fafc; font-family:'Pretendard',sans-serif;}
        .box { margin: 80px auto; max-width: 420px; background: #fff; border-radius: 18px; box-shadow:0 2px 14px #ddd; padding:38px; text-align:center;}
        h2 { color:#1784fc; margin-bottom:16px;}
        .num { font-size:2.4em; font-weight:bold; color:#333;}
        .insert { color:#44b77b;}
        .update { color:#ee8b28;}
        .btn { margin-top:30px; background:#1784fc; color:#fff; border:none; padding:14px 42px; border-radius:8px; font-size:18px; font-weight:bold; cursor:pointer; transition:0.2s;}
        .btn:hover { background:#005ecb;}
    </style>
</head>
<body>
<div class="box">
    <h2>동기화 결과</h2>
    <div>
        <span class="insert">신규 추가: <span class="num">${insertCnt}</span></span><br>
        <span class="update">기존 업데이트: <span class="num">${updateCnt}</span></span>
    </div>
    <form action="updateapi" method="get">
        <button class="btn" type="submit">API로 새로고침</button>
    </form>
    <div style="margin-top:18px;">
        <a href="res_main" style="color:#1784fc;">메인으로</a>
    </div>
</div>
</body>
</html>
