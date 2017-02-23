<%@page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../init.jsp"%>

<script type="text/javascript">
	var urlPrefix = '<%=map.get("urlPrefix")%>';
	var total = '<%=request.getAttribute("total") %>';
	var head = '<thead class="table-columns"><tr><th><input id="selectAll" onclick="checkAll()" type="checkbox"/></th><th class="table-first-header" width="400px">标题</th><th width="200px">摘要</th><th>发布日期</th><th>发布人</th><th>当前状态</th><th>操作</th></tr></thdea>';

	var options = '<a href="'+urlPrefix+'/view?id=##new_id##">预览</a>&nbsp;&nbsp;<a href="'+urlPrefix+'/edit?id=##new_id##">编辑</a>';
	//var options = '<a href="/view/##new_id##">预览</a>&nbsp;&nbsp;<a href="/edit/##new_id##">编辑</a>&nbsp;&nbsp;<a href="/delete/##new_id##">删除</a>';
	var template = '<tbody class="table-data"><tr><td><input id="new_id_##new_id##" name="news_entry" type="checkbox"/></td><td>##title##</td><td>##summary##</td><td>##releaseDate##</td><td>##signatureName##</td><td>##status##</td><td>';

	//初始化参数
	var page = 1;
	var pageSize = 15;		//每页显示条数：共有五种参数： 15， 30， 45， 60， 75
	var timeInterval = "month";  //查看区间：共有三种参数： month， threeMonth, all
	var pages = 0;
	$(function() {
		
		getData();

		$("#test").html('<a href="'+urlPrefix+'/eipNews/query?page=1&pageSize=15">查看数据</a>');
		/*  $("#view").on('click', function() {
			$("#customerPage").show();
			return false;
		}); */

		$("#customerPage").hide();

		var getPageChildren =  $("#getPage").children('li');
		/* $("#getPage").children('li').children('a').on('click', function(){ 
		});*/
		page = getPageChildren.children('a').attr("id").substr(5);
		alert(page);
		
	});
	var checkAllTrigger = false;
	
/* 	function checkAll(){
		if(!checkAllTrigger){
			$('input[name="news_entry"]').attr('checked','checked');
			checkAllTrigger = true;
		}else{
			$('input[name="news_entry"]').attr('checked','undefined');
			checkAllTrigger = false;
		}
	} */
	
	function clickFun(obj){
		var id = $(obj).attr("id");
		if(id.substr(0, 8) == "pageSize"){
			pageSize = id.substr(9);
		}else if(id.substr(0, 12) == "timeInterval"){
			timeInterval = id.substr(13);
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
				"timeInterval": timeInterval
			},
			dataType : "jsonp", //"xml", "html", "script", "json", "jsonp", "text".
			//解决跨域问题
			jsonp : "callback",
			//jsonpCallback:"query",
			success : function(data) {
				//alert(JSON.stringify(data));
				var html = '';
				var htmlTemp = template;
				var optionsTemp = options;
				for ( var i in data) {
					pages = Math.ceil(data.length/pageSize) ;
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

				html = '<table id="myTable" border="1" class="table table-bordered table-hover table-striped">'
						+ head + html + '</table>';
				$("#container").html(html);
				$("#getEntryNums").html("所有的条目有"+total+"条，当前为第"+page+"页,当前每页显示条数为"+pageSize+"条");
				$("#getPageSize").html(pageSize);
				if(timeInterval=='month'){
					$("#getTimeInterval").html("显示最近一个月");
				}else if(timeInterval == 'threeMonth'){
					$("#getTimeInterval").html("显示最近三个月内");
				}else{
					$("#getTimeInterval").html("显示所有");
				}
				
				var pageTemplate = '<li><a id="currentPage_##page##" href="javascript:void(0)" onclick="clickFun(this)">##page##</a></li>';
				var temp = pageTemplate;
				$("#getPage").html('');
				for(var i= 1; i < total+1; i++){
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
<!-- <div class="btn-group lfr-icon-menu current-page-menu">
<a class="dropdown-toggle direction-down max-display-items-15 btn" title="页码" aria-haspopup="true" role="button"><span class="lfr-icon-menu-text">页码</span><i class="caret"></i> </a>
</div> -->
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

