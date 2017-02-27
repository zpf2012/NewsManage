<%@page import="java.util.Map"%>
<%@page import="com.hand.eip.news.ReadConfigFile"%>

<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>  
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Timestamp"%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme" %>

<theme:defineObjects/>
<portlet:defineObjects />
<link href="<%=request.getContextPath()%>/css/NewsMng.css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/pubNews.css" rel="stylesheet">


<link rel="stylesheet" href="<%=request.getContextPath() %>/kindeditor/themes/default/default.css" />
<link rel="stylesheet" href="<%=request.getContextPath() %>/kindeditor/plugins/code/prettify.css" />
<script charset="utf-8" src="<%=request.getContextPath() %>/kindeditor/kindeditor.js"></script>
<script charset="utf-8" src="<%=request.getContextPath() %>/kindeditor/lang/zh_CN.js"></script>
<script charset="utf-8" src="<%=request.getContextPath() %>/kindeditor/plugins/code/prettify.js"></script>

<script src="<%=request.getContextPath()%>/js/jquery-1.10.2.min.js"></script>
<%-- <link href="<%=request.getContextPath()%>/css/bootstrap.min.css" rel="stylesheet"> --%>
<script src="<%=request.getContextPath()%>/js/bootstrap.min.js"></script>



<%
	Map<String, String> map = ReadConfigFile.getContent();
	//System.out.println(readConfigFile.getUrlPrefix());
%>