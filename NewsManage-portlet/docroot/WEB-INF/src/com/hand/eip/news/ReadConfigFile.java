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
			map.put("urlPrefix", urlPrefix);
			
			resourceAsStream.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return map;
	}
	
}
