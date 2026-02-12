package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import sm.util.PasswordUtil;

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
	
	//삭제
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
	}//delete end
	
	//해시 솔트 비교
	public boolean verifyPassword(String user_id, String plainPassword) {
        if (user_id == null || plainPassword == null) return false;
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = OracleConnection.getConnection();
            sql = "select password_hash, password_salt from members where user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user_id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                String salt = rs.getString("password_salt");
                if (storedHash == null || salt == null || salt.trim().isEmpty()) return false;
                String computed = PasswordUtil.passwordHash(plainPassword, salt);
                result = storedHash.equals(computed);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            OracleConnection.closeAll(conn, pstmt, rs);
        }
        return result;
    }//해시 솔트 비교 end
	
	//상태에 따른 숫자
	public int getCountByStatus(String status, String searchQuery) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			 StringBuilder sb = new StringBuilder();
		        sb.append("select count(*) as count from members where user_status = ?");
		        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
		            sb.append(" and (user_id = ? or username = ?)");
		        }
		        pstmt = conn.prepareStatement(sb.toString());
		        pstmt.setString(1, status);
		        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
		            String q = "%" + searchQuery + "%";
		            pstmt.setString(2, q);
		            pstmt.setString(3, q);
		        }
		        rs = pstmt.executeQuery();
		        if (rs.next()) {
		        	result = rs.getInt("count");
		        }
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}//end
	
	//이메일 인증 카운트
	public int getEmailVerifiedCount(String searchQuery) {
	    int count = 0;
	    try {
	        conn = OracleConnection.getConnection();
	        StringBuilder sb = new StringBuilder();
	        sb.append("select count(*) as count from members where email_verified = 1");
	        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
	            sb.append(" and (user_id like ? or username like ?)");
	        }
	        pstmt = conn.prepareStatement(sb.toString());
	        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
	            String q = "%" + searchQuery + "%";
	            pstmt.setString(1, q);
	            pstmt.setString(2, q);
	        }
	        rs = pstmt.executeQuery();
	        if (rs.next()) count = rs.getInt("count");
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        OracleConnection.closeAll(conn, pstmt, rs);
	    }
	    return count;
	}//end
	
	//연령대 성별 집게 
	public StatsDTO getStats(String searchQuery) {
		StatsDTO sdto = new StatsDTO();
		try {
			conn = OracleConnection.getConnection();
			StringBuilder sb = new StringBuilder();
			//db 전체 가져와 그리고 별칭 total붙여
			sb.append("select count(*) as total, ")
			//					   1(주민번호 앞이 6자리 + '-' + 뒷자리 첫 수가 0아니지?) 											  2(주민번호 - 지워)										 3(뒷자리 1번만 꺼내)				 4(그게 13579냐?)	  (참 = 1, 거짓 = 0)이고 남자에 저장해
			.append("sum(case when regexp_like(resident_registration_number, '^[0-9]{6}[-]?[1-9]') and to_number(regexp_substr(regexp_replace(resident_registration_number,'-',''), '.{6}(.{1})', 1, 1, NULL, 1)) in (1,3,5,7,9) then 1 else 0 end) as male, ")
	        .append("sum(case when regexp_like(resident_registration_number, '^[0-9]{6}[-]?[1-9]') and to_number(regexp_substr(regexp_replace(resident_registration_number,'-',''), '.{6}(.{1})', 1, 1, NULL, 1)) in (2,4,6,8,0) then 1 else 0 end) as female, ")
	        //형식이 안 맞으면 이거
	        .append("sum(case when not regexp_like(resident_registration_number, '^[0-9]{6}[-]?[1-9]') then 1 else 0 end) as unknown_gender, ")
	        //날짜 비교
	        .append("sum(case when (floor(months_between(sysdate, to_date( ")
	        .append("CASE ")
	        .append(" WHEN length(regexp_replace(resident_registration_number,'-','')) >= 7 THEN ") // 안전하게 처리
	        .append("   CASE ")
	        .append("     WHEN to_number(substr(regexp_replace(resident_registration_number,'-',''),7,1)) IN (1,2) THEN to_char(to_date(substr(regexp_replace(resident_registration_number,'-',''),1,6),'YYMMDD') + interval '100' year, 'YYYYMMDD') ")
	        .append("     WHEN to_number(substr(regexp_replace(resident_registration_number,'-',''),7,1)) IN (3,4) THEN to_char(to_date(substr(regexp_replace(resident_registration_number,'-',''),1,6),'YYMMDD') , 'YYYYMMDD') ")
	        .append("     WHEN to_number(substr(regexp_replace(resident_registration_number,'-',''),7,1)) IN (5,6,7,8,9,0) THEN to_char(to_date(substr(regexp_replace(resident_registration_number,'-',''),1,6),'YYMMDD') , 'YYYYMMDD') ")
	        .append("     ELSE NULL ")
	        .append("   END ")
	        .append(" ELSE NULL END), 'J')/365) between 0 and 9 then 1 else 0 end) as age_0_9, ")
	        .append("0 as age_10_19, 0 as age_20_29, 0 as age_30_39, 0 as age_40_49, 0 as age_50_59, 0 as age_60_plus ")
	        .append("from members ");

	        String sql = "select resident_registration_number from members";
	        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
	            sql += " where user_id like ? or username like ?";
	        }
	        pstmt = conn.prepareStatement(sql);
	        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
	            String q = "%" + searchQuery + "%";
	            pstmt.setString(1, q);
	            pstmt.setString(2, q);
	        }
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            String rrn = rs.getString("resident_registration_number");
	            if (rrn == null) {
	                sdto.unknownGender++;
	                continue;
	            }
	            String normalized = rrn.replaceAll("[^0-9]", ""); 
	            if (normalized.length() < 7) {
	                sdto.unknownGender++;
	                continue;
	            }
	            String yy = normalized.substring(0, 2);
	            String mm = normalized.substring(2, 4);
	            String dd = normalized.substring(4, 6);
	            char genderChar = normalized.charAt(6);
	            int genderDigit = Character.isDigit(genderChar) ? Character.getNumericValue(genderChar) : -1;

	            int year = 0;
	            int yyNum = Integer.parseInt(yy);
	            if (genderDigit == 1 || genderDigit == 2) {
	                // 1900s (born 1900-1999)
	                year = 1900 + yyNum;
	            } else if (genderDigit == 3 || genderDigit == 4) {
	                // 2000s (born 2000-2099)
	                year = 2000 + yyNum;
	            } else if (genderDigit == 5 || genderDigit == 6) {
	                // foreigner assigned -> usually 1900s
	                year = 1900 + yyNum;
	            } else {
	                // fallback
	                year = 1900 + yyNum;
	            }

	            int month = 1;
	            int day = 1;
	            try {
	                month = Integer.parseInt(mm);
	                day = Integer.parseInt(dd);
	            } catch (Exception ex) {
	                // ignore, keep defaults
	            }

	            Calendar birth = Calendar.getInstance();
	            birth.setLenient(false);
	            birth.set(year, month - 1, day, 0, 0, 0);
	            Calendar now = Calendar.getInstance();

	            int age = now.get(Calendar.YEAR) - birth.get(Calendar.YEAR);
	            if (now.get(Calendar.MONTH) < birth.get(Calendar.MONTH) ||
	                (now.get(Calendar.MONTH) == birth.get(Calendar.MONTH) &&
	                 now.get(Calendar.DAY_OF_MONTH) < birth.get(Calendar.DAY_OF_MONTH))) {
	                age--;
	            }

	            // increment totals
	            sdto.total++;

	            // gender
	            if (genderDigit == 1 || genderDigit == 3 || genderDigit == 5 || genderDigit == 7 || genderDigit == 9) {
	                sdto.male++;
	            } else if (genderDigit == 2 || genderDigit == 4 || genderDigit == 6 || genderDigit == 8 || genderDigit == 0) {
	                sdto.female++;
	            } else {
	                sdto.unknownGender++;
	            }

	            // age buckets
	            if (age < 0) {
	                // ignore negative ages
	            } else if (age <= 9) {
	                sdto.age0_9++;
	            } else if (age <= 19) {
	                sdto.age10_19++;
	            } else if (age <= 29) {
	                sdto.age20_29++;
	            } else if (age <= 39) {
	                sdto.age30_39++;
	            } else if (age <= 49) {
	                sdto.age40_49++;
	            } else if (age <= 59) {
	                sdto.age50_59++;
	            } else {
	                sdto.age60_plus++;
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        OracleConnection.closeAll(conn, pstmt, rs);
	    }
		return sdto;
	}//end
	
}//AdminDAO end
