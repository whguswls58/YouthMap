<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ include file="/WEB-INF/views/culture/searchBar.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문화생활 메인</title>
</head>
<body>

<div style="text-align:center; margin:20px 0;">
    <button onclick="location.href='allList'" style="width:100px; height:26px; font-size:16px; margin:0 8px;">
      전체 목록
    </button>
<div align="center" style="margin:20px 0;">
<hr>



<!-- 전시/미술 섹션 -->
<div style="text-align:center; margin:20px 0;">
  <!-- ① 전체 폭 850px짜리 inline-block 컨테이너 -->
  <div style="display:inline-block; text-align:left; width:850px;">

    <!-- ② 제목＋버튼 flex 라인 -->
    <div style="
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
      ">
      <!-- 제목 -->
      <p style="margin:0; font-weight:bold; font-size:1.1em;">전시/미술</p>
      <!-- 버튼 -->
      <button
        type="button"
        onclick="location.href='exhibitionlist'"
        style="
          width:100px;
          height:26px;
          line-height:26px;    /* 버튼 높이와 텍스트 수직 중앙 정렬 */
          text-align:center;
          font-size:18px;
          cursor:pointer;
        ">
        더보기
      </button>
    </div>
    
    <!-- ③ 테이블(가로 5개 분할) -->
    <table border="1" align="center" cellpadding="8" cellspacing="0" style="table-layout:fixed;">
      <tr valign="top" style="height:250px;">
        <c:forEach var="cul" items="${exhibition}">
          <td align="center" width="170" style="padding:8px;">
            <img src="${cul.con_img}" width="170" height="170" /><br>
            <div style="height:40px; overflow:hidden; text-align:center; line-height:20px;">
              ${cul.con_title}
            </div>
            <!-- 3) 날짜 (제목 바로 아래) -->
    		<div style=" text-align:center; font-size:0.85em; color:#555; margin-top:4px;">
    		  ${cul.con_start_date} ~ ${cul.con_end_date}
    		</div>
          </td>
        </c:forEach>
      </tr>
    </table>

  </div>
</div>
<!-- performance 섹션 -->
<div style="text-align:center; margin:20px 0;">
  <!-- ① 전체 폭 850px짜리 inline-block 컨테이너 -->
  <div style="display:inline-block; text-align:left; width:850px;">

    <!-- ② 제목＋버튼 flex 라인 -->
    <div style="
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
      ">
      <!-- 제목 -->
      <p style="margin:0; font-weight:bold; font-size:1.1em;">공연</p>
      <!-- 버튼 -->
      <button
        type="button"
        onclick="location.href='performancelist'"
        style="
          width:100px;
          height:26px;
          line-height:26px;    /* 버튼 높이와 텍스트 수직 중앙 정렬 */
          text-align:center;
          font-size:18px;
          cursor:pointer;
        ">
        더보기
      </button>
    </div>

    <!-- ③ 테이블(가로 5개 분할) -->
    <table border="1" align="center" cellpadding="8" cellspacing="0" style="table-layout:fixed;">
      <tr valign="top" style="height:250px;">
        <c:forEach var="cul" items="${performance}">
          <td align="center" width="170" style="padding:8px;">
            <img src="${cul.con_img}" width="170" height="170" /><br>
            <div style="height:40px; overflow:hidden; text-align:center; line-height:20px;">
              ${cul.con_title}
            </div>
            <!-- 3) 날짜 (제목 바로 아래) -->
    		<div style=" text-align:center; font-size:0.85em; color:#555; margin-top:4px;">
    		  ${cul.con_start_date} ~ ${cul.con_end_date}
    		</div>
          </td>
        </c:forEach>
      </tr>
    </table>

  </div>
</div>

<!-- event 섹션 -->
<div style="text-align:center; margin:20px 0;">
  <!-- ① 전체 폭 850px짜리 inline-block 컨테이너 -->
  <div style="display:inline-block; text-align:left; width:850px;">

    <!-- ② 제목＋버튼 flex 라인 -->
    <div style="
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
      ">
      <!-- 제목 -->
      <p style="margin:0; font-weight:bold; font-size:1.1em;">축제/행사</p>
      <!-- 버튼 -->
      <button
        type="button"
        onclick="location.href='eventlist'"
        style="
          width:100px;
          height:26px;
          line-height:26px;    /* 버튼 높이와 텍스트 수직 중앙 정렬 */
          text-align:center;
          font-size:18px;
          cursor:pointer;
        ">
        더보기
      </button>
    </div>

    <!-- ③ 테이블(가로 5개 분할) -->
    <table border="1" align="center" cellpadding="8" cellspacing="0" style="table-layout:fixed;">
      <tr valign="top" style="height:250px;">
        <c:forEach var="cul" items="${event}">
          <td align="center" width="170" style="padding:8px;">
            <img src="${cul.con_img}" width="170" height="170" /><br>
            <div style="height:40px; overflow:hidden; text-align:center; line-height:20px;">
              ${cul.con_title}<br>
            </div>
             <!-- 3) 날짜 (제목 바로 아래) -->
    		<div style=" text-align:center; font-size:0.85em; color:#555; margin-top:4px;">
    		  ${cul.con_start_date} ~ ${cul.con_end_date}
    		</div>
          </td>
        </c:forEach>
      </tr>
    </table>
  </div>
</div>




</body>
</html>