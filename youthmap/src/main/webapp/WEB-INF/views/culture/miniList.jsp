<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 팝업창에 뜨는 내용 -->
<div style="padding:4px 8px;">
  <c:forEach var="item" items="${miniList}" varStatus="status">
    <c:set var="detailUrl" value="" />
    <c:choose>
      <c:when test="${item.category_name == '전시/미술'}">
        <c:set var="detailUrl" value="${pageContext.request.contextPath}/exhibitioncont?con_id=${item.con_id}" />
      </c:when>
      <c:when test="${item.category_name == '콘서트'
                 or item.category_name == '연극'
                 or item.category_name == '뮤지컬/오페라'
                 or item.category_name == '국악'
                 or item.category_name == '독주회'
                 or item.category_name == '클래식'
                 or item.category_name == '무용'}">
        <c:set var="detailUrl" value="${pageContext.request.contextPath}/performancecont?con_id=${item.con_id}" />
      </c:when>
      <c:otherwise>
        <c:set var="detailUrl" value="${pageContext.request.contextPath}/eventcont?con_id=${item.con_id}" />
      </c:otherwise>
    </c:choose>
    
    <div style="display:flex; align-items:center; gap:24px; border-bottom:1px solid #eee; padding:10px 0;">
  <!-- 번호 -->
  <span style="display:inline-block; width:24px; color:#b0b0b0; font-weight:bold; text-align:center;">
    ${status.index + 1}
  </span>
  <!-- 이미지+카테고리명 묶음 (세로 정렬) -->
  <div style="display:flex; flex-direction:column; align-items:center; min-width:60px;">
    <!-- 카테고리명 -->
    <span style="
      display:block;
      color:#666;
      font-size:11px;
      padding-bottom:4px;
      font-weight:500;
      width:70px;
      text-align:center;
      ">
      ${item.category_name}
    </span>
    <!-- 이미지 -->
    <a href="${detailUrl}" style="display:inline-block;">
      <img src="${item.con_img}" width="60" style="border-radius:6px; display:block;" />
    </a>
  </div>
  <div>
    <div style="font-weight:bold;">
      <a href="${detailUrl}" style="color:inherit; text-decoration:none;">
        ${item.con_title}
      </a>
    </div>
        <div style="color:#666; font-size:0.95em;">
          ${item.con_start_date} ~ ${item.con_end_date}<br/>
          <span>${item.con_location}</span>
        </div>
      </div>
    </div>
  </c:forEach>
  <c:if test="${empty miniList}">
    <div style="color:#888;">결과가 없습니다.</div>
  </c:if>
</div>
