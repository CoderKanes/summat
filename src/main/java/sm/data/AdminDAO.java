package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
	//변수 선언
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	String sql = "";
	
	//싱글톤
	private static AdminDAO instance = new AdminDAO();
	
	public static AdminDAO getInstance(){
		return instance;
	}//생성자 끝
	
	public List<AdminDTO> getMemberList() {
		List<AdminDTO> list = new ArrayList<AdminDTO>();
		try {
			conn = OracleConnection.getConnection();
			sql = "select * from members";
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				//dto 생성
				AdminDTO dto = new AdminDTO();
				//dto에 가져온 값 넣기
				dto.setUser_id(rs.getString("user_id"));
				dto.setUsername(rs.getString("username"));
				dto.setEmail(rs.getString("email"));
				dto.setPhone(rs.getString("phone"));
				dto.setAddress(rs.getString("address"));
				dto.setResident_registration_number(rs.getString("resident_registration_number"));
				dto.setPassword_hash(rs.getString("password_hash"));
				dto.setPassword_salt(rs.getString("password_salt"));
				dto.setUser_status(rs.getString("user_status"));
				dto.setEmail_verified(rs.getInt("email_verified"));
				dto.setPhone_verified(rs.getInt("phone_verified"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				dto.setUpdated_at(rs.getTimestamp("updated_at"));
				dto.setLast_login_at(rs.getTimestamp("last_login_at"));
				dto.setPassword_changed_at(rs.getTimestamp("password_changed_at"));
				dto.setGrade(rs.getInt("grade"));
				
				list.add(dto);
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		
		return list;
	}//MemberList end
	
	public List<AdminDTO> getMemberList(int start, int end) {
		List<AdminDTO> list = new ArrayList<AdminDTO>();
		
		try {
			conn = OracleConnection.getConnection();
			//		3. r>= a <=의 형태로 꺼내, 2. a의 모든 컬럼과 임시 순번 r의 번호를 꺼내, 1. 멤버스 테이블에서 모든 컬럼을 선택해 만든 날짜 순으로 정렬해서 a에 담고											
			sql = "select * from (select a.*, rownum r from (select * from members order by created_at desc) a) where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			
			rs = pstmt.executeQuery();
			//DTO에서 꺼내 뿌려라
			while(rs.next()) {
				//dto 생성
				AdminDTO dto = new AdminDTO();
				//dto에 가져온 값 넣기
				dto.setUser_id(rs.getString("user_id"));
				dto.setUsername(rs.getString("username"));
				dto.setEmail(rs.getString("email"));
				dto.setPhone(rs.getString("phone"));
				dto.setAddress(rs.getString("address"));
				dto.setResident_registration_number(rs.getString("resident_registration_number"));
				dto.setPassword_hash(rs.getString("password_hash"));
				dto.setPassword_salt(rs.getString("password_salt"));
				dto.setUser_status(rs.getString("user_status"));
				dto.setEmail_verified(rs.getInt("email_verified"));
				dto.setPhone_verified(rs.getInt("phone_verified"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				dto.setUpdated_at(rs.getTimestamp("updated_at"));
				dto.setLast_login_at(rs.getTimestamp("last_login_at"));
				dto.setPassword_changed_at(rs.getTimestamp("password_changed_at"));
				dto.setGrade(rs.getInt("grade"));
				
				list.add(dto);
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		
		
		return list;
	}//end
	
	public int getAllCount() {
		int count = 0;
		try {
			conn = OracleConnection.getConnection();
			sql = "select count(*) as count from members";
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				count = rs.getInt("count");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return count;
	}//getAllcount end
	
}//AdminDAO end
