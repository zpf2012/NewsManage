package com.hand.eip.news;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class ReadConfigFile {
	
	public static Map<String, String> getContent(){
		Map<String, String> map = new HashMap<String, String>();
		InputStream resourceAsStream = ReadConfigFile.class.getClassLoader().getResourceAsStream("/config.properties");
		Properties properties = new Properties();
		try {
			properties.load(resourceAsStream);
			String urlPrefix = properties.getProperty("HapRequestURLPrefix");
			String liferayUrl = properties.getProperty("liferayUrl");
			String dbDriver = properties.getProperty("jdbc.default.driverClassName");
			String dbURL = properties.getProperty("jdbc.default.url");
			String dbUserName = properties.getProperty("jdbc.default.username");
			String dbPassword = properties.getProperty("jdbc.default.password");
			
			map.put("urlPrefix", urlPrefix);
			map.put("liferayUrl", liferayUrl);
			map.put("dbDriver", dbDriver);
			map.put("dbURL", dbURL);
			map.put("dbUserName", dbUserName);
			map.put("dbPassword", dbPassword);
			
			
			resourceAsStream.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return map;
	}
	
}
