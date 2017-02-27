<%@page import="com.hand.eip.news.ReadConfigFile"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.liferay.portal.service.ServiceContextFactory"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<style>
.xfNews{
		position:relative;
		width: 100%;
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
<%
	Map<String, String> thisMap = ReadConfigFile.getContent();
%>
<script src="<%=request.getContextPath()%>/js/jquery-1.10.2.min.js"></script>

<div class="xfNews">
	<div class="newsDetail">
		<div class="newsTop" id="newsTop">
			<div class="newsTitle" id="newsTitle"></div>
			<div class="newsNameDate" id="newsNameDate"><span id="signatureName"></span>&nbsp;<span id="releaseDate"></span></div>
		</div><br>
		<div class="newsCenter" id="newsCenter" ></div>

	</div>
</div>
<script type="text/javascript">
	var thisNewsId = '<%=request.getAttribute("new_id") %>';
	var prefix = '<%=thisMap.get("urlPrefix")  %>';
	var xfnum;
	$.ajax({
		type : "GET",
		dataType : "jsonp",
		jsonp:"callback",
		jsonpCallback:'newsDetail',
		//http://10.211.110.207:9080/api/public/news/eipNews/queryNewsDetail?newsId=10212
		//url : 'http://asc.hand-china.com/eip/api/public/news/eipNews/queryNewsDetail',
		url : prefix+'/eipNews/queryNewsDetail',
		data:{"newsId":thisNewsId},
		success : function(data) {
			//alert(data.thisNews.title);
			//var title = data.thisNews.title;
				//$("#newsTitle").html(data.thisnew.title.toString());
				$("#newsTitle").html(data.thisNews.title);
				$("#signatureName").html(data.thisNews.signatureName);
				$("#releaseDate").html(data.thisNews.releaseDate);
				$("#newsCenter").html(data.thisNews.content);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert("请求内容失败");
		}
	});
</script>
