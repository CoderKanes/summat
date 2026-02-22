package sm.data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/*
 * 작성자 : 김용진
 * 내용 : Oracle DB와의 Connection을 관리하는 유틸리티 클래스.
 */
public class OracleConnection {
	//DB Connection 연결을 얻는다.
	public static Connection getConnection(){
		Connection connection = null;
		try {
			//1. 드라이버 로드
			Class.forName("oracle.jdbc.driver.OracleDriver");
			//2. 연결 (DB접속)		
			//String dburl = "jdbc:oracle:thin:@192.168.219.198:1521:orcl";
			String dburl="jdbc:oracle:thin:@58.73.200.225:1521:orcl"; 
			String user="web1";
			String pw="1234";
			connection = DriverManager.getConnection(dburl, user, pw);
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		}catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return connection;
	}	
	
	//Connection, PreparedStatement의 해제 Method 
	public static void closeAll(Connection cn, PreparedStatement ps){
		closeAll(cn,ps,null);
	}
	//Connection, PreparedStatement, ResultSet의 해제 Method
	public static void closeAll(Connection cn, PreparedStatement ps, ResultSet rs){
		try {
			if(cn!=null)cn.close();
		} catch (SQLException e) {
		}
		try {
			if(ps!=null)ps.close();
		} catch (SQLException e) {
		}
		try {
			if(rs!=null)rs.close();
		} catch (SQLException e) {
		}
	}	
}
