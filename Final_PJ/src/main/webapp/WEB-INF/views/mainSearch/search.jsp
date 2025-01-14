<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../inc/top.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="<c:url value='/resources/css/mainSearch.css'/>">

<div class="search-keyword-wrap">
	<h2 class="search-keyword">${param.keyword}</h2>
</div>

<div class="container search-wrap">
	<!-- 회사 -->
	<div class="search-company">
		<h2 class="search-company-title">회사<span>${fn:length(searchCom)}</span></h2>
		<div class="search-company-conBox">
			<div class="row">
				<c:forEach var="vo" items="${searchCom}">
				<div class="col-lg-6">
					<a href="#" class="search-company-link">
						<div class="search-company-link-detail-left">
							<div class="search-company-img" style="background:url('<c:url value="/companyImgUpload/${vo.comImgUrl}"/>');
								background-size:100%; background-repeat:no-repeat; background-position:center;"></div>
							<div class="search-company-name">
								<h5>${vo.comName }</h5>
								<h6>${vo.industry }</h6>
							</div>
						</div>
						<button type="button" class="follow-btn">팔로우</button>
					</a>
				</div>
				</c:forEach>
			</div>
		</div>
	</div>
	
	<!-- 포지션 -->
	<div class="search-position">
		<h2 class="search-position-title">포지션<span>${fn:length(searchPos)}</span></h2>
		<div class="row">
		<c:forEach var="vo" items="${searchPos }">
			<div class="col-lg-3 col-md-6">
			<a href="<c:url value='/jobsearch/jobsearchDetail.do?posNo=${vo.posNo }'/>" style="display:block;">
				<div class="about-block-item mb-5 mb-lg-0" style="padding-bottom:40px;">
					<img src="<c:url value='/companyImgUpload/${vo.comImgUrl }' />" class="img-fluid w-100">
					<h4 class="mt-3 passPredic-pic-title">${vo.posName }</h4>
					<p class="ge-job-card-company-name">${vo.comName }</p>
					<div class="ge-job-card-company-location">
						<c:set var="region" value="${vo.region }"/>
						<c:choose>
							<c:when test="${region eq 'KR11' }">서울</c:when>
							<c:when test="${region eq 'KR12' }">부산</c:when>
							<c:when test="${region eq 'KR13' }">대구</c:when>
							<c:when test="${region eq 'KR14' }">인천</c:when>
							<c:when test="${region eq 'KR19' }">경기</c:when>
							<c:when test="${region eq 'JP11' }">도쿄</c:when>
							<c:when test="${region eq 'JP12' }">오사카</c:when>
							<c:when test="${region eq 'JP13' }">교토</c:when>
							<c:when test="${region eq 'JP14' }">후쿠오카</c:when>
							<c:when test="${region eq 'JP15' }">ETC</c:when>
							<c:when test="${region eq 'TW11' }">타이페이</c:when>
							<c:when test="${region eq 'TW12' }">가오슝</c:when>
						</c:choose>
						<span class="ge-addressDot">.</span>
						<span>
						<c:set var="nation" value="${vo.nation }"/>
						<c:choose>
							<c:when test="${nation eq 'KR' }">한국</c:when>
							<c:when test="${nation eq 'TW' }">대만</c:when>
							<c:when test="${nation eq 'SG' }">싱가폴</c:when>
							<c:when test="${nation eq 'JP' }">일본</c:when>
							<c:when test="${nation eq 'HK' }">홍콩</c:when>
							<c:when test="${nation eq 'ETC' }">기타</c:when>
						</c:choose>
						</span>
					</div>
					<div class="ge-reward">채용보상금 1,000,000원</div>
				</div>
			</a>
			</div>
		</c:forEach>
		</div>
	</div>
	
	<div class="job-opening-wrap">
		<h2 class="job-opening-title">원티드 이외의 채용공고를 더 확인해 보세요.</h2>
		<div class="job-opening-con-box">
			<h3>아쉽지만 수집된 채용공고가 충분하지 않습니다.<br>
			매치업에 등록하고 기업에게 먼저 면접제안을 받아보세요.</h3>
			<button type="button" style="outline:none;">매치업 등록하기</button>
		</div>
	</div>
</div>

<%@ include file="../inc/bottom.jsp" %>