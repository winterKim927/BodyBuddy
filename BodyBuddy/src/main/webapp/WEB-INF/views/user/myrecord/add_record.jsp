<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@include file="../inc/header_link.jsp" %>
</head>
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
	background-color: #eeeee4;
}
#bt_add_record, #bt_regist {
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
</style>


<script type="text/javascript">
let currentYear;
let currentMonth;
let app1;
const setlist={
	template:`
		<div class="form-group" id="t_setgroup">
			{{t_set}}set
			<input type="number" name="t_kg[]" min="1" max="600">kg
			<input type="number" name="t_ea[]" min="1" max="100">개
			<a href="#">X</a>
		</div>
	`,
	props:['set'],
	data(){
		return{
			t_set:this.set
		}
	},
	methods:{
		
	}
}
const exrlist={
	template:`
		<div id="exr_ea" class="border border-danger">
			{{"운동명 :"+oneExr.exr_name}}
			<br>
			{{"세트수 :"+oneExr.sets}}
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
function getDate(){
	const date = new Date();
	let makeCalendar = (date) => {
  	currentYear = new Date(date).getFullYear();
  	currentMonth = new Date(date).getMonth() + 1;
  	let firstDay = new Date(date.setDate(1)).getDay();
  	let lastDay = new Date(currentYear, currentMonth, 0).getDate();
  	let limitDay = firstDay + lastDay;
  	let nextDay = Math.ceil(limitDay / 7) * 7;
  	var htmlDummy ='';
  	for (let i = 0; i < firstDay; i++) {
    	htmlDummy += "<div class='noColor'></div>";
  	}
  	for (let i = 1; i <= lastDay; i++) {
    	htmlDummy += "<div class='bt_days' onclick='popups(currentYear, currentMonth, "+i+")'>"+i+"</div>";
  	}
  	for (let i = limitDay; i < nextDay; i++) {
    	htmlDummy += "<div class='noColor'></div>";
  	}
  		document.querySelector('.dateBoard').insertAdjacentHTML('afterbegin',htmlDummy);
  		document.querySelector('.dateTitle').insertAdjacentHTML('afterbegin',currentYear+"년 "+currentMonth+"월");
	}
	
	makeCalendar(date);
	//오늘 날짜 그리기
	const today=new Date();
	console.log(today);	
	
	// 이전달 이동
	document.querySelector('.prevDay').onclick = () => {
		document.querySelector('.dateBoard').innerHTML="";
		document.querySelector('.dateTitle').innerHTML="";
		makeCalendar(new Date(date.setMonth(date.getMonth() - 1)));
	}
	
	// 다음달 이동
	document.querySelector('.nextDay').onclick = () => {
		document.querySelector('.dateBoard').innerHTML="";
		document.querySelector('.dateTitle').innerHTML="";
		makeCalendar(new Date(date.setMonth(date.getMonth() + 1)));
	}
	document.getElementById("bt_add_record").onclick=function(){
	};
}
function popups(currentYear, currentMonth, currentDay){
	$("#exr_day").val(" "+currentYear+" 년 "+currentMonth+" 월 "+currentDay+"일");
}
//모달창 운동등록 버튼 클릭시, 운동명과, 세트수 가져와서 기록추가 창에 보여주기
function addexr(){
	let json={};
	let setContents=[]; //한세트로 구성된 객체 여러개를 담을 Contents
	//운동명값 가져오기
	let exr_name=$("input[name='t_exr_research']").val();
	//세트수 가져오기
	let sets=app1.count;
	console.log(sets);
	//모달창 한운동에 대한 세트가 여러개이므로 하나의 배열에 넣어주자
	for(let i=0; i<sets ; i++){
		let setContent=[]; //한 세트에 담을 배열 [kg수, 갯수] 형식
		let t_kg=$($("input[name='t_kg[]']")[i]).val();
		let t_ea=$($("input[name='t_ea[]']")[i]).val();
		setContent.push(t_kg);
		setContent.push(t_ea);
		setContents.push(setContent);
	}
	
	//json에 값 넣어주기
	json['exr_name']=exr_name;
	json['sets']=sets;
	json['setContents']=setContents;
	console.log("등록된 운동수는 : ",app1.exerciseList);
	console.log("운동기록에 세부내용 : ", setContents);
	app1.exerciseList.push(json);
	console.log("최종적으로 받은 json: ", json);
	let json2={};
	json2['data']=json;
	console.log(JSON.stringify(json2));
	//모달창 초기화
	$("input[name='t_exr_research']").val("");
	$("input[name='t_kg[]']").val("");
	$("input[name='t_ea[]']").val("");
	app1.count=1;
}
function regist(){
	let result=confirm("운동기록을 등록하시겠어요?");
	console.log(result);
	//let val=$("input[name='OneExr']").serialize();
	if(result===true){
		$("#form1").attr({
			action:"/myrecord/exr_regist",
			method:"POST"
		});
		$("#form1").submit();
	}
}
$(function(){
	init();
	getDate();
	//모달창 세트추가 버튼 클릭시, 세트 추가
	$("#bt_add_set").click(function(){
		app1.count+=1;
	});
	$("#bt_regist").click(function(){
		regist();
	});
	//모달창 운동등록 버튼 클릭시, 운동명과, 세트수 가져와서 기록추가 창에 보여주기
	$("#bt_one_exr_regist").click(function(){
		addexr();
	});
	/*
	document.getElementsByClassName("grid dateBoard").addEventListener("mouseover", function(){
		console.log("됨");
	)};
	*/
});
</script>
<body class="animsition">
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
							<div onclick="popups(1)">토</div>
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
                	<form id="form1">
                	<h3 class="">기록 추가</h3>
					<input type="text" id="exr_day" disabled>
					
					<template v-for="exr in exerciseList">
						<exrlist :exr="exr"/>
					</template>
					                	
                	<div class="form-group">
		            	<button type="button" class="btn btn-default" id="bt_add_record" data-toggle="modal" data-target="#myModal">기록추가</button>
		            	<button type="button" class="btn btn-default" id="bt_regist">기록 등록</button>
		            </div>
		            </form>     	
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
									<input type="text" class="form-control" placeholder="운동 검색..." name="t_exr_research">
									
									<template v-for="set in count">
										<setlist :set="set" />
									</template>
									
									<button type="button" id="bt_add_set" class="btn btn-primary btn-sm float-right">세트추가</button>
								</div>
							</div>

							<!-- 모달 footer -->
							<div class="modal-footer">
								<button type="button" id="bt_one_exr_regist" class="btn btn-danger" data-dismiss="modal">운동 등록</button>
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