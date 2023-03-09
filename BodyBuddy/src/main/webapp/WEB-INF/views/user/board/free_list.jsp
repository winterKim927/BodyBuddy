<%@page import="com.edu.bodybuddy.util.PageManager"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.edu.bodybuddy.domain.board.FreeBoard"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%
	List<FreeBoard> freeBoardList = (List)request.getAttribute("freeBoardList");
	PageManager pageManager = (PageManager)request.getAttribute("pageManager");
	
	System.out.println("jsp : " + pageManager);
	
	if(freeBoardList == null) {
		freeBoardList = new ArrayList();
		pageManager = new PageManager();
		pageManager.init(freeBoardList.size(), 0);
	};
	
%>
<!DOCTYPE html>
<!-- content 부분만 비워둔 기본 템플릿 -->
<!-- hero섹션이 포함되어있음 -->
<html lang="en">
<head>
<%@include file="../inc/header_link.jsp"%>
<style type="text/css">
tr {
	cursor: pointer
}
.row{
	margin: 0px 10px 0px 10px
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
	<div class="space-medium">
		<div class="container">
			<div class="row">
				<div class="col table-responsive">
					<table class="table table-hover">
						<thead>
							<tr>
								<th>No</th>
								<th>제목</th>
								<th>작성자</th>
								<th>등록일</th>
								<th>조회수</th>
							</tr>
						</thead>
						<tbody>
							<% int num = pageManager.getNum(); %>
							<% for(int i =0;i<freeBoardList.size();i++){ %>
							<% FreeBoard freeBoard = freeBoardList.get(i); %>
							<tr>
								<td><%= num-- %></td>
								<td><%= freeBoard.getTitle() %></td>
								<td><%= freeBoard.getWriter() %></td>
								<td><%= freeBoard.getRegdate().substring(0, 10) %></td>
								<td><%= freeBoard.getHit() %></td>
							</tr>
							<% } %>
						</tbody>
					</table>
				</div>
				<!-- end of col -->
			</div>
			<!-- end of row -->
			<div class="row">
				<button type="button" class="btn btn-default pull-right" id="bt_regist">글쓰기</button>
			</div>
			<!-- end of row -->
			<div class="row text-center">
				<div class="st-pagination">
					<!--st-pagination-->
					<ul class="pagination">
						<li><a href="#" aria-label="previous"><span aria-hidden="false">previous</span></a></li>
						
						<% for(int i =pageManager.getFirstPage();i<=pageManager.getLastPage();i++){ %>
						<% if(i>pageManager.getTotalPage()) break; %>
						<li class="active"><a href="/board/free_list/<%= i %>">1</a></li>
						<% } %>
						<li><a href="#" aria-label="Next"><span
								aria-hidden="true">next</span></a></li>
					</ul>
				</div>
			</div>
			<!-- end of row -->
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
<script>
	$(()=>{	
		$("#bt_regist").click(()=>{
			regist();
		});
	});
	
	function regist() {
		location.href = "/board/free_registform";
	}
</script>
</html>
