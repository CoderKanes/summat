package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class InfluencerRequestDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	String Sql = "";
	
	//싱글톤
	private static InfluencerRequestDAO instance = new InfluencerRequestDAO();
	
	public static InfluencerRequestDAO getInstance() {
		return instance;
	}//싱글통 end
	
	//생성자 숨김
	private InfluencerRequestDAO() {
		
	}
	
	//insert
	public void influencerRequestInsert(InfluencerRequestDTO dto) {
		try {
			conn = OracleConnection.getConnection();
			Sql = "insert into influencer_request (id, user_id, requested_grade, reason, sns_urls, status, requested_at, admin_note) values(influencer_request_seq.nextval, ?, ?, ?, ?, ?, sysdate, ?)";
			pstmt = conn.prepareStatement(Sql);
			pstmt.setString(1, dto.getUser_id());
			pstmt.setInt(2, dto.getRequested_grade());
			pstmt.setString(3, dto.getReason());
			pstmt.setString(4, dto.getSns_urls());
			pstmt.setString(5, dto.getStatus());
			pstmt.setString(6, dto.getAdmin_note());
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
	}//insert end
	
}
