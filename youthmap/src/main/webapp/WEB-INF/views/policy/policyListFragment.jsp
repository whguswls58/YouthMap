<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 정책 리스트 출력 영역 -->
<div style="display:flex; gap:20px; flex-wrap:wrap;">
  <c:forEach var="policy" items="${pm}">
    <div style="border:1px solid #ccc; border-radius:8px; padding:15px; width:300px;">
      <div><strong>${policy.plcy_nm}</strong></div>
      <div>${policy.plcy_expln_cn}</div>
      <div>신청기간: ${aply_ymd_strt} ~ ${policy.aply_ymd_end}</div>
      <button onclick="location.href='detail.jsp?plcyNo=${policy.plcy_no}'">자세히보기</button>
    </div>
  </c:forEach>
</div>
