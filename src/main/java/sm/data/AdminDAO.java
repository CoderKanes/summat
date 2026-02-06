package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
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
	
	//검색 필터링을 위한 화이트 리스트(Arrays.asList = 크기가 고정된 리스트 변형 불가)
	private static final List<String> ALLOWED_SORT_FIELDS = Arrays.asList(
			"created_at", "user_id", "username", "grade", "user_status"
			);
	
	//검색 가능한 회원 목록
	public List<AdminDTO> getMemberList(int start, int end, String sortField, String sortDir, String searchQuery) {
		List<AdminDTO> list = new ArrayList<AdminDTO>();
		
		//기본 검색 필드
		String field = "created_at";
		//기본 정렬 방식
		String dir = "desc";
		
		if(sortField != null && ALLOWED_SORT_FIELDS.contains(sortField)) {
			field = sortField;
		}
		
		if("asc".equalsIgnoreCase(sortDir) || "desc".equalsIgnoreCase(sortDir)) {
			dir = sortDir.toLowerCase();
		}
		
		try {
			conn = OracleConnection.getConnection();
			//StringBuilder 사용
			StringBuilder sql = new StringBuilder();
			
			sql.append("select * from (");
			sql.append("select a.*, rownum r from (");
			sql.append("select * from members ");
			
			if(searchQuery != null && !searchQuery.trim().isEmpty()) {
				sql.append("where user_id like ? or username like ?");
			}
			
			sql.append("order by ");
			sql.append(field);
			sql.append(" ");
			sql.append(dir);
			
			sql.append(") a) where r >= ? and r <= ?");
			
			//select *from(select a.*, rownum r from(select * from members where user_id like ? or username like ? order by + field + dir +) a) where r >= ? and r <= ?
			pstmt = conn.prepareStatement(sql.toString());
			
			int paramIndex = 1;
			if(searchQuery != null && !searchQuery.trim().isEmpty()) {
				String q = "%" + searchQuery + "%";
				pstmt.setString(paramIndex ++, q);
				pstmt.setString(paramIndex ++, q);
			}
			pstmt.setInt(paramIndex ++, start + 1);
			pstmt.setInt(paramIndex ++, end);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				AdminDTO dto = new AdminDTO();
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
	
	//검색 기능 반영 총 카운트
	public int getAllCount(String searchQuery) {
		int count = 0;
		try {
			conn = OracleConnection.getConnection();
			sql = "select count(*) as count from members";
			
			if(searchQuery != null && !searchQuery.trim().isEmpty()) {
				sql += " where user_id like ? or username like ?";
			}
			
			pstmt = conn.prepareStatement(sql);
			
			if(searchQuery != null && !searchQuery.trim().isEmpty()) {
				String q = "%" + searchQuery + "%";
				pstmt.setString(1, q);
				pstmt.setString(2, q);
			}
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
	}//end
	
	//회원 목록
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
	
	//회원 리스트 페이징 메서드
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

	/*
	//총 회원 수 
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
	*/
	
	//회원 강제 탈퇴(상태변경)
	public boolean adminDeactivated(String user_id, String user_status) {
		boolean result = false;
		try {
			conn = OracleConnection.getConnection();
			sql = "update members set user_status = ?, updated_at = current_date where user_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_status);
			pstmt.setString(2, user_id);
			
			int update = pstmt.executeUpdate();
			
			if(update > 0) {
				result = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}//Deactivated end
	
	//회원 등급 부여
	public int setGrade(String user_id, int grade) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			sql = "update members set grade = ? where user_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, grade);
			pstmt.setString(2, user_id);
			
			//result  = 1 or 0
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		
		return result;
	}//setGrade end
	
	public int deleteUser(String user_id) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			sql = "delete from members where user_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);
			
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
}//AdminDAO end
