<%@page language="java" pageEncoding="UTF-8"%>

<%-- <%@ include file="../init.jsp" %> --%>
<%-- <portlet:renderURL var="newPreview">
	<portlet:param name="newId" value="newView.jsp"/>
	<portlet:param name="mvcPath" value="newView.jsp"/>
</portlet:renderURL> --%>

<script type="text/javascript">
	var urlPrefix = '<%=map.get("urlPrefix") %>';
	var total = 0;
	var head = '<thead class="table-columns"><tr><th><input id="selectAll" onclick="checkAll()" type="checkbox"/></th><th class="table-first-header" width="400px">标题</th><th width="200px">摘要</th><th>类型</th><th>发布日期</th><th>发布人</th><th>当前状态</th><th>操作</th></tr></thdea>';

	<%-- var options = '<a title="newPreview" href="<%=newPreview %>" target="_blank" onclick="newPreview()">预览</a>&nbsp;&nbsp;<a href="'+urlPrefix+'/edit?id=##new_id##">编辑</a>';
	 --%>
	 <%-- <%=request.getContextPath() %>/edit?id=##new_id## --%>
	var options = '<a href="<%=request.getContextPath() %>/view?id=##new_id##" target="_blank">预览</a>&nbsp;&nbsp;<a href="javascript:void(0);" onclick="changeTabToEdit(this)" title="##new_id##">编辑</a>';
	var template = '<tbody class="table-data"><tr><td><input id="##new_id##" name="news_entry" onclick="changeState(this)" type="checkbox"/></td><td>##title##</td><td>##summary##</td><td>##newsType##</td><td>##releaseDate##</td><td>##signatureName##</td><td>##status##</td><td>';

	
	//初始化参数
	var page = 1;
	var pageSize = 15;		//每页显示条数：共有五种参数： 15， 30， 45， 60， 75
	var timeInterval = 1;  //查询时间区间，1代表1个月，12代表一年，-1代表所有
	var pages = 0;
	var newsType = "ALL";	//HEIP_NEWSTYPE_NEWS， HEIP_NEWSTYPE_ANNOUNCEMENT， ALL
	var html = '';
	var htmlTemp = template;
	var optionsTemp = options;
	
	$(function() {
		
		getData();

		$('input[name="news_entry"]').prop("checked", false);
		
		$("#test").html('<a href="'+urlPrefix+'/eipNews/query?page=1&pageSize=15&timeInterval=3&newsType=ALL">查看数据</a>');

		
	});
	var checkAllTrigger = false;
	var newsArr = [];
	
	
	function changeTabToEdit(obj){
		var new_id = $(obj).attr("title");
		$.ajax({
			type : "GET",
			dataType : "jsonp",
			jsonp:"callback",
			jsonpCallback:'newsDetail',
			//http://10.211.110.207:9080/api/public/news/eipNews/queryNewsDetail?newsId=10212
			//url : 'http://asc.hand-china.com/eip/api/public/news/eipNews/queryNewsDetail',
			url : urlPrefix+'/eipNews/queryNewsDetail',
			data:{"newsId":new_id},
			success : function(data) {
				if(data.thisNews.newsType != "HEIP_NEWSTYPE_ANNOUNCEMENT"){
					//$("#newsId").val(data.thisNews.newsId);
					$("#pubNews").prop("class", "tab-pane fade in active");
					$('a[href="#pubNews"]').parent().prop('class', 'active');
					alert(data.thisNews.summary+"///"+data.thisNews.content);
					
					$("#moreTitle").val(data.thisNews.title);
					$("#moreAuthor").val(data.thisNews.signatureName);
					$("#picturePath").val(data.thisNews.titlePicUrl);
					
					$("#moreSummary").val(data.thisNews.summary);
					$("#moreContent").val(data.thisNews.content);
					
					/* $('a[href="#newsMng"]').parent().prop('class', '');
					$("#newsMng").prop("class", "tab-pane fade"); */
				}else{
					//$("#annoId").val(data.thisNews.newsId);
					$("#pubAnno").prop("class", "tab-pane fade in active");
					$('a[href="#pubAnno"]').parent().prop('class', 'active');
					
					$("#annTitle").val(data.thisNews.title);
					$("#annContent").val(data.thisNews.content);
					
				}
				$('a[href="#newsMng"]').parent().prop('class', '');
				$("#newsMng").prop("class", "tab-pane fade");
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				alert("请求内容失败");
			}
		});
	}
	
 	function checkAll(){
		if(!checkAllTrigger){
			$('input[name="news_entry"]').prop('checked',true);
			checkAllTrigger = true;
		}else{
			$('input[name="news_entry"]').prop('checked',false);
			checkAllTrigger = false;
		}
	}
 	
	function batchDeleteFun(){
		$('input[name="news_entry"]').each(function(){
			if($(this).prop("checked")){
				newsArr.push($(this).prop("id"));
			}
		});
		if(newsArr.toString()!= null && newsArr.toString()!= ""){
			if(confirm("确定批量删除？")){
				console.log("newsArr: "+newsArr.toString()+":"+typeof(newsArr));
				batchDeleteAjax();
				newsArr = [];
				getData();
			}
		}else{
			alert("至少选择一个需要删除的条目。");
		}
	}
 	
 	function batchDeleteAjax(){
 		$.ajax({
			type : "POST",
			async : false,
			url : urlPrefix + "/eipNews/batchDelete",
			data : {
				"newsArr" : newsArr.toString()
			},
			dataType : "jsonp", 
			jsonp : "callback",
			//jsonpCallback:"query",
			success : function(data) {
				alert(data.result);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				alert("删除失败："+errorThrown);
			}
		});
 	}
 	
 	function changeState(obj){
 		if(!$(obj).prop('checked')){
 			$(this).prop('checked', false);
 			$("#selectAll").prop('checked', false);
 			checkAllTrigger = false;
 		}else{
 			$(obj).prop('checked', true);
 		}
 	}
	
	function clickFun(obj){
		var id = $(obj).attr("id");
		if(id.substr(0, 8) == "pageSize"){
			pageSize = id.substr(9);
		}else if(id.substr(0, 12) == "timeInterval"){
			if(id.substr(13)=="month"){
				timeInterval = 1;
			}else if(id.substr(13)=="threeMonth"){
				timeInterval = 3;
			}else{
				timeInterval = -1;
			}
		}else if(id.substr(0, 8)== "newsType"){
			if(id.substr(9) == "all"){
				newsType = "ALL";
			}else if(id.substr(9) == "news"){
				newsType = "HEIP_NEWSTYPE_NEWS";
			}else if(id.substr(9) == "anno"){
				newsType = "HEIP_NEWSTYPE_ANNOUNCEMENT";
			}
		}else if( id.substr(0, 11) == "currentPage"){
			page = id.substr(12);
		}else if(id.substr(5)== "first"){
			page = 1;
		}else if(id.substr(5)== "previous"){
			if(page > 1){
				page -= 1;
			}else{
				page = 1;
			}
		}else if(id.substr(5)== "next"){
			if(page < pages){
				page += 1;
			}else{
				page = pages;
			}
		}else if(id.substr(5)== "last"){
			page = pages;
		}
		//alert("page: "+page+", pageSize: "+pageSize+", timeInterval: "+timeInterval);
		
		getData();
	}
	
	function getData(){
		$.ajax({
			//提交数据的类型 POST GET
			type : "GET",
			//表示同步	false true
			async : false,
			//提交的网址
			//url : "http://asc.hand-china.com/eip/api/public/employee/hrmsEmployeeV/queryEmp",
			//http://10.211.110.207:9080/api/public/news/eipNews/query
			url : urlPrefix + "/eipNews/query",
			data : {
				"page" : page ,
				"pageSize" : pageSize,
				"timeInterval": timeInterval,
				"newsType": newsType
			},
			dataType : "jsonp", //"xml", "html", "script", "json", "jsonp", "text".
			//解决跨域问题
			jsonp : "callback",
			//jsonpCallback:"query",
			success : function(data) {
				//alert(JSON.stringify(data));
				html = '';
				htmlTemp = template;
				optionsTemp = options;
				for ( var i=0; i< data.length; i++) {
					if(i == (data.length-1)){
						total = data[i].total;
						pages = Math.ceil(total/pageSize) ;
					}else{
						optionsTemp = optionsTemp.replace("##new_id##",
								data[i].newsId);
						optionsTemp = optionsTemp.replace("##new_id##",
								data[i].newsId);

						htmlTemp = htmlTemp.replace("##new_id##",
								data[i].newsId);
						//alert(options);
						
						htmlTemp = htmlTemp.replace("##signatureName##", data[i].signatureName);
						
						htmlTemp = htmlTemp.replace("##title##",
								data[i].title);
						htmlTemp = htmlTemp.replace("##summary##",
								data[i].summary == null ? ""
										: data[i].summary);
						htmlTemp = htmlTemp.replace("##releaseDate##",
								data[i].releaseDate);
						
						if (data[i].newsType == 'HEIP_NEWSTYPE_NEWS') {
							htmlTemp = htmlTemp.replace("##newsType##", "新闻");
						} else {
							htmlTemp = htmlTemp.replace("##newsType##", "通告");
						}

						if (data[i].releaseStatus == 'NEWS_STATUS_SAVE') {
							htmlTemp = htmlTemp.replace("##status##", "保存");
						} else {
							htmlTemp = htmlTemp
									.replace("##status##", "已发布");
						}
						
						html = html + htmlTemp + optionsTemp
								+ '</td></tr></tbody>';
						optionsTemp = options;
						htmlTemp = template; 
					}
					
				}

				html = '<table id="myTable" border="1" class="table table-bordered table-hover table-striped">'
						+ head + html + '</table>';
				$("#container").html(html);
				
				html = '';
				htmlTemp = template;
				optionsTemp = options;
				
				$("#getEntryNums").html("所有的条目有"+total+"条，当前为第"+page+"页,当前每页显示条数为"+pageSize+"条");
				$("#getPageSize").html(pageSize);
				if(timeInterval==1){
					$("#getTimeInterval").html("显示最近一个月");
				}else if(timeInterval == 3){
					$("#getTimeInterval").html("显示最近三个月内");
				}else{
					$("#getTimeInterval").html("显示所有");
				}
				
				if(newsType == "ALL"){
					$("#getNewsType").html("查询所有");
				}else if(newsType == "HEIP_NEWSTYPE_NEWS"){
					$("#getNewsType").html("查询新闻");
				}else{
					$("#getNewsType").html("查询通告");
				}
				
				var pageTemplate = '<li><a id="currentPage_##page##" href="javascript:void(0)" onclick="clickFun(this)">##page##</a></li>';
				var temp = pageTemplate;
				$("#getPage").html('');
				for(var i= 1; i < pages+1; i++){
					temp = temp.replace("##page##", i.toString());
					temp = temp.replace("##page##", i.toString());
					$("#getPage").html($("#getPage").html()+ temp) ;
					temp = pageTemplate;
				
				}
				
				$("#currentPage").html(page);
				
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$("#container").html(
						"未查询到任何内容！！！" + "errorThrown:" + errorThrown);
			}
		});
	}
	
