<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../inc/company_top.jsp" %>
<link rel="stylesheet" href="<c:url value='/resources/css/companyService/matchup.css'/>">
<script type="text/javascript">
$(function(){
	//리스트 선택 시 표시해주기
	$('.matchupSearch-li').click(function(){
		var num=$(this).index(); //부모 요소를 기준으로 내가 몇번째 자식이냐
		$('.matchupSearch-li').removeClass('matchupSearch-selectedLi');
		$('.matchupSearch-li:eq('+num+')').addClass('matchupSearch-selectedLi')
	});
	
	//찜 버튼 금색 토글
	$(document).on('click', '.matchupSearch-ZzimBtn', function(){
		if($(this).children('i').hasClass('goldStar')){
			$(this).children('i').removeClass('goldStar');
			//찜에서 빼기도 해야하는구만
			var resumeStr=$(this).parent().siblings('.matchupSearch-resume-1st').children('span').text();
			console.log(resumeStr.substr(3));
			var resumeNo=parseInt(resumeStr.substr(3), 10);
			console.log('resumeNo'+resumeNo);
			delZzim(resumeNo);
		}else{
			$(this).children('i').addClass('goldStar');
			//찜하기를 해볼거예요 이력서번호 넘기고 세션에서 컴코드 받아와서 넘기고
			//컨트롤러에서 이력서 번호로 매치업일반넘버 찾아
			var resumeStr=$(this).parent().siblings('.matchupSearch-resume-1st').children('span').text();
			//console.log(resumeStr.substr(3));
			var resumeNo=parseInt(resumeStr.substr(3), 10);
			//console.log(resumeNo);
			addZzim(resumeNo);
		}
	});
	
	var viewMoreSize=0;
	//더보기 기능 구현
	$(document).on('click', '#matchupSearch-viewMoreBtn', function(){
		//console.log('눌렀당');
		viewMoreSize=parseInt($('#matchupSearch-record').val(), 10);
		var keyword=$('#matchupSearchkeyword').val();
		var minCareer=$('#minCareerSelect').val();
		var maxCareer=$('#maxCareerSelect').val();
		var jikmu=$('#matchupSearch-jikmuSelect').val();
		var jikgun=$('#matchupSearch-jikgunSelect').val();
		var comCode=$('input[name=searchComCode]').val();
		viewMoreSize+=5;
		
		var urlstr="";
		if($('.matchupSearch-li').eq(0).hasClass('matchupSearch-selectedLi')){ //전체보기면
			console.log('전체 더보기!');
			urlstr="<c:url value='/company/viewMoreMatchupMem.do'/>";
		}else if($('.matchupSearch-li').eq(1).hasClass('matchupSearch-selectedLi')){ //찜한목록보기면
			console.log('찜한목록 더보기!');
			urlstr="<c:url value='/company/viewMoreZzimedList.do'/>";
		}
		
		$.ajax({
			url:urlstr,
			dataType:"json",
			type:"get",
			data:{
				"viewMoreSize":viewMoreSize,
				"searchKeyword":keyword,
				"searchMaxCareer":maxCareer,
				"searchMinCareer":minCareer,
				"searchJikmu":jikmu,
				"searchJikgun":jikgun,
				"comCode":comCode
			},
			success:function(memList){
				//alert('성공!');
				console.log(memList.length);
				memListSize=memList.length;
				if(memList.length!=5){
					$('#matchupSearch-viewMoreBtn').hide();
				}
				
				for(mcumem of memList){
					makeMemList(mcumem);
				}
				
				$('#matchupSearch-record').val(viewMoreSize);
				$('input[name=searchKeyword]').val(keyword);
				$('input[name=searchMinCareer]').val(minCareer);
				$('input[name=searchMaxCareer]').val(maxCareer);
				$('input[name=searchJikmu]').val(jikmu);
				$('input[name=searchJikgun]').val(jikgun);
				$('#matchupSearchkeyword').val(keyword);
			},
			error:function(error){
				alert('error!:'+error);
			}
		});
	});
	
	//검색버튼 클릭하면 새로고침해서 이 페이지로 돌아오기
	$('.matchupSearch-searchBtn').click(function(){
		var keyword=$('#matchupSearchkeyword').val();
		var minCareer=$('#minCareerSelect option:selected').val();
		var maxCareer=$('#maxCareerSelect option:selected').val();
		var jikmu=$('#matchupSearch-jikmuSelect').val();
		var jikgun=$('#matchupSearch-jikgunSelect').val();
		$('input[name=searchKeyword]').val(keyword);
		$('input[name=searchMinCareer]').val(minCareer);
		$('input[name=searchMaxCareer]').val(maxCareer);
		$('input[name=searchJikmu]').val(jikmu);
		$('input[name=searchJikgun]').val(jikgun);
		
		$('form[name=matchupSearchForm]').submit();
	});
	
	//찜한 이력서 보기.. 이 경우엔 검색어랑 경력 다 같이 가야할거같은뎅... 
	$('#matchupSearch-Zzimed-list').click(function(){
		console.log('찜한 이력서 보기');
		var keyword=$('#matchupSearchkeyword').val();
		var minCareer=$('#minCareerSelect').val();
		var maxCareer=$('#maxCareerSelect').val();
		var jikmu=$('#matchupSearch-jikmuSelect').val();
		var jikgun=$('#matchupSearch-jikgunSelect').val();
		var comCode=$('input[name=searchComCode]').val();
		$.ajax({
			url:"<c:url value='/company/showZzimedList.do'/>",
			dataType:"json",
			type:"get",
			data:{
				"viewMoreSize":viewMoreSize,
				"searchKeyword":keyword,
				"searchMaxCareer":maxCareer,
				"searchMinCareer":minCareer,
				"searchJikmu":jikmu,
				"searchJikgun":jikgun,
				"comCode":comCode
			},
			success:function(memList){
				console.log(memList.length);
				memListSize=memList.length;
				$('#matchupSearch-resumeListDiv').html("");
				
				for(mcumem of memList){
					makeMemList(mcumem);
				}
				if(memList.length!=5){
					$('#matchupSearch-viewMoreBtn').hide();
				}
				
				$('#matchupSearch-record').val(viewMoreSize);
				$('input[name=searchKeyword]').val(keyword);
				$('input[name=searchMinCareer]').val(minCareer);
				$('input[name=searchMaxCareer]').val(maxCareer);
				$('input[name=searchJikmu]').val(jikmu);
				$('input[name=searchJikgun]').val(jikgun);
				$('input[name=searchComCode]').val(comCode);
				$('#matchupSearchkeyword').val(keyword);
			},
			error:function(xhr, status, error){
				alert('error! '+error);
			}
		});
	});
	
	//버튼 선택 시 해당하는 데이터를 모달 팝업에 뿌려주는 기능
 	$('.matchupSearchResumeOpenBtn').click(function(){
		var resumeNo=$(this).data('resumeno');
		console.log(resumeNo)
		 
		$('#wantedResumeSimpleMD').on('show.bs.modal', function(event){
			//일단 레주메 넘버가 필요함 
			console.log('뭐가 되긴 하냐');
			var btn=$(event.relatedTarget);
			var resumeNo=btn.data('resumeno');
			//console.log(resumeNo.data('resumeno'));
			//ajax로 레주메넘버를 보내서 해당 이력서의 디비를 다 받아와야 함
			$.ajax({
				url:"<c:url value='/company/getSimpleResumeData.do'/>"
				,data:{
					'resumeNo':resumeNo,
				}
				,type:"get"
				,dataType:"json"
				,success:function(result){
					console.log(result);
					setSimpleResumeMD(result);
					//받아온 db를 모달팝업에 세팅해주기	
				}
				,error:function(xhr, status, error){
					alert('error!'+error);
				}
			});
		});
		
	});
	
	
	//아임포트
	var IMP = window.IMP; // 생략가능
	IMP.init('imp22131582'); // 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
	
	IMP.request_pay({
	    pg : 'inicis', // version 1.1.0부터 지원.
	    pay_method : 'card',
	    merchant_uid : 'merchant_' + new Date().getTime(),
	    name : '주문명:결제테스트',
	    amount : 14000,
	    buyer_email : 'iamport@siot.do',
	    buyer_name : '구매자이름',
	    buyer_tel : '010-1234-5678',
	    buyer_addr : '서울특별시 강남구 삼성동',
	    buyer_postcode : '123-456',
	    m_redirect_url : 'https://www.yourdomain.com/payments/complete'
	}, function(rsp) {
	    if ( rsp.success ) {
	        var msg = '결제가 완료되었습니다.';
	        msg += '고유ID : ' + rsp.imp_uid;
	        msg += '상점 거래ID : ' + rsp.merchant_uid;
	        msg += '결제 금액 : ' + rsp.paid_amount;
	        msg += '카드 승인번호 : ' + rsp.apply_num;
	    } else {
	        var msg = '결제에 실패하였습니다.';
	        msg += '에러내용 : ' + rsp.error_msg;
	    }
	    alert(msg);
	});
	
	
	$('#matchupResumeSimpleZzimBtn').click(function(){
		if($(this).children('i').hasClass('goldStar')){
			$(this).children('i').removeClass('goldStar');
			var resumeStr=$(this).parent().prev();
			console.log('resumeStr: '+resumeStr);
//			var resumeNo=parseInt(resumeStr.substr(3), 10);
			console.log('resumeNo: '+resumeNo);
			delZzim(resumeNo);
		}else{
			$(this).children('i').addClass('goldStar');
			//찜하기를 해볼거예요 이력서번호 넘기고 세션에서 컴코드 받아와서 넘기고
			//컨트롤러에서 이력서 번호로 매치업일반넘버 찾아
			var resumeStr=$(this).parent().siblings('.matchupSearch-resume-1st').children('span').text();
			//console.log(resumeStr.substr(3));
			var resumeNo=parseInt(resumeStr.substr(3), 10);
			//console.log(resumeNo);
			addZzim(resumeNo);
		}
	});
	
});

