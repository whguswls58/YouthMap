<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>YouthMap</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="/css/JYcss/main.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  <style>
    /* Remove the navbar's default margin-bottom and rounded borders */ 
    .navbar {
      margin-bottom: 0;
      border-radius: 0;
    }
    
    /* Set height of the grid so .sidenav can be 100% (adjust as needed) */
    .row.content {height: 450px}
    
    .navbar-brand img {
  height: 40px;
  margin-top: -10px;
}
    
    /* Set gray background color and 100% height */
    .sidenav {
      padding-top: 20px;
      background-color: #f1f1f1;
      height: 100%;
    }
    
    /* Set black background color, white text and some padding */
    footer {
      background-color: #555;
      color: white;
      padding: 15px;
    }
    
    /* On small screens, set height to 'auto' for sidenav and grid */
    @media screen and (max-width: 767px) {
      .sidenav {
        height: auto;
        padding: 15px;
      }
      .row.content {height:auto;} 
    }
  </style>
</head>
<body>

<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <!-- 로고 + 모바일 토글 -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#mainNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="/"><img src="../img/JYimg/YouthMap_logo.png" alt="YouthMap" style="height:40px;"></a>
    </div>

    <!-- 메뉴 항목 -->
    <div class="collapse navbar-collapse" id="mainNavbar">
      <!-- 왼쪽 메뉴 -->
      <ul class="nav navbar-nav">
        <li><a href="/policy">정책</a></li>
        <li><a href="/culture">문화</a></li>
        <li><a href="/food">맛집</a></li>
        <li><a href="/board">유저 게시판</a></li>
      </ul>

      <!-- 오른쪽 로그인/로그아웃 -->
      <ul class="nav navbar-nav navbar-right">
        <c:choose>
          <c:when test="${not empty sessionScope.mem_id}">
            <li class="navbar-text">${sessionScope.mem_id}님 환영합니다</li>
            <li><a href="/mypage"><span class="glyphicon glyphicon-user"></span> 마이페이지</a></li>
            <li><a href="/logout"><span class="glyphicon glyphicon-log-out"></span> 로그아웃</a></li>
          </c:when>
          <c:otherwise>
            <li><a href="/login"><span class="glyphicon glyphicon-log-in"></span> 로그인</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<!-- ✅ 여기부터 mega-dropdown 삽입 -->
<div class="mega-dropdown" style="display: none;">
  <div class="container-fluid mega-dropdown-inner">
    <div class="dropdown-column">
      <h4>정책</h4>
      <a href="/policy/support">지원</a>
      <a href="/policy/housing">주거</a>
      <a href="/policy/benefit">혜택</a>
    </div>
    <div class="dropdown-column">
      <h4>문화</h4>
      <a href="/culture/theater">뮤지컬/연극</a>
      <a href="/culture/exhibit">전시회/미술관</a>
      <a href="/culture/festival">대회/축제</a>
    </div>
    <div class="dropdown-column">
      <h4>맛집</h4>
      <a href="/food/gangnam">강남구</a>
      <a href="/food/gangbuk">강북구</a>
      <a href="/food/gangseo">강서구</a>
      <a href="/food/gangdong">강동구</a>
    </div>
    <div class="dropdown-column">
      <h4>유저 게시판</h4>
      <a href="/board">유저 게시판</a>
    </div>
  </div>
</div>
  
<div class="container-fluid text-center">    
  <div class="row content">
    <div class="col-sm-2 sidenav">
      <p><a href="#">Link</a></p>
      <p><a href="#">Link</a></p>
      <p><a href="#">Link</a></p>
    </div>
    <div class="col-sm-8 text-left"> 
      <h1>Welcome</h1>
      <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
      <hr>
      <h3>Test</h3>
      <p>Lorem ipsum...</p>
    </div>
    <div class="col-sm-2 sidenav">
      <div class="well">
        <p>ADS</p>
      </div>
      <div class="well">
        <p>ADS</p>
      </div>
    </div>
  </div>
</div>

<footer class="container-fluid text-center">
  <p>Footer Text</p>
</footer>

<script src="/js/JYjs/main.js"></script>


</body>
</html>