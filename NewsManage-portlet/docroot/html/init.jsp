<%@page import="java.util.Map"%>
<%@page import="com.hand.eip.news.ReadConfigFile"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme" %>


<portlet:defineObjects />
<theme:defineObjects />
<portlet:defineObjects />

<link href="<%=request.getContextPath()%>/css/NewsMng.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/pubNews.css" />

<!-- pubNews.jsp -->
<link rel="stylesheet" href="<%=request.getContextPath() %>/kindeditor/themes/default/default.css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/kindeditor/plugins/code/prettify.css" />

<script type="text/javascript" charset="UTF-8" src="<%=request.getContextPath()%>/js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" charset="UTF-8" src="<%=request.getContextPath()%>/js/bootstrap.min.js"></script> 

<!-- pubNews.jsp -->
<script charset="utf-8" src="<%=request.getContextPath() %>/kindeditor/kindeditor.js"></script>
<script charset="utf-8" src="<%=request.getContextPath() %>/kindeditor/lang/zh_CN.js"></script>
<script charset="utf-8" src="<%=request.getContextPath() %>/kindeditor/plugins/code/prettify.js"></script>


<%
	Map<String, String> map = ReadConfigFile.getContent();
	//System.out.println(readConfigFile.getUrlPrefix());
%>