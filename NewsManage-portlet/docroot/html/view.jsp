<%
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
%>

<%@page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>

<%@ include file="/html/init.jsp" %>



<ul id="NATab" class="nav nav-tabs">
    <li class="active"> <a href="#pubNews" data-toggle="tab">发布新闻</a></li>
    <li> <a href="#pubAnno" data-toggle="tab">发布通告</a></li>
    <li> <a href="#newsMng" data-toggle="tab">新闻/通告管理</a></li>
   <!--  <li> <a href="#annoMng" data-toggle="tab">通告管理</a></li> -->

</ul>

<div id="NATabContent" class="tab-content">
    <div class="tab-pane fade in active" id="pubNews">
    	<%@ include file="/html/NewMng/pubNews.jsp"%>
    </div>
    <div class="tab-pane fade" id="pubAnno">
       <%@ include file="/html/NewMng/pubAnno.jsp"%> 
    </div>
    <div class="tab-pane fade" id="newsMng">
       <%--  <%@ include file="/html/NewMng/newsMng.jsp"%> --%>
    </div>
    <%-- <div class="tab-pane fade" id="annoMng">
        <%@ include file="/html/NewMng/annoMng.jsp"%>
    </div> --%>
</div>

<script>
    $(function(){
        $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            // 获取已激活的标签页的名称
            var activeTab = $(e.target).text();
            // 获取前一个激活的标签页的名称
            var previousTab = $(e.relatedTarget).text();
            
            $(".active-tab span").html(activeTab);
            $(".previous-tab span").html(previousTab);
        });
    });
</script>
