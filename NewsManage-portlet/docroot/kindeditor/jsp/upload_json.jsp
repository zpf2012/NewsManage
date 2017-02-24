<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.kernel.util.MimeTypesUtil"%>
<%@page import="com.liferay.portlet.documentlibrary.service.DLAppServiceUtil"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.liferay.portal.kernel.upload.UploadPortletRequest"%>
<%@page import="com.liferay.portal.service.ServiceContextFactory"%>
<%@page import="com.liferay.portal.service.ServiceContext"%>
<%@page import="com.hand.eip.util.ConnectionFactory" %>
<%@page import="com.liferay.portal.kernel.exception.SystemException"%>
<%@page import="com.liferay.portal.kernel.exception.PortalException"%>
<%@page import="com.liferay.portlet.documentlibrary.service.DLAppLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.repository.model.FileEntry"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.json.simple.*" %>
<%@page import="com.hand.eip.news.ReadConfigFile"%>

<%

	/**
	 * KindEditor JSP
	 * 
	 * 本JSP程序是演示程序，建议不要直接在实际项目中使用。
	 * 如果您确定直接使用本程序，使用之前请仔细确认相关安全设置。
	 * 
	 */

	Map<String,String> configMap = ReadConfigFile.getContent();

/* 	long userId = ServiceContextFactory.getInstance(request).getUserId();
	System.out.print("============"+userId); */
	//定义允许上传的文件扩展名
	HashMap<String, String> extMap = new HashMap<String, String>();
	extMap.put("image", "gif,jpg,jpeg,png,bmp");
	extMap.put("flash", "swf,flv");
	extMap.put("media", "swf,flv,mp3,wav,wma,wmv,mid,avi,mpg,asf,rm,rmvb");
	extMap.put("file", "doc,docx,xls,xlsx,ppt,htm,html,txt,zip,rar,gz,bz2");
	
	//最大文件大小2M
	/* long maxSize = 1000000; */
	long maxSize = 2000000;
	
	response.setContentType("text/html; charset=UTF-8");
	
	if(!ServletFileUpload.isMultipartContent(request)){
		out.println(getError("请选择文件。"));
		return;
	}
	
	String dirName = request.getParameter("dir"); 
	
	FileItemFactory factory = new DiskFileItemFactory();
	ServletFileUpload upload = new ServletFileUpload(factory);
	upload.setHeaderEncoding("UTF-8");
	List items = upload.parseRequest(request);
	Iterator itr = items.iterator();
	
	/* 遍历文档 */
	while (itr.hasNext()) {
	 	FileItem item = (FileItem) itr.next();
		String fileName = item.getName();
		
		if (!item.isFormField()) {
			
			//检查文件大小
			if(item.getSize() > maxSize){
				out.println(getError("上传文件大小超过限制。"));
				return;
			}
			
			//检查扩展名
			String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
			if(!Arrays.<String>asList(extMap.get(dirName).split(",")).contains(fileExt)){
				out.println(getError("上传文件扩展名是不允许的扩展名。\n只允许" + extMap.get(dirName) + "格式。"));
				return;
			}
			
			SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
			String newFileName = df.format(new Date()) + "_" + new Random().nextInt(1000) + "." + fileExt;
			
			try{
				InputStream is = item.getInputStream();
				long size = item.getSize();
			 	ServiceContext serviceContext = ServiceContextFactory.getInstance(request);
				String mimeType = MimeTypesUtil.getContentType(fileName);
				
 				String saveUrl= uploadFile(Integer.parseInt(configMap.get("repositoryId")),
 						Integer.parseInt(configMap.get("folderId")), is ,size,newFileName, mimeType,  serviceContext);
/* 				String saveUrl= uploadFile(20182,321425, is ,size,newFileName, mimeType,  serviceContext);
 */
				if(saveUrl.length()<1||saveUrl == null){
					out.println(getError("上传文件失败。"));
					return;
				}
				JSONObject obj = new JSONObject();
				obj.put("error", 0);
				obj.put("url", saveUrl);
				out.println(obj.toJSONString());
			}catch(Exception e){
				out.println(getError("上传文件失败。"));
				return;
			}			
		}
	
	}
	%>
	
	
	<%!
	Map<String,String> configMap = ReadConfigFile.getContent();
	/**
	 * 上传新闻或通告图片
	 * 
	 * @param request
	 * @param response
	 */
	public String uploadFile(long repositoryId, long folderId, InputStream is,long size,
			String fileName, String mimeType, ServiceContext serviceContext){
			String URL = "";
		    repositoryId =	serviceContext.getScopeGroupId();
		    long userId = serviceContext.getUserId();
		try {
			String description = "新闻/通告图片";
			String changeLog = "[UploadFile]" + fileName;
			String title = fileName;
			String[] filePermission = { "ADD_DISCUSSION", "VIEW" };
			serviceContext.setGroupPermissions(filePermission);
	  		FileEntry fileEntry = DLAppLocalServiceUtil.addFileEntry(Integer.parseInt(configMap.get("userId")),repositoryId, folderId, fileName, mimeType, title,description, changeLog, is, size, serviceContext);
	  		
	/*  		FileEntry fileEntry = DLAppServiceUtil.addFileEntry(repositoryId, folderId, fileName, mimeType,title, description, "", is, size, serviceContext);
	 */ 		
			URL = getURL(fileEntry);

		} catch (PortalException e) {
			e.printStackTrace();
		} catch (SystemException e) {
			e.printStackTrace();
		}
		return URL;
	}	
	
	/**
	 * 获取文件的下载链接
	 * 
	 * @param groupId
	 * @param folderId
	 * @param title
	 * @return
	 */
	public String getURL(FileEntry fileEntry) {
		StringBuffer stringBuffer = new StringBuffer();
		try {
			String fileName = java.net.URLEncoder.encode(fileEntry.getTitle(),"utf-8");
			String homeURL = configMap.get("liferayUrl");
			
			
			System.out.print(configMap);
			long repositoryId = fileEntry.getRepositoryId();
			String uuid = fileEntry.getUuid();
			stringBuffer.append(homeURL+"/documents/"+repositoryId+"/"+Integer.parseInt(configMap.get("folderId"))+"/"+fileName+"/"+uuid);	
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return stringBuffer.toString();
	}
	
	
	private String getError(String message) {
		JSONObject obj = new JSONObject();
		obj.put("error", 1);
		obj.put("message", message);
		return obj.toJSONString();
	}
	%>