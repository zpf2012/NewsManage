package com.hand.eip.news;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.ProcessAction;

import sun.security.krb5.Config;

import com.hand.eip.util.ConnectionFactory;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.repository.model.FileEntry;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.documentlibrary.service.DLAppLocalServiceUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

/**
 * Portlet implementation class NewsManage
 */
public class NewsManage extends MVCPortlet {

	Map<String,String> config = ReadConfigFile.getContent();

	
	@ProcessAction(name = "pubNews")
	public void pubNews(ActionRequest actionRequest,ActionResponse actionResponse) throws IOException, PortalException,SystemException {
		long userId = PortalUtil.getUser(actionRequest).getUserId();
		ServiceContext serviceContext = ServiceContextFactory.getInstance(actionRequest);
		String newTitle = ParamUtil.getString(actionRequest, "newTitle", "无标题");
		String newSignatureName = ParamUtil.getString(actionRequest,"newSignatureName", "无作者");
		String newSummary = ParamUtil.getString(actionRequest, "newSummary","无摘要");
		String newContent = ParamUtil.getString(actionRequest, "newContent","无内容");
		
		String url = "";
		UploadPortletRequest uploadPortletRequest = PortalUtil.getUploadPortletRequest(actionRequest);
		File file = uploadPortletRequest.getFile("morePicture");
		//System.out.println("file" + file);// 服务器上临时文件夹
		String fileName = uploadPortletRequest.getFullFileName("morePicture");
		
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
		String newFileName = df.format(new Date()) + "_" + new Random().nextInt(1000)+fileName;
		
		//System.out.println("fileName" + fileName);// img-test123.jpg
		String mimeType = uploadPortletRequest.getContentType("morePicture");
		//System.out.println("mimeType" + mimeType);// /image/jpeg
		long repositoryId = Long.parseLong(config.get("repositoryId"));
		long folderId = Long.parseLong(config.get("folderId"));
		InputStream is = new FileInputStream(file);
		url = uploadFile(repositoryId, folderId, is,file.length(), newFileName, mimeType,serviceContext);

		String s = NewsManage.post(config.get("serverUrl")+"/api/public/news/eipNews/insertNews","url=" 
				+ url + "&newTitle=" 
				+ newTitle + "&newSignatureName=" 
				+ newSignatureName + "&newSummary=" 
				+ newSummary + "&newContent=" 
				+ newContent + "&userId=" + userId);

		if (s == null) {
			actionRequest.setAttribute("messageNews", "发布新闻成功！");
		}
	}
	
	/**
	 * 
	 * @param actionRequest
	 * @param actionResponse
	 * @throws IOException
	 * @throws PortalException
	 * @throws SystemException
	 */
	@ProcessAction(name = "pubAnno")
	public void toEditAnnounce(ActionRequest actionRequest,ActionResponse actionResponse) throws IOException, PortalException,SystemException {
		long userId = PortalUtil.getUser(actionRequest).getUserId();
		String userName = PortalUtil.getUser(actionRequest).getLastName();
		String title = ParamUtil.getString(actionRequest, "annTitle", "无标题");
		String content = ParamUtil.getString(actionRequest, "annContent","无内容");

		String s = NewsManage.post(config.get("serverUrl")+"/api/public/news/eipNews/insertAnnouncement","title=" 
				+ title + "&content=" 
				+ content + "&userId=" 
				+ userId+ "&userName=" + userName);

		if (s == null) {
			actionRequest.setAttribute("messageAnn", "发布通告成功！");
		}
	}
	
	
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
	  		FileEntry fileEntry = DLAppLocalServiceUtil.addFileEntry(Integer.parseInt(config.get("userId")),repositoryId, folderId, fileName, mimeType, title,description, changeLog, is, size, serviceContext);
	  		
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
			String homeURL = config.get("liferayUrl");					
			long repositoryId = fileEntry.getRepositoryId();
			String uuid = fileEntry.getUuid();
			stringBuffer.append(homeURL+"/documents/"+repositoryId+"/"+Integer.parseInt(config.get("folderId"))+"/"+fileName+"/"+uuid);	
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return stringBuffer.toString();
	}
	
	

	/**
	 * java用post方式与后台HAP进行数据交互
	 * @param urlStr
	 * @param param
	 * @return
	 */
	public static String post(String urlStr, String param) {
		HttpURLConnection conn = null;
		BufferedReader in = null;
		PrintWriter out = null;
		StringBuilder result = new StringBuilder();
		try {
			URL url = new URL(urlStr);
			conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setRequestMethod("POST");
			conn.setUseCaches(false);
			conn.setInstanceFollowRedirects(true);
			conn.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			conn.connect();

			out = new PrintWriter(conn.getOutputStream());
			out.print(param);
			out.flush();
			in = new BufferedReader(
					new InputStreamReader(conn.getInputStream()));
			String line = null;
			while ((line = in.readLine()) != null) {
				result.append(line);
			}
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (conn != null) {
				conn.disconnect();
			}
		}
		return result.toString();
	}

	
}
