<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>댓글목록</title>
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
 	<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
 	<style>

 		.divContent{width:500px; padding:10px;background:gray; color:white; border:1px solid black;
 					maring-bottom:20px; border:1px; font-size:10px;}
 		#divInput{}
 	</style>
</head>
<body>

	<h1>[댓글 목록]</h1>
	댓글 :<span id="count"></span>건
	<div id="divInput">
		<input type="text" id="txtReply" size=60>
		<button id="btnInsert">입력</button>
	</div>
	<div id="tbl"></div>
	<script id="temp" type="text/x-handlebars-template">
	{{#each list}}
		<div class="divContent">
			<div class="preperationTime">
				{{preperationTime}}
			<button commentNo={{commentNo}} style="{{printStyle writer}}">삭제</button>
			</div>
			<div class="commentContent">{{commentContent}}</div>
			<div class="writer">{{writer}}</div>
		</div>
	{{/each}}
	</script>
	
	
	<div id="pagination">
		<c:if test="${pm.prev}">
			<a href="${pm.startPage-1}">◀</a>
		</c:if>
		
		<c:forEach begin="${pm.startPage}" end="${pm.endPage}" var="i">
			<c:if test="${cri.page==i}">
				[<a href="${i}" class="active">${i}</a>]
			</c:if>
			<c:if test="${cri.page!=i}">
				[<a href="${i}">${i}</a>]
			</c:if>
		</c:forEach>
		
		<c:if test="${pm.next}">
			<a href="${pm.endPage+1}">▶</a>
		</c:if>
	</div>
</body>
<script>
	var writer="${writer}";
	var postingNo=${vo.postingNo};
	getList();
	
	Handlebars.registerHelper("printStyle",function(writer){
	   var src;
	   if(writer!=writer) src="display:none";
	   return src;
	});

	
	
	$("#tbl").on("click",".preperationTime button",function(){
		var commentNo=$(this).attr("commentNo");
		if(!confirm(commentNo+"댓글을 삭제하시겠습니까?")) return;
			
		$.ajax({
			type:"post",
			url:"/reply/delete",
			data:{"commentNo":commentNo},
			success:function(){
				alert("삭제되었습니다.");
				getList();
			}
		});
		
	});
	
	$("#txtReply").keydown(function(key){
		if(key.keyCode==13){
			$("#btnInsert").click();
		}
	});
	
	$("#btnInsert").on("click",function(){
		var commentContent=$("#txtReply").val();
		if(commentContent==""){
			alert("댓글내용을 입력하세요!");
			return;
		}
		$.ajax({
			type:"post",
			url:"/reply/insert",
			data:{"postingNo":postingNo,"commentContent":commentContent,"writer":writer},
			success:function(){
				alert("댓글이 입력되었습니다.");
				$("#txtReply").val("");
				getList();
			}
		});
	});
	
	
	function getList(){
		
		$.ajax({
			type:"get",
			url:"/reply/list",
			data:{"postingNo":postingNo},
			dataType:"json",
			success:function(data){
				var temp=Handlebars.compile($("#temp").html());
				 $("#tbl").html(temp(data));
				 $("#count").html(data.count);
			}
		});
	}
</script>
</html>