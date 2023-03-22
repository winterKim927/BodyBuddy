<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@include file="../inc/header_link.jsp" %>
</head>
<!-- fontAwesome CDN icon 사용시 필요 -->
<script src="https://kit.fontawesome.com/cfa2095821.js" crossorigin="anonymous"></script>
<style>
.dateHead div {
	background: #dc3545;
	color: #fff;
	text-align: center;
	border-radius: 5px;
}
.grid {
	display: grid;
	grid-template-columns: repeat(7, 1fr);
	grid-gap: 5px;
}
.grid div {
	padding: .6rem;
	font-size: .9rem;
	cursor: pointer;
}
.dateBoard div {
	color: #222;
	font-weight: bold;
	min-height: 6rem;
	padding: .6rem .8rem;
	border-radius: 5px;
	border: 1px solid #eee;
}
.noColor {
	background: #eee;
}
.header {
	display: flex;
	justify-content: space-between;
	padding: 1rem 2rem;
}
/* 좌우 버튼 */
.btns {
	display: block;
	width: 20px;
	height: 20px;
	border: 3px solid #000;
	border-width: 3px 3px 0 0;
	cursor: pointer;
}
.prevDay {
	transform: rotate(-135deg);
}
.nextDay {
	transform: rotate(45deg);
}
/* ---- */
* {
	margin: 0;
	padding: 0;
	list-style: none;
	box-sizing: border-box;
	font-family: Pretendard;
}
.bt_days:hover{
	border : 1px solid #dc3545;
	transform: scale(1.1);
}
.rap {
	max-width: 820px;
	padding: 0 1.4rem;
	margin-top: 1.4rem;
}
.dateHead {
	margin: .4rem 0;
}
.btn-group-vertical {
	position: fixed;
}
#right_sector {
	padding: 20px;
	position: relative;
	top: 150px;
	text-align: center;
	height: 400px;
	border-radius:5px;
	background-color: #eeeee4;
}
#bt_add_record, #bt_regist {
	border-radius:5px;
	border: 1px solid white;
}
#myModal {
	background: white;
}
#t_kg, #t_ea {
	width: 50px;
}
#t_setgroup {
	text-align: center;
}

/*운동아이콘 스타일*/
.fa-dumbbell {
	color:#49469c;
}
.fa-dumbbell:hover {
	transform: scale(1.3);
}
.bg-gradient-primary {
    background: #007bff linear-gradient(180deg,#268fff,#007bff);
    color: #fff;
    border-radius:6px;
    width: 70%;
}
</style>


<script type="text/javascript">
let currentYear;
let currentMonth;
let currentDay;
let lastDay;
let divValue;

