<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Bootstrap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

  <style>
    /* Remove the navbar's default margin-bottom and rounded borders */ 
    .navbar {
      margin-bottom: 0;
      border-radius: 0;
    }
    
    /* Set height of the grid so .sidenav can be 100% (adjust as needed) */
    .row.content {height: 450px}
    
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
    
    /* 우측 네비게이션 고정 스타일 */
    .sidebar-fixed {
      position: fixed;
      top: 80px;
      right: 30px;
      width: 200px;
    }
    
    
  </style>
</head>
<body>

<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="#">Logo</a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav">
        <li class="active"><a href="#">Home</a></li>
        <li><a href="#">About</a></li>
        <li><a href="#">Projects</a></li>
        <li><a href="#">Contact</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
      </ul>
    </div>
  </div>
</nav>
  
<div class="container-fluid text-center">    
  <div class="row content">
    <div class="col-sm-2 sidenav">
      <p><a href="#">Link</a></p>
      <p><a href="#">Link</a></p>
      <p><a href="#">Link</a></p>
    </div>
    <div class="col-sm-8 text-left"> 
      <input type=button value="목록" onclick="location.href='policyMain'">
 		<div class="title">한 눈에 보는 정책 요약</div>

	    <table class="policy-summary">
	        <tr>
	            <th>정책번호</th>
	            <td>${plcy.plcy_no}</td>
	        </tr>
	        <tr>
	            <th>정책분야</th>
	            <td>${plcy.plcy_kywd_nm}</td>
	        </tr>
	        <tr>
	            <th>지원내용</th>
	            <td>${plcy.plcy_sprt_cn}</td>
	        </tr>
	        <tr>
	            <th>사업 운영 기간</th>
	            <td>${plcy.biz_prd_bgng_ymd} ~ ${plcy.biz_prd_end_ymd}</td>
	        </tr>
	        <tr>
	            <th>사업 신청기간</th>
	            <td>${plcy.aply_ymd_strt} ~ ${plcy.aply_ymd_end}</td>
	        </tr>
	        <tr>
	            <th>지원 규모(명)</th>
	            <td>${plcy.sprt_scl_cnt}</td>
	        </tr>
	    </table>
	    
	    <div class="title">한 눈에 보는 정책 요약</div>

	    <table class="policy-summary">
	        <tr>
	            <th>정책번호</th>
	            <td>${plcy.plcy_no}</td>
	        </tr>
	        <tr>
	            <th>정책분야</th>
	            <td>${plcy.plcy_kywd_nm}</td>
	        </tr>
	        <tr>
	            <th>지원내용</th>
	            <td>${plcy.plcy_sprt_cn}</td>
	        </tr>
	        <tr>
	            <th>사업 운영 기간</th>
	            <td>${plcy.biz_prd_bgng_ymd} ~ ${plcy.biz_prd_end_ymd}</td>
	        </tr>
	        <tr>
	            <th>사업 신청기간</th>
	            <td>${plcy.aply_ymd_strt} ~ ${plcy.aply_ymd_end}</td>
	        </tr>
	        <tr>
	            <th>지원 규모(명)</th>
	            <td>${plcy.sprt_scl_cnt}</td>
	        </tr>
	    </table>
	    
	    <div class="title">한 눈에 보는 정책 요약</div>

	    <table class="policy-summary">
	        <tr>
	            <th>정책번호</th>
	            <td>${plcy.plcy_no}</td>
	        </tr>
	        <tr>
	            <th>정책분야</th>
	            <td>${plcy.plcy_kywd_nm}</td>
	        </tr>
	        <tr>
	            <th>지원내용</th>
	            <td>${plcy.plcy_sprt_cn}</td>
	        </tr>
	        <tr>
	            <th>사업 운영 기간</th>
	            <td>${plcy.biz_prd_bgng_ymd} ~ ${plcy.biz_prd_end_ymd}</td>
	        </tr>
	        <tr>
	            <th>사업 신청기간</th>
	            <td>${plcy.aply_ymd_strt} ~ ${plcy.aply_ymd_end}</td>
	        </tr>
	        <tr>
	            <th>지원 규모(명)</th>
	            <td>${plcy.sprt_scl_cnt}</td>
	        </tr>
	    </table>
	    
	    <div class="title">한 눈에 보는 정책 요약</div>

	    <table class="policy-summary">
	        <tr>
	            <th>정책번호</th>
	            <td>${plcy.plcy_no}</td>
	        </tr>
	        <tr>
	            <th>정책분야</th>
	            <td>${plcy.plcy_kywd_nm}</td>
	        </tr>
	        <tr>
	            <th>지원내용</th>
	            <td>${plcy.plcy_sprt_cn}</td>
	        </tr>
	        <tr>
	            <th>사업 운영 기간</th>
	            <td>${plcy.biz_prd_bgng_ymd} ~ ${plcy.biz_prd_end_ymd}</td>
	        </tr>
	        <tr>
	            <th>사업 신청기간</th>
	            <td>${plcy.aply_ymd_strt} ~ ${plcy.aply_ymd_end}</td>
	        </tr>
	        <tr>
	            <th>지원 규모(명)</th>
	            <td>${plcy.sprt_scl_cnt}</td>
	        </tr>
	    </table>
	    
	    <div class="title">한 눈에 보는 정책 요약</div>

	    <table class="policy-summary">
	        <tr>
	            <th>정책번호</th>
	            <td>${plcy.plcy_no}</td>
	        </tr>
	        <tr>
	            <th>정책분야</th>
	            <td>${plcy.plcy_kywd_nm}</td>
	        </tr>
	        <tr>
	            <th>지원내용</th>
	            <td>${plcy.plcy_sprt_cn}</td>
	        </tr>
	        <tr>
	            <th>사업 운영 기간</th>
	            <td>${plcy.biz_prd_bgng_ymd} ~ ${plcy.biz_prd_end_ymd}</td>
	        </tr>
	        <tr>
	            <th>사업 신청기간</th>
	            <td>${plcy.aply_ymd_strt} ~ ${plcy.aply_ymd_end}</td>
	        </tr>
	        <tr>
	            <th>지원 규모(명)</th>
	            <td>${plcy.sprt_scl_cnt}</td>
	        </tr>
	    </table>
	    
    </div>
    <div class="col-md-2 sidenav">
      <div class="sidebar-fixed panel panel-default">
        <div class="panel-heading">정책 메뉴</div>
        <div class="panel-body">
          <ul class="nav nav-pills nav-stacked">
            <li><a href="#summary">정책 요약</a></li>
            <li><a href="#qualification">신청자격</a></li>
            <li><a href="#method">신청방법</a></li>
            <li><a href="#etc">기타</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>

<footer class="container-fluid text-center">
  <p>Footer Text</p>
</footer>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

</body>
</html>