</script>

<div style="width:50%;float:left;">
	<div class="btn-group" style="float:left; margin-top: 15px;">
		<button type="button" class="btn btn-info dropdown-toggle"
			data-toggle="dropdown">
			当前为第<span id="currentPage"></span>页 <span class="caret"></span>
		</button>
		<ul class="dropdown-menu" role="menu" id="getPage">
		</ul>
	</div>
	
	<div class="btn-group" style="float:left; margin-top: 15px;">
		<button type="button" class="btn btn-info dropdown-toggle"
			data-toggle="dropdown">
			每页显示<span id="getPageSize"></span>条 <span class="caret"></span>
		</button>
		<ul class="dropdown-menu" role="menu">
			<li><a href="javascript:void(0)" onclick="clickFun(this)" id="pageSize_15">15</a></li>
			<li><a href="javascript:void(0)" onclick="clickFun(this)" id="pageSize_30">30</a></li>
			<li><a href="javascript:void(0)" onclick="clickFun(this)" id="pageSize_45">45</a></li>
			<li><a href="javascript:void(0)" onclick="clickFun(this)" id="pageSize_60">60</a></li>
			<li><a href="javascript:void(0)" onclick="clickFun(this)" id="pageSize_75">75</a></li>
		</ul>
	</div>
	<div class="btn-group" style="float:left; margin-top: 15px;">
		<button type="button" class="btn btn-info dropdown-toggle"
			data-toggle="dropdown">
			<span id="getTimeInterval"></span><span class="caret"></span>
		</button>
		
		<ul class="dropdown-menu" role="menu" id="timeInterval">
			<li><a href="javascript:void(0)" onclick="clickFun(this)" id="timeInterval_month" >显示最近一个月</a></li>
			<li><a href="javascript:void(0)" onclick="clickFun(this)" id="timeInterval_threeMonth">显示最近三个月内</a></li>
			<li><a href="javascript:void(0)" onclick="clickFun(this)" id="timeInterval_all">显示所有</a></li>
		</ul>
	</div>
	<div class="btn-group" style="float:left; margin-top: 15px;" >
		<button type="button" class="btn btn-info dropdown-toggle"
			data-toggle="dropdown">
			<span id="getNewsType"></span><span class="caret"></span>
		</button>
		
		<ul class="dropdown-menu" role="menu">
			<li><a href="javascript:void(0)" onclick="clickFun(this)" id="newsType_all" >查询所有</a></li>
			<li><a href="javascript:void(0)" onclick="clickFun(this)" id="newsType_news">查询新闻</a></li>
			<li><a href="javascript:void(0)" onclick="clickFun(this)" id="newsType_anno">查询通告</a></li>
		</ul>
	</div>
	<div class="btn-group" style="float:left; margin-top: 15px;">
		<button type="button" class="btn btn-info" id="batchDelete" onclick="batchDeleteFun()">批量删除</button>
	</div>
	<div style="float:left; margin-top: 15px;"><span id="getEntryNums"></span></div>
</div>
<div style="width:50%; float:right;">
	<ul class="pager lfr-pagination-buttons" style="margin-bottom: 10px; margin-top: 10px;" id="getPagenations">
		<li><a href="javascript:void(0)" id="page_first" onclick="clickFun(this)">← 首页</a></li>
		<li><a href="javascript:void(0)" id="page_previous" onclick="clickFun(this)">上一页 </a></li>
		<li><a href="javascript:void(0)" id="page_next" onclick="clickFun(this)">下一页 </a></li>
		<li><a href="javascript:void(0)" id="page_last" onclick="clickFun(this)">尾页→ </a></li>
	</ul>

</div>


<div id="container"></div>
<div id="test"></div>
<div id="customerPage"
	class="yui3-widget modal yui3-widget-positioned yui3-widget-stacked yui3-widget-modal modal-focused yui3-dd-draggable yui3-resize"
	style="left: 280px; top: 4.31667px; z-index: 1201; height: 100%; width: 100%; display: none;"
	tabindex="0">
</div>

