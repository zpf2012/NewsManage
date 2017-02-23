<%@page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%@page import="com.hand.eip.news.ReadConfigFile"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<script src="<%=request.getContextPath()%>/myjs/jquery-1.10.2.min.js"></script>
<script src="<%=request.getContextPath()%>/myjs/bootstrap.min.js"></script>
<link href="<%=request.getContextPath()%>/mycss/bootstrap.min.css" rel="stylesheet">


<portlet:defineObjects />
<link href="<%=request.getContextPath()%>/mycss/NewsMng.css" rel="stylesheet">

<%
	Map<String, String> map = ReadConfigFile.getContent();
	//System.out.println(readConfigFile.getUrlPrefix());
%>