//모달을 그려줍니다
function setSimpleResumeMD(resumeAllVo){
	//데이터 초기화
	$('.matchupResumeName').html('');
	$('.matchupResumeWrapper').html('');
	
	var name=resumeAllVo.resumeVo.resumeName;
	var resumeNo=resumeAllVo.resumeVo.resumeNo;
	var firstName=name.substr(0,1)+"OO";
	console.log(firstName);
	$('.matchupResumeName').html("No."+resumeNo+" / "+firstName);
	
	//찜버튼 색칠해주기 
	//가져올때 찜여부 같이 가져와야되자나
	var resumeNo=resumeAllVo.resumeVo.resumeNo;
	console.log(resumeNo);
	
	$.ajax({
		url:"<c:url value='/company/isZzimed.do'/>"
		,data:{
			'resumeNo':resumeNo
		}
		,type:"get"
		,dataType:"text"
		,success:function(result){
			if(result=='Y'){
				$('#matchupResumeSimpleZzimBtn i').addClass('goldStar');
			}else{
				$('#matchupResumeSimpleZzimBtn i').removeClass('goldStar');
			}
		}
		,error:function(xhr, status, error){
			alert('error!');
		}
	});
	
	for(crr of resumeAllVo.crrList){
		var career='';
		career+='<div class="matchupResumeCont matchupResumeSpace">';
		career+='<div>';
		career+='<div class="matchupResumeSubTitle">'+crr.careerName+'</div>';
		career+='<div>'+crr.careerDep+'</div>';
		career+='</div>';
		career+='<div>'+crr.startYear+'.'+crr.startMonth+' ~ '+crr.endYear+'.'+crr.endMonth+'</div>';
		career+='</div>';
		
		$('.matchupResumeWrapper:eq(0)').append(career);
	}
	
	for(edu of resumeAllVo.eduList){
		var education='';
		education+='<div class="matchupResumeCont matchupResumeSpace">';
		education+='<div class="matchupResumeSubTitle">'+edu.eduName+'</div>';
		education+='<div>'+edu.startYear+'.'+edu.startMonth+' ~ '+edu.endYear+'.'+edu.endMonth+'</div>';
		education+='</div>';
		education+='<div>';
		education+='<div>'+edu.eduMajor+'</div>';
		education+='</div>';
		
		$('.matchupResumeWrapper:eq(1)').append(education);
	}
	
	if(resumeAllVo.addList.length>0){
		for(add of resumeAllVo.addList){
			var additional='';
			additional+='<div class="matchupResumeCont matchupResumeSpace">';
			additional+='<div class="matchupResumeSubTitle">'+add.addName+'</div>';
			additional+='<div>'+add.getYear+'.'+add.getMonth+'</div>';
			additional+='</div>';
			additional+='<div>';
			additional+=add.addDetails;
			additional+='</div>';
			
			$('.matchupResumeWrapper:eq(2)').append(additional);
		}
	}
	
	if(resumeAllVo.langList.length>0){
		var language='';
		for(lang of resumeAllVo.langList){
			language+='<div class="matchupResumeLang">';
			language+='<div>';
			language+='<span class="matchupResumeSubTitle">'+lang.langName+'</span><span class="matchupResumeMediumSpan"> '+lang.langLevel+'</span>';
			language+='</div>';
			language+='<div class="matchupResumeCont">';
			
			if(resumeAllVo.testList.length>0){
				for(test of resumeAllVo.testList){
					language+='<span class="matchupResumeMediumSpan matchupResumeBoldSpan">'+test.langtestName+'</span>';
					language+='<span class="matchupResumeMediumSpan"> '+test.getYear+'.'+test.getMonth+'</span>';
					language+='<span class="matchupResumeMediumSpan">'+test.langtestScore+'</span>';
				}
			}
			language+='</div>';
			language+='</div>';
			
			$('.matchupResumeWrapper:eq(3)').append(language);
		}
		
	}
	
}//drawSimpleResumeMD


