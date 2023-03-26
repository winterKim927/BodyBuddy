<%@page import="com.edu.bodybuddy.domain.diet.DietTip"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%
	DietTip dietTip=(DietTip)request.getAttribute("dietTip");
%>
<!DOCTYPE html>
<!-- content 부분만 비워둔 기본 템플릿 -->
<!-- hero섹션이 포함되어있음 -->
<html lang="en">
<head>
<%@include file="../inc/header_link.jsp"%>
<script src="https://kit.fontawesome.com/99ef7b560b.js" crossorigin="anonymous"></script>
<style type="text/css">
.comment-right button{
	margin: 0 10px 0 10px;
}
.comment-content{
	cursor: pointer
}
</style>
</head>

<body class="animsition">
	<!-- top-bar start-->
	<%@include file="../inc/topbar.jsp"%>
	<!-- /top-bar end-->

	<!-- hero section start -->
	<div class="hero-section">
		<!-- navigation-->
		<%@include file="../inc/header_navi.jsp"%>
		<!-- /navigation end -->
		<div class="container">
			<div class="row">
				<div class="col-lg-6 col-md-6 col-sm-12  col-xs-12">
					
				</div>
			</div>
		</div>
	</div>
	<!-- ./hero section end -->

	<!-- content start -->
	<div class="space-medium" id="app1">
		<div class="container">
			<div class="row">
				<div class="col">
                    <h1>식단팁 게시판</h1>
                    <hr>
                    <h3><%=dietTip.getTitle() %></h3>
                    <input type="hidden" class="form-control" name="diet_tip_idx"value="<%=dietTip.getDiet_tip_idx()%>">
                    <br/>
                    <span>작성자 | <%=dietTip.getRegdate() %></span>
                    <span class="float-right">조회 <%=dietTip.getHit() %> | 추천 {{recommend}}</span>
                    <hr>
				</div>
			</div>
			<!-- end of row -->
			<br/>
			<div class="row">
				<div class="col-md-12">
					<%=dietTip.getContent() %>
				</div>
				<div class="col-md-12 mt-5 mb-4 text-center">
					<button class="btn btn-default" id="bt_recommend"><i class="fa-solid fa-thumbs-up"></i> {{recommend}}</button>
				</div>	
			</div>
			<hr>
			<!-- end of row -->
			<button class="btn btn-primary float-left" id="bt_list">목록</button>
			<button type="button" class="btn btn-default pull-right" id="bt_del">삭제</button>
			<button type="button" class="btn btn-default pull-right" id="bt_edit">수정</button>
		
			<!-- 댓글영역 -->
			<hr>
			<template>
				<comments_form :idx="<%=dietTip.getDiet_tip_idx() %>" />
			</template>
			<br/>
			<template v-for="(comments) int commentsList">
				<comments :key="comments.<%= diet_tip_comments_idx %>" :comments="comments" />
			</template>
			<!-- 댓글영역 끝-->
			
		
		
		
		</div>
		<!-- end of container -->
	</div>
	<!-- end of space-medium -->
	<!-- /content end -->

	<!-- black footer_space -->
	<%@include file="../inc/footer_space.jsp"%>



	<!-- tiny footer -->
	<%@include file="../inc/footer_tiny.jsp"%>

	<%@include file="../inc/footer_link.jsp"%>

</body>

<script type="text/javascript">
	let app1;



	//글 삭제 
	function del(){
		if(!confirm("삭제하시겠습니까?")){
			return;
		}	
		
		$.ajax({
			url:"/rest/diet/tip_del/"+$("input[name='diet_tip_idx']").val(),
			type:"delete",
			success:function(result, status, xhr){
				alert("글 삭제 완료");
				location.href="/diet/tip_list/1";
			}
		});		
	}
	
	//디테일페이지 불러오기
	function getDetail(){
		$.ajax({
			url:"/rest/diet/tip_detail/"+<%= dietTip.getDiet_tip_idx() %>,
			type:"get",
			success:(result, status, xhr)=>{
				app1.recommend=result.recommend;
			},
			error:(xhr, status, err)=>{
				console.log(xhr);
			}
		});
	}
	
	//글 추천 
	function recommend(){
		let json = {};
		json["diet_tip_idx"] = "<%= dietTip.getDiet_tip_idx()%>";
		
		$.ajax({
			url:"/rest/diet/tip/recommend",
			type:"put",
			contentType:"application/json;charset=utf-8",
			processData:false,
			data:JSON.stringify(json),
			success:(result, status, xhr)=>{
				alert("추천완료");
				getDetail();	
			
			},
		});
	}
	
	function init(){
		app1=new Vue({
			el:"#app1",
			components:{
				
			},
			data:{
				recommend:[]
			}
		});
	}
	
	$(function(){
		init();
		getDetail();
		
		//목록버튼 
		$("#bt_list").click(function(){
			location.href="/diet/tip_list/1";
		});
		
		//수정버튼
		$("#bt_edit").click(function(){
			location.href="/diet/tip_edit/<%=dietTip.getDiet_tip_idx() %>";
		});
		
		//삭제버튼 
		$("#bt_del").click(function(){
			del();
		});
		
		//추천버튼
		$("#bt_recommend").click(function(){
			recommend();
			
		});
	});
</script>
</html>
