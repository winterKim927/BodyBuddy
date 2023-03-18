<%@page import="com.edu.bodybuddy.domain.exr.ExrNoticeImg"%>
<%@page import="com.edu.bodybuddy.domain.exr.ExrNotice"%>
<%@page import="com.edu.bodybuddy.domain.exr.ExrCategory"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%
	ExrNotice exrNotice=(ExrNotice)request.getAttribute("exrNotice");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>운동 정보 관리자 페이지</title>
<%@ include file="../inc/header_link.jsp"%>
<style type="text/css">
	.box-style{
		width:90px;
		height:95px;
		border:1px solid #ccc;
		display:inline-block;
		margin:5px;
	}
	.box-style img{
		width:65px;
		height:55px;
	}
	.box-style div{
		text-align:right;
		margin-right:5px;
		font-weight:bold;
	}
</style>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
	<div class="wrapper">

		<!-- Preloader -->
		<%@ include file="../inc/preloader.jsp" %>
		
		<!-- Navbar -->
		<%@ include file="../inc/navbar.jsp" %>
		<!-- /.navbar -->

		<!-- Main Sidebar Container -->
		<%@ include file="../inc/sidebar_left.jsp" %>
		
		
		<!-- Content Wrapper. Contains page content -->
		<div class="content-wrapper">
			<!-- Content Header (Page header) -->
			<div class="content-header">
				<div class="container-fluid">
					<div class="row mb-2">
						<div class="col-sm-6">
							<h1 class="m-0">운동 정보 관리자 페이지</h1>
						</div>
						<!-- /.col -->
						<div class="col-sm-6">
							<ol class="breadcrumb float-sm-right">
								<li class="breadcrumb-item"><a href="#">Home</a></li>
								<li class="breadcrumb-item active">상품관리> 상품등록</li>
							</ol>
						</div>
						<!-- /.col -->
					</div>
					<!-- /.row -->
				</div>
				<!-- /.container-fluid -->
			</div>
			<!-- /.content-header -->

			<!-- Main content -->
			<section class="content" id="app1">
				<div class="container-fluid">
				<!-- Main row -->
					<div class="row">
						<div class="col">
								
								<!-- 입력 요소들 -->
									<div class="form-group row">
										<div class="col">
											<input type="hidden" name="exr_notice_idx" class="form-control" value="<%=exrNotice.getExr_notice_idx() %>">
											<input type="text" name="title" class="form-control" value="<%=exrNotice.getTitle() %>">
										</div>
									</div>						
	
									<div class="form-group row">
										<div class="col">
											<input type="file" name="file" class="form-control" multiple>
										</div>
									</div>
								
									<div class="form-group row">
										<div class="col">
											<template v-for="json in imageList">
												<imagebox :src="json.src" :key="json.key" :idx="json.key"/>
											</template>
										</div>
									</div>
									
									
	
									<div class="form-group row">
										<div class="col">
											<button type="button" class="btn btn-outline-danger" id="bt_delImg">사진 지우기</button>
										</div>
									</div>
	
													
									<div class="form-group row">
										<div class="col">
											<textarea id="content" name="content" class="form-control"><%=exrNotice.getContent() %></textarea>
										</div>
									</div>
								
									<div class="form-group row">
										<div class="col">
											<button type="button" class="btn btn-outline-danger" id="bt_list">목록</button>									
											<button type="button" class="btn btn-outline-danger" id="bt_edit">수정</button>									
											<button type="button" class="btn btn-outline-danger" id="bt_del">삭제</button>									
										</div>
									</div>
								<!-- 입력 요소들./ -->
							
						</div>
					</div>
					<!-- /.row (main row) -->
				</div>
				<!-- /.container-fluid -->
			
			</section>
			<!-- /.content -->
		</div>
		<!-- /.content-wrapper -->
		
		<%@ include file="../inc/footer.jsp" %>		

		<!-- Control Sidebar -->
		<%@ include file="../inc/sidebar_right.jsp" %>
		<!-- /.control-sidebar -->
	</div>
	<!-- ./wrapper -->
	<%@ include file="../inc/footer_link.jsp" %>
	<script type="text/javascript">
	let app1;
	let key=0;
	
	/*------------------------
		이미지 미리보기 뷰
	------------------------*/ 
	const imagebox={
		template:`
			<div class="box-style">
				<div @click=delImg(p_idx)><a href="#">X</a></div>
				<img :src="p_src"/>
			</div>	
		`,
		props:["src", "idx"],
		data(){
			return{
				p_src:this.src,
				p_idx:this.idx
			};
		},
		methods:{
			delImg:function(idx){
				for(let i=0;i<app1.imageList.length;i++){
					let json=app1.imageList[i];
					
					if(json.key == idx){
						app1.imageList.splice(i , 1); 	//요소,개수
					}
				}
			}
		}
	}


	function init(){
		app1=new Vue({
			el:"#app1",
			data:{
				count:3,
				imageList:[],
				categoryList:[]
			},
			components:{
				imagebox,
			}
		});
	}


	/*----------------------
		미리보기
	----------------------*/ 
	function preview(files){
		
		for(let i=0; i<files.length; i++){
			let file=files[i];
			
			if(checkDuplicate(file)<1){
			
				let reader=new FileReader();
				reader.onload=function(e){
					console.log(file);
					key++;
					
					let json=[];
					json['src']=e.target.result;
					json['name']=file.name;
					json['file']=file;
					json['key']=key;
					
					app1.imageList.push(json);
				};
				
				reader.readAsDataURL(file);
				console.log("앱 1의 이미지 리스트~~~", app1.imageList);
			}
		}
	}

	
	function checkDuplicate(file){
		let count=0;
		for(let i=0; i<app1.imageList.length; i++){
			let json=app1.imageList[i];
			if(file.name==json.name){
				count++;
			}
		}
		return count;
	}

	
	// 사진 배열 때문에 비동기 전송해야 할 것 같은데..
	function edit(){
		
		let formData=new FormData();
		formData.append("exrCategory.exr_category_idx", $("input[name='exr_category_idx']").val());
		formData.append("title", $("input[name='title']").val());
		formData.append("content1", $("textarea[name='content1']").val());
		formData.append("content2", $("textarea[name='content2']").val());
		

		for(let i=0; i<app1.imageList.length; i++){
			let file=app1.imageList[i].file;
			formData.append("photo", file);
		}

 		$.ajax({
			url:"/admin/rest/exr/notice/edit",
			type:"POST",
			contentType:false,
			processData:false,
			data:formData,
			success:function(result, status, xhr){
				alert(result.msg);
				console.log("성공시 출력 ", result.msg);
				
			},
			
			error:function(xhr, status, err){
				console.log("에러시 출력 ", xhr.responseText);
			}
		});
		
 		
		//-----------------//
		
		
/* 		$("#form1").attr({
			action:"/admin/exr/notice/update",
			method:"POST",
			enctype:"multipart/form-data"
		});
		$("#form1").submit(); */
		
	}
	
	
	function delImg(){
		if(!confirm("등록된 사진을 모두 삭제하시겠습니까?")){
			return;
		}
		
		$.ajax({
			url:"/admin/rest/exr/notice_img/"+$("input[name='exr_notice_idx']").val(),
			type:"delete",
		
			success:function(result, status, xhr){
				alert(result.msg);
				
				//redirect
				location.href="/admin/exr/notice/detail?exr_notice_idx="+$("input[name='exr_notice_idx']").val();
			}
		});
	}
	
	
	
	/***	onLoad ***/
	$(function(){
	
		// 뷰 적용
		init();
		
		$("input[name='file']").change(function(){
			preview(this.files);
		});
		
		// 리스트 페이지 이동
		$("#bt_list").click(function(){
			location.href="/admin/exr/notice/list";
		});

		
		// 이미지만 삭제
		$("#bt_delImg").click(function(){
			if(confirm("등록된 사진을 모두 삭제하시겠습니까?")){
				delImg();
			}
		});
		
		
		// 글 수정
		$("#bt_edit").click(function(){
			if(confirm("수정하시겠습니까?")){
				edit();
			}
		});
		
		
		// 글 삭제
		$("#bt_del").click(function(){
			if(!confirm("게시글을 삭제하시겠습니까?")){
				return;
			}
			
			location.href="/admin/exr/notice/delete?exr_notice_idx="+$("input[name='exr_notice_idx']").val();
		});
		
		
		// 써머 노트 적용
		$('#content').summernote({
			height:500
		});
		
	});

	</script>
</body>
</html>