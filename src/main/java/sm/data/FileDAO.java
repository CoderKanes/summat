package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/*
 * 작성자 : 김용진
 * 내용 : 업로드 되는 파일정보를 관리하는 DB용 DAO 
 */

public class FileDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public enum FileStatus{
		TEMP,
		INUSE,
	    UNUSED
	}


	// fetch에 의해 임시 file업로드시 file정보를 기록한다. 
	public boolean uploadTempFile(String filePath) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();
			String sql = "insert into file_info (filePath, status) values(?,0)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, filePath);

			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}	
	
	public boolean updateFileStatus(String filePath, FileStatus status) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();

			String sql = "update file_info set status = ?, updated_at = sysdate WHERE filePath = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, status.ordinal());
			pstmt.setString(2, filePath);
			
			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	// 유효하지 않은 file정보들(제거해야할 파일 리스트) 리턴해주고, DB에서 삭제. 
	public List<String> getCleanupFileList() {
		List<String> result = new ArrayList<String>();
		try {
			conn = OracleConnection.getConnection();
			
			String sql = "select * from file_info WHERE status != 1 and updated_at < sysdate - 1";
			pstmt = conn.prepareStatement(sql);		
			
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				result.add(rs.getString("filePath"));
			}
			
			sql = "delete from file_info WHERE status != 1 and updated_at < sysdate - 1";
			pstmt = conn.prepareStatement(sql);

			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

}
