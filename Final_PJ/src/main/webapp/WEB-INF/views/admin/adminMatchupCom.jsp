<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../inc/cssJsImports.jsp" %>
<%-- <%@ include file="../inc/admin_top.jsp"%> --%> 
<style type="text/css">

.divheader>h1 {
    font-size: xx-large;
    margin-bottom: 30px;
    color: gray;
}

table.table.table-bordered.table_jy {
    font: status-bar;
    text-align: center;
    font-size: smaller;
    background: white;
}

thead {
    font-size: initial;
    color: #454545;
}
.divPage_jy {
    text-align: center;
}
.divSearch {
    TEXT-ALIGN: RIGHT;
    MARGIN-BOTTOM: 10PX;
}
input.inputKeyword {
    height: 33px;
}
table.table.table-bordered.table_jy {
    font: status-bar;
}
th.th_jy {
    font: status-bar;
    font-weight: 700;
}
</style>

<script type="text/javascript">
$(function(){
	$('tbody tr').hover(function(){
		$(this).css('background','#99daef54');
	}, function(){
		$(this).css('background','');		
	});
});

function pageFunc(curPage){
	$('input[name=currentPage]').val(curPage);
	 $('form[name=frmPage]').submit();
} 
</script>

<form action="<c:url value='/admin/adminMatchupCom.do'/>" name="frmPage" method="post">
	<input type="hidden" name="currentPage">
	<%-- <input type="hidden" name="searchCondition" value="${param.searchCondition}"> --%>
	<input type="hidden" name="searchKeyword" value="${param.searchKeyword }">
</form>

<section class="resumeListSection">
	<div class="wrap">
		<!-- <div class="divheader">
			<h1>매치업 기업회원 조회 관리</h1>
		</div> -->
		<div class="divSearch">
			<form name="frmSearch" method="post" action='<c:url value="/admin/adminMatchupCom.do"/>'>
				<input type="text" class="inputKeyword" name="searchKeyword" title="검색어 입력" value="${param.searchKeyword}">   
				<input type="submit" class="btSearch" value="검색">
			
			</form>			
		</div>
		<div class="tableWrapper">
			<table class="table table-bordered table_jy"> 
				<%-- <caption>매치업 기업 회원 관리</caption> --%>
				 	<thead>
						<tr class="tr_jy"> 
							<th class="th_jy">No.</th>
							<th class="th_jy">회사명</th>
							<th class="th_jy">상품</th>
							<th class="th_jy">조회수</th>
							<th class="th_jy">최대조회수</th>
							<th class="th_jy">구매일</th>
							<th class="th_jy">만료일</th>
							<th class="th_jy">잔여일수</th>
						</tr>
				 	</thead>
				<tbody>
					<c:if test="${empty mcucomList }">
						<tr class="align_center"> 
							<td colspan="8">매치업 등록 기업회원이 없습니다.</td>
						</tr>
					</c:if>
					<c:if test="${!empty mcucomList }">
						<c:forEach var="map" items="${mcucomList }">
							<tr class="tr_jy">
								<td class="td_jy">${map['MCUCOM_NO']} </td>
								<td class="td_jy">${map['COM_NAME']} </td>
								<td class="td_jy">${map['PD_NAME']} </td>
								<td class="td_jy">${map['RESUME_READ_COUNT']} </td>
								<td class="td_jy">${map['MAX_RESUME_COUNT']} </td>
								<td class="td_jy"><fmt:formatDate value="${map['MCUPD_BUYDATE']}" pattern="yyyy.MM.dd"/>  </td>
								<td class="td_jy"><fmt:formatDate value="${map['MCUPD_EXDATE']}" pattern="yyyy.MM.dd"/>  </td>
								<td class="td_jy">${map['DAYS']} </td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		</div>
		<!-- 페이지 번호 추가 --> 
		<div class="divPage_jy">
			<c:if test="${pagingInfo.firstPage>1 }">
				<a href="#" onclick="pageFunc(${pagingInfo.firstPage-1})">         
        	  	<img src='<c:url value="/resources/images/first.JPG" />'  border="0">   </a>
   			</c:if>
   			<!-- [1][2][3][4][5][6][7][8][9][10] -->
		   <c:forEach var="i" begin="${pagingInfo.firstPage }"  end="${pagingInfo.lastPage }">
		      <c:if test="${i==pagingInfo.currentPage }">
		         <span style="color:blue;font-weight:bold">${i }</span>
		      </c:if>
		      <c:if test="${i!=pagingInfo.currentPage }">                  
		         <a href="#" onclick="pageFunc(${i})">
		            [${i }]
		         </a>
		      </c:if>
		   </c:forEach>
      
		   <c:if test="${pagingInfo.lastPage<pagingInfo.totalPage }">
		      <a href="#" onclick="pageFunc(${pagingInfo.lastPage+1})">         
		         <img src="<c:url value="/resources/images/last.JPG" />" border="0">
		      </a>
		   </c:if>
  		 <!--  페이지 번호 끝 -->
		</div>
	</div>
	
</section>

<%-- <%@ include file="../inc/admin_bottom.jsp"%> --%>