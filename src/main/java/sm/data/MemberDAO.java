package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import sm.util.PasswordUtil;

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
			sql = "insert into members (user_id, username, email, phone, address, resident_registration_number, password_hash, password_salt, created_at,  email_verified) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
			
	        pstmt.setInt(10, dto.getEmail_verified());
			
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
	
	
	//원 버젼 로그인 체크
	//로그인 
	public boolean loginCheck(MemberDTO dto) {
		 if (dto == null || dto.getUser_id() == null || dto.getPassword_hash() == null) {
			 return false;
		 }
	     String userId = dto.getUser_id();
	     String inputPasswordOrHash = dto.getPassword_hash(); // 기존 관행: 평문이 들어옴
	     return loginCheck(userId, inputPasswordOrHash);
	}//loginCheck end
	
	
	//password_hash + salt 거친 비번 비교
	public boolean loginCheck(String user_id, String plainPassword) {
		 if (user_id == null || plainPassword == null) {
			 return false;
		 }
		 boolean result = false;
		 try {
			conn = OracleConnection.getConnection();
			//패스워드는 디비단에서 비교 불가
			sql = "select password_hash, password_salt from members where user_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				String storedHash = rs.getString("password_hash");
				String salt = rs.getString("password_salt");

				// 안전성: salt 또는 storedHash가 비어있으면 로그인 실패 처리
				if (salt == null || salt.trim().isEmpty() || storedHash == null) {
					return false;
				}

				// 입력된 값이 이미 해시(예외적 상황)인지 간단히 판별하려면 길이/패턴 체크 가능.
				// 그러나 시스템 전체가 salt+hash를 사용하므로 입력은 평문으로 기대.
				String computedHash = PasswordUtil.passwordHash(plainPassword, salt);

				if (storedHash.equals(computedHash)) {
					result = true;
				}
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
		if (dto == null || dto.getUser_id() == null || dto.getPassword_hash() == null) {
			return;
		}
		
		try {
			conn = OracleConnection.getConnection();
			//비번 해시해서 비교
			sql = "select password_hash, password_salt from members where user_id = ?";
			pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getUser_id());
            rs = pstmt.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                String salt = rs.getString("password_salt");
                if (salt == null || salt.trim().isEmpty() || storedHash == null) {
                	return;
                }

                String inputPlain = dto.getPassword_hash(); // 기존 관행: 평문이 들어옴
                String computedHash = PasswordUtil.passwordHash(inputPlain, salt);
                if (!storedHash.equals(computedHash)) {
                	return; // 비밀번호 불일치
                }
                
                rs.close();
                pstmt.close();
                
                sql = "update members set username = ?, email = ?, phone = ?, address = ? where user_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, dto.getUsername());
                pstmt.setString(2, dto.getEmail());
                pstmt.setString(3, dto.getPhone());
                pstmt.setString(4, dto.getAddress());
                pstmt.setString(5, dto.getUser_id());
                pstmt.executeUpdate();
                
            }
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
	}//infoupdate end
	
	//회원 탈퇴
	public boolean memberDeactivated(MemberDTO dto, String user_status) {
		 if (dto == null || dto.getUser_id() == null || dto.getPassword_hash() == null) {
			 return false;
		 }
		boolean result = false;
		try {
			conn = OracleConnection.getConnection();
			//유저 상태 변경 업데이트에 날짜 기록
			sql = "select password_hash, password_salt from members where user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getUser_id());
            rs = pstmt.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                String salt = rs.getString("password_salt");
                if (salt == null || salt.trim().isEmpty() || storedHash == null) return false;

                String inputPlain = dto.getPassword_hash(); // 기존 관행: 평문이 들어옴
                String computedHash = PasswordUtil.passwordHash(inputPlain, salt);
                if (!storedHash.equals(computedHash)) return false;

                rs.close();
                pstmt.close();
                sql = "update members set user_status = ?, updated_at = current_date where user_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, user_status);
                pstmt.setString(2, dto.getUser_id());
                int update = pstmt.executeUpdate();
                if (update > 0) result = true;
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
	
	//email_verified 변경
	public boolean verifyEmailByEmail(String email) {
		boolean result = false;
		try {
			conn = OracleConnection.getConnection();
			sql = "update members set email_verified = ? where email = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, 1);
			pstmt.setString(2, email);
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
	}//email_verified 변경 end
	
	//이메일 존재확인
	public boolean existsByEmail(String email) {
		boolean result = false;
		try {
			conn = OracleConnection.getConnection();
			sql = "select 1 from members where email = ? and rownum = 1";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
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
	}//existsByEmail end
	
	//email로 회원조회
	public MemberDTO findByEmail(String email) {
		MemberDTO dto = null;
		
		try {
			conn = OracleConnection.getConnection();
			sql = "select * from members where email = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			if(rs.next()){
				dto = new MemberDTO();
				
				 dto.setUser_id(rs.getString("user_id"));
		         dto.setUsername(rs.getString("username"));
		         dto.setEmail(rs.getString("email"));
		         dto.setPhone(rs.getString("phone"));
		         dto.setAddress(rs.getString("address"));
		         dto.setResident_registration_number(rs.getString("resident_registration_number"));
		         dto.setPassword_Hash(rs.getString("password_hash")); // DTO 메서드 이름에 맞춰 조정
		         dto.setPassword_salt(rs.getString("password_salt"));
		         dto.setCreated_at(rs.getTimestamp("created_at"));
		         dto.setEmail_verified(rs.getInt("email_verified"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return dto;
	}
	
}//DAO end
