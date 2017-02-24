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
	public void toEditNews(ActionRequest actionRequest,ActionResponse actionResponse) throws IOException, PortalException,SystemException {
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
		//System.out.println("fileName" + fileName);// img-test123.jpg
		String mimeType = uploadPortletRequest.getContentType("morePicture");
		//System.out.println("mimeType" + mimeType);// /image/jpeg
		long repositoryId = 20182;
		long folderId = 321425;
		url = uploadFile(repositoryId, folderId, file, fileName, mimeType,serviceContext);
		//System.out.println("url:" + url);

		String s = NewsManage.post(config.get("serverUrl")+"/eip/api/public/news/eipNews/insertNews","url=" 
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
	 * 上传图片到liferay的文档媒体库
	 * @param repositoryId
	 * @param folderId
	 * @param file
	 * @param fileName
	 * @param mimeType
	 * @param serviceContext
	 * @return
	 */
	public String uploadFile(long repositoryId, long folderId, File file,
			String fileName, String mimeType, ServiceContext serviceContext) {
		String URL = "";
		try {
			String description = "Upload InstallPKG";
			String changeLog = "[UploadFile]" + file.getName();
			InputStream is = new FileInputStream(file);
			String sourceFileName = fileName;
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	        String time = sdf.format(new  Date());
			String title = fileName+time;
			//System.out.println(title);
			long size = file.length();
			String[] filePermission = { "ADD_DISCUSSION", "VIEW" };
			serviceContext.setGroupPermissions(filePermission);
			FileEntry fileEntry = DLAppLocalServiceUtil.addFileEntry(20199,repositoryId, folderId, sourceFileName, mimeType, title,description, changeLog, is, size, serviceContext);
			URL = getURL(fileEntry);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (PortalException e) {
			e.printStackTrace();
		} catch (SystemException e) {
			e.printStackTrace();
		}
		return URL;
	}

	/**
	 * 获取文件的下载链接
	 * @param groupId
	 * @param folderId
	 * @param title
	 * @return
	 */
	public String getURL(FileEntry fileEntry) {
		StringBuffer stringBuffer = new StringBuffer();
		try {
			String fileName = java.net.URLEncoder.encode(fileEntry.getTitle(),"utf-8");
			Properties properties = new Properties();
			InputStream in = ConnectionFactory.class.getClassLoader().getResourceAsStream("config.properties");
			properties.load(in);
			String homeURL = properties.getProperty("liferayUrl");
			long repositoryId = fileEntry.getRepositoryId();
			String treePath = "/321425/";
			String uuid = fileEntry.getUuid();

			stringBuffer.append(homeURL);
			stringBuffer.append("/");
			stringBuffer.append("documents");
			stringBuffer.append("/");
			stringBuffer.append(repositoryId);
			stringBuffer.append(treePath);
			stringBuffer.append(fileName);
			stringBuffer.append("/");
			stringBuffer.append(uuid);

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
