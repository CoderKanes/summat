package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MemberDAO {
	//변수 선언
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	String sql = "";
	
	//싱글톤 
	private static MemberDAO instance = new MemberDAO();
	
	public static MemberDAO getInstance() {
		return instance;
	}//싱글톤 end
	
	//생성자 숨김
	private MemberDAO() {
		
	}//end
	
	//insert
	public void insert(MemberDTO dto) {
		try {
			conn = OracleConnection.getConnection();
			sql = "insert into members (user_id, username, email, phone, address, resident_registration_number, password_hash, password_salt, created_at) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUser_id());
			pstmt.setString(2, dto.getUsername());
			pstmt.setString(3, dto.getEmail());
			pstmt.setString(4, dto.getPhone());
			pstmt.setString(5, dto.getAddress());
			pstmt.setString(6, dto.getResident_registration_number());
			pstmt.setString(7, dto.getPassword_Hash());
			pstmt.setString(8, dto.getPassword_salt());
			pstmt.setTimestamp(9, dto.getCreated_at());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		
		
	}//insert end
	
	//프로필 이미지 처리
	//디폴트 이미지와 이미지 업로드 처리
	public void profile(String user_id, String profile_image_url) {
		//테이블 검색 후 결과가 나오면 업뎃 없으면 인서트
		try {
			conn = OracleConnection.getConnection();
			sql = "select * from members where user_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);
			rs = pstmt.executeQuery();
			
			//결과 값이 있으면 업데이트
			if(rs.next()) {
				sql = "update members set profile_image_url = ? where user_id = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, profile_image_url);
				pstmt.setString(2, user_id);
				pstmt.executeUpdate();
				
			}else {//결과 값이 없으면 인서트
				sql = "insert into members(profile_image_url) values(?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, profile_image_url);
				pstmt.executeUpdate();
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
	}//profile end
	
	//profile_image_url 가져오기
	public String getImage(String user_id) {
		String profile_image_url = "default.jpg";
		try {
			conn = OracleConnection.getConnection();
			sql = "select * from members where user_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				profile_image_url = rs.getString("profile_image_url");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		
		return profile_image_url;
	}//getImage end
	
	//로그인 
	public boolean loginCheck(MemberDTO dto) {
		boolean result = false;
		try {
			conn = OracleConnection.getConnection();
			
			sql = "select * from members where user_id = ? and password_hash = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUser_id());
			pstmt.setString(2, dto.getPassword_hash());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				result = true;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}//loginCheck end
	
	//정보 가져오기 
	public MemberDTO getInfo(String user_id) {
		MemberDTO dto = null;
		try {
			conn = OracleConnection.getConnection();
			sql = "select * from members where user_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dto = new MemberDTO();
				
				dto.setUsername(rs.getString("username"));
				dto.setEmail(rs.getString("email"));
				dto.setPhone(rs.getString("phone"));
				dto.setAddress(rs.getString("address"));
				dto.setResident_registration_number(rs.getString("resident_registration_number"));
				//이메일 인증 나중에 추가
				//전화 인증 나중에 추가
				dto.setCreated_at(rs.getTimestamp("created_at"));
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		
		return dto;
	}//getInfo end
	
	//개인정보 수정
	public void infoUpdate(MemberDTO dto) {
		try {
			conn = OracleConnection.getConnection();
			sql = "update members set username = ?, email = ?, phone = ?, address = ? where user_id = ? and password_hash = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setString(2, dto.getEmail());
			pstmt.setString(3, dto.getPhone());
			pstmt.setString(4, dto.getAddress());
			pstmt.setString(5, dto.getUser_id());
			pstmt.setString(6, dto.getPassword_hash());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
	}//infoupdate end
	
	//회원 탈퇴
	public boolean memberDeactivated(MemberDTO dto, String user_status) {
		boolean result = false;
		try {
			conn = OracleConnection.getConnection();
			//유저 상태 변경 업데이트에 날짜 기록
			sql = "update members set user_status = ?, updated_at = current_date where user_id =? and password_hash = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_status);
			pstmt.setString(2, dto.getUser_id());
			pstmt.setString(3, dto.getPassword_hash());
			
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
	}//memberdeactivated end
	
	//활성화 상태 체크
	public boolean isActiveUser(String user_id) {
		boolean result = false;
		try {
			conn = OracleConnection.getConnection();
			//user_status체크
			sql = "select user_status from members where user_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				String user_status = rs.getString("user_status");
				if(user_status.equalsIgnoreCase("ACTIVE")) {
					result = true;
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		
		return result;
	}//isActiveUser end
	
	//회원 등급 가져오기
	public int getUserGrade(MemberDTO dto) {
		int grade = -1;
		try {
			conn = OracleConnection.getConnection();
			sql = "select grade from members where user_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUser_id());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				grade = rs.getInt("grade");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return grade;
	}//getGrade end
	
}//DAO end
