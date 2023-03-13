<%@page import="com.edu.bodybuddy.domain.board.FreeBoard"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%
	FreeBoard board = (FreeBoard)request.getAttribute("board");
	String listURI = "/board/free_list/"; //ex. /board/free_list/
	String deleteURI = "/board/free_delete?free_board_idx="; //ex. /board/free_delete?free_board_idx=
	String DetailEditURI = "/board/free_detail_edit/";
	int idx = board.getFree_board_idx();
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
					<div class="hero-caption pinside50">
						<h1 class="hero-title">자유게시판</h1>
						<p class="small-caps mb30 text-white"></p>
						<p class="hero-text">자유롭게 소통하는 게시판입니다</p>
						<!-- <a href="classes-list.html" class="btn btn-default">링크 필요하면
							사용할 버튼</a> -->
					</div>
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
                    <h1><a href="<%= listURI+1 %>">자유게시판</a></h1>
                    <hr>
                    <h3><%= board.getTitle() %></h3><br/>
                    <span><%= board.getWriter() %> | <%= board.getRegdate().substring(0, 10) + " " + board.getRegdate().substring(10, board.getRegdate().length()-2) %></span>
                    <span class="float-right">조회 <%= board.getHit() %> | 추천 <%= board.getRecommend() %></span>
                    <hr>
				</div>
			</div>
			<!-- end of row -->
			<br/>
			<div class="row">
				<div class="col-md-12">
					<%= board.getContent() %>
				</div>
				<div class="col-md-12 mt-5 mb-4 text-center">
					<button class="btn btn-default" id="bt_recommend"><i class="fa-solid fa-thumbs-up"></i> <%= board.getRecommend() %></button>
				</div>
			</div>
			<hr>
			<!-- end of row -->
			<button class="btn btn-primary" id="bt_list">목록</button>
			<button type="button" class="btn btn-danger pull-right" id="bt_del">삭제</button>
			<button type="button" class="btn btn-default pull-right" style="margin-right: 10px" id="bt_edit">수정</button>
			<hr>

			<template v-for="i in count">
				<comment :depth="i-1"/>
			</template>

			
			
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
	
	const comment = {
			template:`
				<div class="row">
					<div :class="'col-md-'+depth"></div>
					<div :class="'col-md-'+(12-depth)">
						<div class="row">
							<div class="col-md-2">
								<span>아무 작성자 입니다</span>
							</div>
							<div class="col-md-7">
								<p>내용</p>
							</div>
							<div class="col-md-3 comment-right">
								<button type="button" class="btn btn-default btn-sm float-right">
								<i class="fa-solid fa-xmark"></i></button>
								<span class="float-right">03-01 11:30</span>
							</div>
						</div>
						<hr>
					</div>
				</div>
				<!-- end of row -->
			`,
			props:['depth'],
	};

	
	
	
	$(()=>{
		init();
		$("#bt_edit").click(()=>{
			location.href="<%= DetailEditURI + idx %>";
		});
		$("#bt_del").click(()=>{
			del();
		});
		$("#bt_list").click(()=>{
			location.href="<%= listURI+1 %>";
		});
	});
	
	function init() {
		app1 = new Vue({
			el: "#app1",
	        components:{
	            comment,
	        },
	        data:{
	        	count:3
	        }
		});
	}
	
	function del() {
		if(!confirm("삭제하시겠습니까?")) return; 
		

		location.href="<%= deleteURI + idx %>";
	}
	
</script>
</html>