let app1;
const setlist={
	template:`
		<div class="form-group" id="t_setgroup">
			{{t_set}}set
			<input type="number" name="t_kg[]" min="1" max="600">kg
			<input type="number" name="t_ea[]" min="1" max="100">개
			<a href="#" @click="del">X</a>
		</div>
	`,
	props:['set'],
	data(){
		return{
			t_set:this.set
		}
	},
	methods:{
		del:function(){
			console.log("먹음");
			app1.count-=1;
		}
	}
}
const exrlist={
	template:`
		<div id="exr_ea" class="border border-danger">
			{{"운동명 :"+oneExr.exr_name}}
			<br>
			{{"세트수 :"+oneExr.exrRecordDetailList.length}}
			<input type="hidden" name="oneExr">
		</div>
	`,
	props:['exr'],
	data(){
		return{
			oneExr:this.exr
		}
	},
	methods:{
		
	}
}
function init(){
	app1=new Vue({
		el:"#app1",
		components:{
			setlist,
			exrlist
		},
		data:{
			count:1,
			exerciseList:[]
		}
	
	});
}
//달력을 누를때, regdate의 day값도 미리 들어가 있어야함(내용을 먼저 선택하고 달력을 누르면 day가 적용안됨)
function getDate(){
	const date = new Date();
	let makeCalendar = (date) => {
  	currentYear = new Date(date).getFullYear();
  	currentMonth = new Date(date).getMonth() + 1;
  	let firstDay = new Date(date.setDate(1)).getDay();
  	lastDay = new Date(currentYear, currentMonth, 0).getDate();
  	divValue = currentYear+"-"+currentMonth+"-"; //div에 넣어줄 value뭉치
  	let limitDay = firstDay + lastDay;
  	let nextDay = Math.ceil(limitDay / 7) * 7;
  	let htmlDummy ='';
  	for (let i = 0; i < firstDay; i++) {
    	htmlDummy += "<div class='noColor'></div>";
  	}
  	for (let i = 1; i <= lastDay; i++) {
    	htmlDummy += "<div class='bt_days' value='"+divValue+i+"' onclick='popups(currentYear, currentMonth, "+i+")'>"+i+"</div>";
  	}
  	for (let i = limitDay; i < nextDay; i++) {
    	htmlDummy += "<div class='noColor'></div>";
  	}
  		document.querySelector('.dateBoard').insertAdjacentHTML('afterbegin',htmlDummy);
  		document.querySelector('.dateTitle').insertAdjacentHTML('afterbegin',currentYear+"년 "+currentMonth+"월");
	}
	
	makeCalendar(date);
	//오늘 날짜 그리기
	//const today=new Date();
	//console.log(today);	
	
	// 이전달 이동
	document.querySelector('.prevDay').onclick = () => {
		document.querySelector('.dateBoard').innerHTML="";
		document.querySelector('.dateTitle').innerHTML="";
		makeCalendar(new Date(date.setMonth(date.getMonth() - 1)));
		getExrRecordForMonth();
	}
	
	// 다음달 이동
	document.querySelector('.nextDay').onclick = () => {
		document.querySelector('.dateBoard').innerHTML="";
		document.querySelector('.dateTitle').innerHTML="";
		makeCalendar(new Date(date.setMonth(date.getMonth() + 1)));
		getExrRecordForMonth();
	}
	document.getElementById("bt_add_record").onclick=function(){
	};
}

//날짜 클릭시 오른쪽 기록추가 날짜 영역에 값이 옮겨짐
function popups(currentYear, currentMonth, today){
	currentDay=today;
	$("#exr_day").val(" "+currentYear+" 년 "+currentMonth+" 월 "+today+"일");
}

let exrList=[]; //운동을 담을 배열
let exrObject=new Object(); //하나의 운동(exr_name, setList[])를 담을 객체
//모달창 운동등록 버튼 클릭시, 운동명과, 세트수 가져와서 기록추가 창에 보여주기
//PS: 이부분을 오른쪽영역에 rendering하는 부분과 JSON구성하는 부분을 나누는게 좋을듯
function addexr(){
	
	if($("input[name='t_exr_research']").val()=="" || $("input[name='t_kg[]']").val()=="" || $("input[name='t_ea[]']").val()==""){
		alert("운동기록을 적어주세요");
	}else{
		let json={}; //JSON을 담을 바구니;
		let setList=[]; //한운동에 해당하는 세트를 담을 배열
		
		//세트 수의 크기
		let setsize=app1.count;
		console.log("세트 수는 ", setsize);
		for(let i=0; i<setsize; i++){
			let data=new Object();
			let kg=$($("input[name='t_kg[]']")[i]).val();
			let ea=$($("input[name='t_ea[]']")[i]).val();
			console.log("kg수는 ",kg);
			console.log("ea수는 ",ea);
			data.kg=kg;
			data.times=ea;
			setList.push(data);
		}
		
		//운동명
		let exrname=$("input[name='t_exr_research']").val();
		
		exrObject.exr_name=exrname;
		exrObject.exrRecordDetailList=setList;
		
		//기록추가 영역에 추가될 미리보기
		app1.exerciseList.push(exrObject);
	}
	
}

//운동기록 날짜를 가져올 함수
function getDayforRegistExr(){
	let exr_day=$("#exr_day").val();
	let regdate=currentYear+"-"+currentMonth+"-"+currentDay;
	console.log(regdate);
	exrObject.regdate=regdate;
}

