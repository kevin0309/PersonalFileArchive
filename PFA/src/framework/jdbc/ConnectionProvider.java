package framework.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;

import javax.sql.DataSource;

import framework.init.ServerConfig;

/**
 * DBCP에서 커넥션을 받아오는 클래스
 * @author 박유현
 * @since 2019.11.11
 */
public class ConnectionProvider {

	/**
	 * 현재 만들어진 DBCP에서 Connection을 받아오는 메서드
	 * @return
	 * @throws ConnectDBException
	 */
	public static Connection getConnection() {
		if (ServerConfig.isUseJNDI()) {
			DataSource ds = DBInitListener.getDataSource();
			try {
				return ds.getConnection();
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
		else {
			try {
				String poolAddr = DBInitListener.getDbcpAddr();
				return DriverManager.getConnection(poolAddr);
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}
}
