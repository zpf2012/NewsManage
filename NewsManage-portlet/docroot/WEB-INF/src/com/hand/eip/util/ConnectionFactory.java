package com.hand.eip.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

//JDBC数据库配置信息
public class ConnectionFactory {

	private static String oracleDriver;
	private static String oracleDburl;
	private static String oracleUser;
	private static String oraclePassword;

	static {
		Properties prop = new Properties();
		InputStream in = null;
		try {
			in = ConnectionFactory.class.getClassLoader().getResourceAsStream(
					"/config.properties");
			prop.load(in);
			// 初始化Oracle数据库配置信息
			oracleDriver = prop.getProperty("jdbc.default.driverClassName");
			oracleDburl = prop.getProperty("jdbc.default.url");
			oracleUser = prop.getProperty("jdbc.default.username");
			oraclePassword = prop.getProperty("jdbc.default.password");

			// 初始化MySQL数据库配置信息
			// localDriver = prop.getProperty("localDriver");
			// localDburl = prop.getProperty("localDburl");
			// localUser = prop.getProperty("localUser");
			// localPassword = prop.getProperty("localPassword");

			// 初始化Liferay配置信息
			// liferayUrl = prop.getProperty("liferayUrl");
			// liferayUser = prop.getProperty("liferayUser");
			// liferayPasswd = prop.getProperty("liferayPasswd");

			in.close();
		} catch (IOException e) {
			System.out.println("数据库配置文件读取失败");
			e.printStackTrace();
		} finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public static Connection getConnection() {
		Connection conn = null;
		try {
			Class.forName(oracleDriver);
			conn = DriverManager.getConnection(oracleDburl, oracleUser,
					oraclePassword);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return conn;
	}

	public static void close(Connection conn, Statement preparement,
			ResultSet resultSet) {
		try {
			if (resultSet != null) {
				resultSet.close();
			}
			if (preparement != null) {
				preparement.close();
			}
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