function regist(){
	getDayforRegistExr();
	exrList.push(exrObject);
	
	if($("#exr_day").val()=="" || $("input[name='t_exr_research']").val()==""){
		alert("날짜또는 운동기록을 추가해주세요");
		
	}else{
		let result=confirm("운동기록을 등록하시겠어요?");
		
		let JsonData=JSON.stringify(exrList);
		console.log(JsonData);
	
		if(result===true){
			$.ajax({
				url:"/rest/myrecord/exrList",
				type:"POST",
				processData:false,
				contentType:"application/json",
				data:JsonData,
				success:function(result, status, xhr){
					alert("입력되었습니다");
				},
				error:function(xhr, status, error){
					alert("실패");
				}
			});
		}
	}
}

//운동등록버튼 활성 비활성화를 감지
function btchange(){
	const target=document.getElementById("bt_one_exr_regist"); //JQuery가 안먹음
	for(let i=0; i<app1.count; i++){
		if($("#bt_exr_search").val()=="" || $($("input[name='t_kg[]']")[i]).val()=="" || $($("input[name='t_ea[]']")[i]).val()==""){
			target.disabled=true;
			console.log("빈칸이 있음");
		}else{
			target.disabled=false;
		}
	}
}

//모달을 초기화 하는 함수
function removeContent(){
	$("input[name='t_exr_research']").val("");
	$("input[name='t_kg[]']").val("");
	$("input[name='t_ea[]']").val("");
	app1.count=1;
}

//div에 상세버튼 추가하기를 따로 둠(다른 기록 기록할때, 또 생성하게 하지 않기 위해)
function addButtononRecord(getDay){
	$($(".bt_days")[getDay-1]).append("<button type='button' class='btn btn-block bg-gradient-primary btn-xs' onclick='putDetail("+getDay+")' data-toggle='modal' data-target='#detailModal'>상세</button>");	
}

//상세버튼 클릭시 날짜와 세트수가 기록상세 모달의 운동기록에 전달
//형식: 2022-03-24 운동기록보러가기
function putDetail(getDay){
	$("label[for='la_exrDetail']").text(currentYear+"년 "+currentMonth+"월 "+getDay+"일 운동기록 상세보기");
}

//해당 div에 이미지 넣기
function appendImage(getDay){
	//<br>태그를 임시로 적어두긴 했는데, 나중에 위치조정할 것
	addButtononRecord(getDay);
	$($(".bt_days")[getDay-1]).append("<br><br><i class='fa-solid fa-dumbbell fa-lg'></i>");
	$($(".bt_days")[getDay-1]).css("border", "1px solid #49469c");
	//상세보기 버튼 주기
}

//운동기록이 있는 날에 이미지 붙이기
function appendImageDays(registedDataForMonth){
	let divdays=document.getElementsByClassName("bt_days");
	let selectedDays=[];
	
	//숫자 변환 작업 01을 1로 11은 11같이
	for(let i=0; i<registedDataForMonth.length; i++){
		let registedData=registedDataForMonth[i];
		let processedData=registedData.regdate.slice(8,10);
		if(processedData.substr(0,1)==0){
			let selectedDay=registedData.regdate.slice(9,10); //ex: 11 (일)div와 비교해 이미지 붙이기 위해
			selectedDays.push(selectedDay);
		}else{
			let selectedDay=registedData.regdate.slice(8,10); //ex: 11 (일)div와 비교해 이미지 붙이기 위해
			selectedDays.push(selectedDay);
		}
		//console.log(selectedDays[0]);
	}
	
	//console.log(processedData);
	for(let a=0; a<selectedDays.length; a++){
		let getDay=selectedDays[a];
		appendImage(getDay);
	}
	
}

