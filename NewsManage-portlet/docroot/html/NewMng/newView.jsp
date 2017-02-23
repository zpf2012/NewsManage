<%@page import="com.liferay.portal.service.ServiceContextFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../common/init.jsp"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<style>
.xfNews{
		position:relative;
		width: 100%;
		height: 100%;
		background-color: white;
		border: 1px #cccccc solid;
	}
	.newsDetail{
		position:relative;
		margin:5% 6% 15% 6%;
	}
	.newsTop .newsTitle{
		position:relative;
		margin-bottom:10px;
		font-size:26px;
		font-family:黑体;
		font-weight: 600;
		line-height: 30px;
	}
	.newsTop .newsNameDate{
		position:relative;
		font-family:黑体;
		font-size:16px;
		font-weight: 600;
	}
	.newsDetail hr{
		width:100%;
		margin: 30px auto 30px;
	}
	.newsDetail .newsCenter{
		position:relative;
		font-size:14px;
		color: black;
		font-weight: 500;
		line-height: 30px;
	}
	.newsBottom{
		position:relative;
		font-size:15px;
		color: black;
		font-weight: 500;
		margin-bottom:100px; 
	}
	.praiseNumberSpan{
		font-size:6px;
	}
	.newsPraise {
		-moz-border-radius: 8px;
		-webkit-border-radius: 8px;
		border-radius: 8px;
		background-color: #30b8ff;
		text-align: center;
		color:white;
		font-size: 20px;
		width: 150px;
		height: 60px;
		line-height: 60px;
		float: left;
		cursor: pointer;
	}
	.xinSpan{
		font-size: 30px;
		line-height: 60px;
		vertical-align: top;
	}
	.nextOrPrevNews{
		position:relative;
		text-align:left;
		float: left;
		width:auto;
		height: 60px;
		font-size:16px;
		margin-left: 8%;
		margin-top: 3px;
		line-height: 28px;
	}
</style>
<div class="xfNews">
	<div class="newsDetail">
		<div class="newsTop" id="newsTop">
			<div class="newsTitle" id="newsTitle">《认识汉得百人》谁言别后终无悔，清夜寒霄夜梦回——EPM事业部TB</div>
			<div class="newsNameDate" id="newsNameDate"><span id="signatureName">汉得信息</span>&nbsp;<span id="releaseDate">2016-12-10</span></div>
		</div><br>
		<div class="newsCenter" id="newsCenter" >无内容</div>

	</div>
</div>
<script type="text/javascript">
	var thisNewsId = window.location.search.substring(1).split("=")[1];
	var userId =<%=ServiceContextFactory.getInstance(request).getUserId()%>;
	var zan="T";
	var xfnum;
	$(function(){
		queryNewsDetail(thisNewsId);

	});
	function queryNewsDetail(thisNewsId,userId){
		$.ajax({
			type : "GET",
			dataType : "jsonp",
			jsonp:"callback",
			jsonpCallback:'newsDetail',
			url : 'http://asc.hand-china.com/eip/api/public/news/eipNews/queryNewsDetail',
			data:{"newsId":thisNewsId},
			success : function(data) {
					$("#newsTitle").html(data.thisNews.title);
					$("#signatureName").html(data.thisNews.signatureName);
					$("#releaseDate").html(data.thisNews.releaseDate);
					$("#newsCenter").html(data.thisNews.content);
			}
		});
	};

</script>