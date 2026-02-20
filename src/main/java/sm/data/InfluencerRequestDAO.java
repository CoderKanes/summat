package sm.data;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;



public class InfluencerRequestDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	String sql = "";
	
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
			sql = "insert into influencer_request (id, user_id, requested_grade, reason, sns_urls, requested_at) values(influencer_request_seq.nextval, ?, ?, ?, ?, sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUser_id());
			pstmt.setInt(2, dto.getRequested_grade());
			pstmt.setString(3, dto.getReason());
			pstmt.setString(4, dto.getSns_urls());
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
	}//insert end
	
	//인플루언서 신청자 명단
	public List<InfluencerRequestDTO> getRequeList(String user_id, String status, int start, int end) {
	    List<InfluencerRequestDTO> list = new ArrayList<>();
	    try {
	        conn = OracleConnection.getConnection();
	        StringBuilder sb = new StringBuilder();
	        sb.append("select * from (");
	        sb.append(" select a.*, rownum r from (");
	        sb.append("  select * from influencer_request");
	        sb.append("  where 1=1");
	        if (user_id != null && !user_id.isEmpty()) {
	            sb.append(" and user_id = ?");
	        }
	        if (status != null && !status.isEmpty()) {
	            sb.append(" and status = ?");
	        }
	        sb.append("  order by requested_at desc");
	        sb.append(" ) a where rownum <= ?");
	        sb.append(") where r >= ?");
	        sql = sb.toString();

	        pstmt = conn.prepareStatement(sql);
	        int index = 1;
	        if (user_id != null && !user_id.isEmpty()) {
	            pstmt.setString(index++, user_id);
	        }
	        if (status != null && !status.isEmpty()) {
	            pstmt.setString(index++, status);
	        }
	        pstmt.setInt(index++, end);   // 먼저 end
	        pstmt.setInt(index++, start); // 그 다음 start

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            InfluencerRequestDTO dto = new InfluencerRequestDTO();
	            dto.setId(rs.getInt("id"));
	            dto.setUser_id(rs.getString("user_id"));
	            dto.setRequested_grade(rs.getInt("requested_grade"));
	            dto.setReason(rs.getString("reason"));
	            dto.setSns_urls(rs.getString("sns_urls"));
	            dto.setStatus(rs.getString("status"));
	            dto.setRequested_at(rs.getTimestamp("requested_at"));
	            dto.setProcessed_by(rs.getString("processed_by"));
	            dto.setProcessed_at(rs.getTimestamp("processed_at"));
	            dto.setAdmin_note(rs.getString("admin_note"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        OracleConnection.closeAll(conn, pstmt, rs);
	    }
	    return list;
	}//end
	
	//인증 대기 수량
	public int getInfluencerRequestCountByStatus(String status) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			sql = "select count(*) as c from influencer_request where status = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, status);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt("c");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	//총 신청자 수 
	public int getRequestCount(String user_id, String status) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			StringBuilder sb = new StringBuilder();
			sb.append("select count(*) c from  influencer_request where 1=1");
			if(user_id != null && user_id.trim().isEmpty()) {
				sb.append("and user_id = ?");
			}
			if(status != null && status.trim().isEmpty()) {
				sb.append("and status = ?");
			}
			
			sql = sb.toString();
			
			pstmt = conn.prepareStatement(sql);
			
			int index = 1; 
			if(user_id != null && user_id.trim().isEmpty()) {
				pstmt.setString(index++, user_id);
			}
			if(status != null && status.trim().isEmpty()) {
				pstmt.setString(index++, status);
			}
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				result = rs.getInt("c");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}//end
	
	//단건 승인
	public int changeRequestStatus(String user_id, String status, String processedBy, String adminNote) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			sql = "update influencer_request set status = ?, processed_by = ? , processed_at = sysdate, admin_note = ? where user_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, status);
			pstmt.setString(2, processedBy);
			pstmt.setString(3, adminNote);
			pstmt.setString(4, user_id);
			
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}//end
	
	//id로 승인 체크박스 여러개 일 경우
	// ====== [추가] id 기반 상태 변경 (일괄 처리용) ======
	public int changeRequestStatusById(int id, String status, String processedBy, String adminNote) {
	    int result = 0;
	    try {
	        conn = OracleConnection.getConnection();
	        sql = "UPDATE influencer_request SET status = ?, processed_by = ?, processed_at = SYSDATE, admin_note = ? WHERE id = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, status);
	        pstmt.setString(2, processedBy);
	        pstmt.setString(3, adminNote);
	        pstmt.setInt(4, id);
	        result = pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        OracleConnection.closeAll(conn, pstmt, rs);
	    }
	    return result;
	}//end
	
	//모두 승인
	public int approveAllPending(String processedBy, String adminNote) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			sql = "update influencer_request set status = 'APPROVED', processed_by = ?, processed_at = sysdate, admin_note = ? where status = 'PENDING'";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, processedBy);
			pstmt.setString(2, adminNote);
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}//end
	
	/*
	//거절
	public int changeRequestToRejected(String user_id, String processedBy, String adminNote) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			sql = "update influencer_request set status = 'REJECTED' processed_by = ?, processed_at = sysdate, admin_note = ? where user_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, processedBy);
			pstmt.setString(2, adminNote);
			pstmt.setString(3, user_id);
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	*/
}