function getExrRecordForMonth(){
	//해당달의 첫날과 마지막날을 JSON형식으로 만듬
	let json={};
	json['firstDay']=currentYear+"-"+currentMonth+"-"+1;
	json['lastDay']=currentYear+"-"+currentMonth+"-"+lastDay;
	let dateData=JSON.stringify(json);
	console.log(dateData);
	
	//비동기로 해당달의 첫날과 마지막날을 전송
	$.ajax({
		url:"/rest/myrecord/exrListForMonth",
		type:"POST",
		processData:false,
		data:dateData,
		contentType:"application/json",
		success:function(result, status, xhr){
			console.log(typeof result);
			appendImageDays(result);
			console.log("받아온 날짜는",result);
			alert("성공적으로 불러옴");
		},
		error:function(xhr, status, error){
			console.log(error, "기록불러오던 중 에러발생");
		}
	});
}

function getExrDetail(){
	//event전파를 막는 메서드..
	//그런데, 이 event는 어디서 받아오는 거지..?
	//event.stopPropagation(); 이게 있으면 모달 창이 안뜸...
	//$("#h4_detail_name").val("가자");
}

//운동기록 페이지로 이동하는 메서드
function moveToExrDetail(){
	//운동기록 페이지로 이동할때, 날짜 데이터를 가지고 가서 바로 보여주는 것이 편하기는 하나...전달해서 보여주기가 애매함
	//location.href 뒤에 ?를 붙여서 가면, detail을 보여줄수 있는데, 그러면 운동기록 페이지에서 각 날짜를 눌러 detail을 볼때,
	//새로고침이 일어나야하는데, 내가 원했던것은 비동기로 보여주는 것이다. 동기방식으로 보여주는 거랑 비동기랑 섞이면 일관되지 않지 않은가?
	let detailDate=currentYear+"-"+currentMonth;
	//alert(detailDate);
	location.href="/myrecord/exr_record?detailDate="+detailDate;
}

