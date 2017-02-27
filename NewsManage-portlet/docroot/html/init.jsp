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
<script src="<%=request.getContextPath()%>/js/jquery-1.10.2.min.js"></script>
<%-- <link href="<%=request.getContextPath()%>/css/bootstrap.min.css" rel="stylesheet"> --%>
<script src="<%=request.getContextPath()%>/js/bootstrap.min.js"></script>


<portlet:defineObjects />
<link href="<%=request.getContextPath()%>/css/NewsMng.css" rel="stylesheet">

<%
	Map<String, String> map = ReadConfigFile.getContent();
	//System.out.println(readConfigFile.getUrlPrefix());
%>