function delZzim(resumeNo){
	$.ajax({
		url:"<c:url value='/company/delZzim.do'/>",
		type:"get",
		dataType:"text",
		data:{"resumeNo":resumeNo},
		success:function(result){
			console.log(result);
		},
		error:function(xhr, status, error){
			console.log("에러!:"+error);
		}
	});
}

function addZzim(resumeNo){
	$.ajax({
		url:"<c:url value='/company/addZzim.do'/>",
		type:"get",
		dataType:"text",
		data:{"resumeNo":resumeNo},
		success:function(result){
			//alert('성공');
			console.log(result);
		},
		error:function(xhr, status, error){
			alert('error: '+error);
		}
	});
}


//pdf 다운로드 함수 자연님것 가져옴
$.downResume=function(resumeNo){
	$.ajax({
		url:"<c:url value='/resume/resumeDown.do'/>",
		type:"get",
		data:"resumeNo="+resumeNo,
		dataType:"json",
		success:function(resDown){
			//alert(resDown);
			if(resDown>0){
				alert("pdf 파일생성, 다운로드 되었습니다.");
			}
		},
		error:function(xhr,status,error){
			alert("error:"+error);
		}
	});//ajax
}//downResume

//리스트 그리는 함수
function makeMemList(mcumem){
	var str="";
	str+='<div class="matchupSearch-resumeBound">';
	str+='<div class="matchupSearch-resume-1st">';
	str+='<i class="fas fa-user-tie"></i>';
	str+='<span>No.'+ mcumem.RESUMENO +'</span>';
	str+='</div>';
	str+='<div class="matchupSearch-resume-2nd">';
	str+='<span>직군직종명</span>';
	str+='<span>';
	
	if(mcumem.CAREER == '신입'){
		str+=mcumem.CAREER+'</span>';
	}else{
		str+=mcumem.CAREER+'년 경력</span>';
	}
	str+='<span>'+mcumem.EDUNAME+' '+mcumem.EDUMAJOR+'</span>';
	str+='</div>';
	str+='<div class="matchupSearch-resume-3rd">';
	str+='<button class="matchupSearch-ZzimBtn"><i class="fas fa-star';
	if(mcumem.CNT > 0){
		str+=' goldStar';
	}
	str+='"></i> 찜</button>';
	str+='<button data-toggle="modal" data-target="#wantedResumeSimpleMD" data-resumeno="'+mcumem.RESUMENO+'">이력서 미리보기</button>';
	str+='</div></div>';

	$('#matchupSearch-resumeListDiv').append(str);
}