$(function(){
	init(); 
	getDate(); //달력출력
	getExrRecordForMonth();
	
	//모달창 세트추가 버튼 클릭시, 세트 추가
	$("#bt_add_set").click(function(){
		app1.count+=1;
	});
	$("#bt_regist").click(function(){
		regist();
	});
	$(".close").click(function(){
		removeContent();
	});
	
	//빈칸이 없을시 버튼이 활성화되는 것을 감지하는 (세트추가시 버튼 활성화되어 있는 것 해결 할 예정)
	$("#bt_exr_search").on("propertychange change paste input", function(){
		btchange();
	});
	$("input[name='t_kg[]']").on("propertychange change paste input", function(){
		btchange();
	});
	$("input[name='t_ea[]']").on("propertychange change paste input", function(){
		btchange();
	});

	//모달창 운동등록 버튼 클릭시, 운동명과, 세트수 가져와서 기록추가 창에 보여주기
	$("#bt_one_exr_regist").click(function(){
		addexr();
	});
	$("#bt_getDetailForExr").click(function(){
		moveToExrDetail();
	});
});
</script>
<body>
    <!-- top-bar start-->
	<%@include file="../inc/topbar.jsp" %>
    <!-- /top-bar end-->

    <!-- hero section start -->
    <div class="hero-section">
		<!-- navigation-->
	   	<%@include file="../inc/header_navi.jsp" %>
	    <!-- /navigation end -->
    </div>
     <!-- ./hero section end -->
     <div class="top-bar">
     	<div class="container">-</div>
     </div>
    
    <!-- content start -->
    <div class="space-medium">
        <div class="container" id="app1">
            <div class="row">
            	<!-- 왼쪽에 나의 기록 목록 나오는 영역 -->
            	<div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
				    <div class = "btn-group-vertical">
				        <button type = "button" class = "btn btn-default">기록 추가</button>
				        <button type = "button" class = "btn btn-primary">신체기록</button>
				        <button type = "button" class = "btn btn-primary">운동기록</button>
				        <button type = "button" class = "btn btn-primary">식단기록</button>
				    </div>
            	</div>
            	
            	<!-- 달력 나올 영역 -->
                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
					<div class='rap'>
						<div class="header">
							<div class="btns prevDay"></div>
							<h2 class="dateTitle"></h2>
							<div class="btns nextDay"></div>
						</div>

						<div class="grid dateHead">
							<div>일</div>
							<div>월</div>
							<div>화</div>
							<div>수</div>
							<div>목</div>
							<div>금</div>
							<div>토</div>
						</div>

						<div class="grid dateBoard"></div>
					</div>

					<!-- 
                    <div class="service-block pdt60 mb30">
                        <h1 class="default-title mb30">기록 추가 페이지</h1>
                        <p class="mb40">기록 추가하는 페이지입니다</p>
                        <a href="classes-list.html" class="btn btn-default">View ALL Classes</a>
                    </div>
                	-->
                </div>
                
                <!-- 기록추가 화면 나올 곳 -->
                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 card" id="right_sector">
                	<h3 class="">기록 추가</h3>
					<input type="text" id="exr_day" disabled>
					
					<template v-for="exr in exerciseList">
						<exrlist :exr="exr"/>
					</template>
					                	
                	<div class="form-group">
		            	<button type="button" class="btn btn-default" id="bt_add_record" data-toggle="modal" data-target="#myModal">기록추가</button>
		            	<button type="button" class="btn btn-default" id="bt_regist">기록 등록</button>
		            </div>
                </div>
				
				<!-- ------------------------------------------------------------------------------- -->
				<!-- 추가할 사항: 모달창 배경 투명하게 할 예정, 모달창에서 x누르면 해당 열이 삭제 되도록 -->
				<!-- 모달 창 나오는 곳 -->
				<div class="modal" id="myModal">
					<div class="modal-dialog modal-dialog-centered">
						<div class="modal-content">

							<!-- 모달 제목 -->
							<div class="modal-header">
								<h4 class="modal-title">기록추가</h4>
								<button type="button" class="close" data-dismiss="modal">&times;</button>
							</div>

							<!-- 모달 내용 -->
							<div class="modal-body">
								<div class="form-group">
									<input type="text" class="form-control" placeholder="운동 검색..." name="t_exr_research" id="bt_exr_search">
									
									<template v-for="set in count">
										<setlist :set="set" />
									</template>
									
									<button type="button" id="bt_add_set" class="btn btn-primary btn-sm float-right">세트추가</button>
								</div>
							</div>

							<!-- 모달 footer -->
							<div class="modal-footer">
								<button type="button" id="bt_one_exr_regist" class="btn btn-danger" data-dismiss="modal" disabled>운동 등록</button>
							</div>

						</div>
					</div>
				</div>


				<!-- 상세보기 모달 창 나오는 곳 -->
				<div class="modal" id="detailModal">
					<div class="modal-dialog modal-dialog-centered">
						<div class="modal-content">

							<!-- 모달 제목 -->
							<div class="modal-header">
								<h4 class="modal-title" id="h4_detail_name">기록상세</h4>
								<button type="button" class="close" data-dismiss="modal">&times;</button>
							</div>

							<!-- 모달 내용 -->
							<div class="modal-body">
								<div class="form-group">
									<label for="la_physicalDetail">2023-03-22 신체기록 상세보기(임시)</label>
									<button type="button" id="bt_getDetailForPhysic" class="btn btn-primary btn-sm float-right">신체상세</button>
								</div>
								<div class="form-group">
									<label for="la_exrDetail">2023-03-22 운동기록</label>
									<button type="button" id="bt_getDetailForExr" class="btn btn-primary btn-sm float-right">운동상세</button>
								</div>
								<div class="form-group">
									<label for="la_dietDetail">2023-03-22 식단기록 상세보기(임시)</label>
									<button type="button" id="bt_getDetailForDiet" class="btn btn-primary btn-sm float-right">식단상세</button>
								</div>
							</div>

						</div>
					</div>
				</div>

			</div>
        </div>
    </div>
    <!-- /content end -->

    <!-- black footer_space -->
    <%@include file="../inc/footer_space.jsp" %>
    
    <!-- tiny footer -->
    <%@include file="../inc/footer_tiny.jsp" %>
    
	<%@include file="../inc/footer_link.jsp" %>

</body>

</html>