</script>
<form name="matchupSearchForm" method="post" action="#">
	<input type="hidden" id="matchupSearch-record" value="0">
	<input type="hidden" value="${searchVo.searchJikgun }" name="searchJikgun">
	<input type="hidden" value="${searchVo.searchJikmu }" name="searchJikmu">
	<input type="hidden" value="${searchVo.searchKeyword }" name="searchKeyword">
	<input type="hidden" value="${searchVo.searchMinCareer }" name="searchMinCareer">
	<input type="hidden" value="${searchVo.searchMaxCareer }" name="searchMaxCareer">
	<input type="hidden" value="${sessionScope.comInfoVo.comCode}" name="searchComCode">
</form>

	<div class="matchupNoticeCon">
		<div class="container matchupNoticeWrapper">
			<div>
				<span class="matchupNoticeTitle">Matchup <i class="far fa-handshake fa-sm"></i></span>
				<span id="matchupUseorNotSpan" class="matchupNoticeText">[이용중]</span>
				<span id="matchupDuedateSpan" class="matchupNoticeText">2021.02.10까지</span>
				<span id="matchupViewCountSpan1" class="matchupNoticeText">사용 5회 </span>
				<span id="matchupViewCountSpan2" class="matchupNoticeText">| 잔여 25회</span>
			</div>
			<div class="matchupNoticeBtnWrapper">
				<!-- 매치업서비스 가입 모달 팝업 -->
				<button type="button" data-toggle="modal" data-target=".matchupServPlanMD" data-comcode="${comInfoVo.comCode}" class="matchupServiceBuyBtn">매치업 서비스 가입</button>
				<%@ include file="../company/modal/matchupServiceSelect.jsp"%>
			</div>
		</div>
	</div>
	<div class="container"> <!-- 가장 바깥 래퍼 --> 
		<section class="matchupSearch-1stSec"> <!-- 이름, 검색필터, 검색창, 필터 -->
			<h1>찾고 있는 인재의 직군/직무를 설정하세요</h1>
			<select id="matchupSearch-jikgunSelect" class="matchupSearch-select matchupSearch-selectShort">
				<c:forEach var="jikgunVo" items="${jikgunList}">
					<option value="${jikgunVo.jikgunCode}">${jikgunVo.jikgunName}</option>			
				</c:forEach>
			</select>
			<select id="matchupSearch-jikmuSelect" class="matchupSearch-select matchupSearch-selectLong"> 
				<option value="all">전체</option>
				<c:forEach var="jikmuVo" items="${jikmuList}">
					<option value="${jikmuVo.jikmuCode}">${jikmuVo.jikmuName}</option>			
				</c:forEach>
			</select>
			<div class="matchupSearch-searchFilter">
				<!-- <div class="matchupSearch-filter"> 
					<select class="matchupSearch-select matchupSearch-select-sub">
						<option>국가 선택</option>
						<option>한국</option>
						<option>일본</option>
						<option>대만</option>
						<option>홍콩</option>
						<option>싱가폴</option>
					</select>
				</div>  -->
				<!-- 드롭다운 -->
				<!-- 분량이 안될거같으면 삭제 <div class="matchupSearch-filter">
					<select class="matchupSearch-select matchupSearch-select-sub">
						<option>언어 선택</option>
						<option>한국어</option>
						<option>일본어</option>
						<option>중국어</option>
						<option>영어</option>
					</select>
				 드롭다운 -->
				 <div class="matchupSearch-filter"> 
				 	<span style="font-weight: bold; font-size: 0.8em;">최소 경력</span>
					<select id="minCareerSelect" class="matchupSearch-select matchupSearch-select-sub">
						<option value="전체"
							<c:if test="${searchVo.searchMinCareer eq '전체'}">
								selected
							</c:if>
						>전체</option>
						<option value="신입"<c:if test="${searchVo.searchMinCareer eq '신입'}">
								selected
							</c:if>
						>신입</option>
						<option value="1"
							<c:if test="${searchVo.searchMinCareer eq '1'}">
								selected
							</c:if>
						>1년</option>
						<option value="2"
							<c:if test="${searchVo.searchMinCareer eq '2'}">
								selected
							</c:if>
						>2년</option>
						<option value="3"
							<c:if test="${searchVo.searchMinCareer eq '3'}">
								selected
							</c:if>
						>3년</option>
						<option value="4"
							<c:if test="${searchVo.searchMinCareer eq '4'}">
								selected
							</c:if>
						>4년</option>
						<option value="5"
							<c:if test="${searchVo.searchMinCareer eq '5'}">
								selected
							</c:if>
						>5년</option>
						<option value="6"
							<c:if test="${searchVo.searchMinCareer eq '6'}">
								selected
							</c:if>
						>6년</option>
						<option value="7"
							<c:if test="${searchVo.searchMinCareer eq '7'}">
								selected
							</c:if>
						>7년</option>
						<option value="8"
							<c:if test="${searchVo.searchMinCareer eq '8'}">
								selected
							</c:if>
						>8년</option>
						<option value="9"
							<c:if test="${searchVo.searchMinCareer eq '9'}">
								selected
							</c:if>
						>9년</option>
						<option value="10"
							<c:if test="${searchVo.searchMinCareer eq '10'}">
								selected
							</c:if>
						>10년 이상</option>
					</select>
				</div> 
				<div class="matchupSearch-filter"> 
					<span style="font-weight: bold; font-size: 0.8em;">최대 경력</span>
					<select id="maxCareerSelect" class="matchupSearch-select matchupSearch-select-sub">
						<option value="전체"
							<c:if test="${searchVo.searchMaxCareer eq '전체'}">
								selected
							</c:if>
						>전체</option>
						<option value="신입"
							<c:if test="${searchVo.searchMaxCareer eq '신입'}">
								selected
							</c:if>
						>신입</option>
						<option value="1"
							<c:if test="${searchVo.searchMaxCareer eq '1'}">
								selected
							</c:if>
						>1년</option>
						<option value="2"
							<c:if test="${searchVo.searchMaxCareer eq '2'}">
								selected
							</c:if>
						>2년</option>
						<option value="3"
							<c:if test="${searchVo.searchMaxCareer eq '3'}">
								selected
							</c:if>
						>3년</option>
						<option value="4"
							<c:if test="${searchVo.searchMaxCareer eq '4'}">
								selected
							</c:if>
						>4년</option>
						<option value="5"
							<c:if test="${searchVo.searchMaxCareer eq '5'}">
								selected
							</c:if>
						>5년</option>
						<option value="6"
							<c:if test="${searchVo.searchMaxCareer eq '6'}">
								selected
							</c:if>
						>6년</option>
						<option value="7"
							<c:if test="${searchVo.searchMaxCareer eq '7'}">
								selected
							</c:if>
						>7년</option>
						<option value="8"
							<c:if test="${searchVo.searchMaxCareer eq '8'}">
								selected
							</c:if>
						>8년</option>
						<option value="9"
							<c:if test="${searchVo.searchMaxCareer eq '9'}">
								selected
							</c:if>
						>9년</option>
						<option value="10"
							<c:if test="${searchVo.searchMaxCareer eq '10'}">
								selected
							</c:if>
						>10년 이상</option>
					</select>
				</div> 
				<div class="matchupSearch-searchDiv">
					<input class="matchupSearch-searchInput" id="matchupSearchkeyword" type="text" 
						value="${searchVo.searchKeyword }" placeholder="회사명, 학교, 스킬 검색">
					<button class="matchupSearch-searchBtn"><i class="fas fa-search"></i></button>
				</div>
				<!-- <div class="matchupSearch-rangeSlider">
					<div class="matchupSearch-rangeSliderLabel">
						<label class="matchupSearch-label" for="amount">경력</label>
						<input type="text" id="amount" readonly style="border:0; font-weight:bold;">
					</div>
					Range Slider
					<div id="slider-range"></div>
				</div>  -->
			</div>
		</section>
		<section class="matchupSearch-2ndSec"> <!-- 목록  -->
			<div class="matchupSearch-tabBound">
				<ul class="matchupSearch-resultList">
					<li class="matchupSearch-li matchupSearch-selectedLi">
						<a href="<c:url value='/company/matchupSearch.do'/>">목록 전체</a></li>
					<li class="matchupSearch-li" id="matchupSearch-Zzimed-list">찜한 이력서</li>
					<li class="matchupSearch-li">미열람 이력서</li>
					<li class="matchupSearch-li">열람한 이력서</li>
					<li class="matchupSearch-li">면접 제안한 이력서</li>
				</ul>
			</div>
			<div class="matchupSearch-resultOrderFilters">
				<input type="radio" id="matchupSearch-orderFilter-new" name="matchupSearch-orderFilter" value="new">
				<label class="matchupSearch-orderFilterLb" for="matchupSearch-orderFilter-new">최신순</label>
				<input type="radio" id="matchupSearch-orderFilter-read" name="matchupSearch-orderFilter" value="read">
				<label class="matchupSearch-orderFilterLb" for="matchupSearch-orderFilter-read">열람순</label>
			</div>
		</section>
		<section class="matchupSearch-resumeList">
			<div id="matchupSearch-resumeListDiv">
			<!-- 
			 select m.resume_no as resumeNo, m.mem_no as memNo, m.expertise_no as expertiseNo, 
				  m.jobsearch_flag as jobSearchFlag, m.resumeopen_flag as resumepenFlag,
				  r.resume_title as resumeTitle, r.resume_name as resumeName, r.resume_introduce as resumeIntroduce, 
				  r.lang_flag as langFlag from matchupMem m join resume r 
				  on m.resume_No = r.resume_no 
			 -->
			 	<c:if test="${!empty emptyCheck }">
			 		<div style="text-align: center; padding: 50px 100px;">
				 		<span>검색결과가 없습니다. 다시 검색해 주세요.</span>
			 		</div>
			 	</c:if>
			 	<c:if test="${empty emptyCheck }">
					<c:forEach var="mcumemMap" items="${memList }">
						<div class="matchupSearch-resumeBound">
							<div class="matchupSearch-resume-1st">
								<i class="fas fa-user-tie"></i>
								<span>No.${mcumemMap.RESUMENO}</span>
							</div>
							<div class="matchupSearch-resume-2nd"> <!-- 이력서 목록 -->
								<span>직군직종</span>
								<span>
									<c:if test="${mcumemMap.CAREER eq '신입' }">
										${mcumemMap.CAREER}
									</c:if>
									<c:if test="${mcumemMap.CAREER ne '신입' }">
										${mcumemMap.CAREER}년 경력
									</c:if>
								</span>
								<span>${mcumemMap.EDUNAME} ${mcumemMap.EDUMAJOR}</span>
							</div>
							<div class="matchupSearch-resume-3rd">
								<button class="matchupSearch-ZzimBtn">
									<i class="fas fa-star <c:if test="${mcumemMap.CNT > 0}">goldStar</c:if>
									"></i> 찜</button>
								<!-- 이력서 미리보기 모달 팝업 -->								
								<button class="matchupSearchResumeOpenBtn" type="button" data-toggle="modal" data-target="#wantedResumeSimpleMD" data-resumeno="${mcumemMap.RESUMENO}">
									이력서 미리보기</button>
								<%@ include file="../company/modal/resumeSimple.jsp" %>
								<%@ include file="../company/modal/resumeDetail.jsp" %>
							</div>
						</div>
					</c:forEach>
				</c:if>
			</div>
		</section>			
		<div class="matchupSearch-resume-paging">
			<div id="matchupSearch-viewMoreBtn" class="matchupSearch-pagingDiv matchupSearch-pagingDiv_next" >
				더보기</div>
		</div>
	</div>

</body>
</html>