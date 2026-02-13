package sm.data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/*
 * 작성자 : 신동엽
 * 내용 : 음식리뷰 포스트(Post) 등록, 수정, 삭제, 조회 및 목록 조회 기능을 담당하는 DAO 클래스
 */

public class BoardDAO {
	// DB 연결 객체
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	private static BoardDAO instance = new BoardDAO();
							//  ● list페이지
	public static BoardDAO getInstance() {

		return instance;
	}

	// 생성자: Oracle DB 드라이버 로드 및 DB 연결
	public BoardDAO() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.219.198:1521:orcl", "Web1", "1234");
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	// 1. 전체 게시글 목록 조회 (최신 글 순)  일단 호출 하는 곳 없음 
	public List<BoardDTO> getList() {

		List<BoardDTO> list = new ArrayList<>();
		String sql = "SELECT * FROM board ORDER BY num DESC";
			
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
					ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				BoardDTO dto = new BoardDTO();
				dto.setNum(rs.getInt("num"));
				dto.setTitle(rs.getString("title"));
				dto.setWriter(rs.getString("writer"));
				dto.setRegDate(rs.getString("regDate"));
				dto.setHit(rs.getInt("hit"));
				list.add(dto);

			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// 2. 게시글 등록  ■writeProc페이지
	public int insert(BoardDTO dto) {

		int result = 0;
		String sql = "INSERT INTO board (id, num, title, content, writer, password, regdate, hit) "
				+ "VALUES (?, board_seq.NEXTVAL, ?, ?, ?, ?, SYSDATE, 0)";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, dto.getId());
			ps.setString(2, dto.getTitle());
			ps.setString(3, dto.getContent());
			ps.setString(4, dto.getWriter());
			ps.setString(5, dto.getPassword());
			result = ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace(); 
		}
		return result;
	}
	// 3.게시글 번호로 게시글 조회★ view 페이지 기능   ☆editForm페이지
	public BoardDTO getBoardByNum(int num) {
		BoardDTO result = new BoardDTO();

		try {
			conn = OracleConnection.getConnection();
			String sql = "SELECT * FROM board WHERE num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			
			rs = pstmt.executeQuery();

			if (rs.next()) {
				result.setId(rs.getInt("id"));
				result.setNum(rs.getInt("num"));
				result.setTitle(rs.getString("title"));
				result.setContent(rs.getString("content"));
				result.setWriter(rs.getString("writer"));
				result.setRegDate(rs.getString("regDate"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	// 4.전체 게시글 목록 조회 (상세 정보 포함)  ● list페이지
	public List<BoardDTO> getAllBoards(int start , int end) {
		
		List<BoardDTO> list = new ArrayList<>();
		PreparedStatement ps = null;
		ResultSet rs = null; 

		String sql =
			    "select * from ( " +
			    "  select a.*, rownum r from ( " +
			    "    SELECT * FROM board ORDER BY regdate DESC, num DESC " +
			    "  ) a " +
			    ") where r between ? and ?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setInt(1, start);
			ps.setInt(2, end);
			rs = ps.executeQuery();

			while (rs.next()) {
				BoardDTO board = new BoardDTO();
				board.setNum(rs.getInt("num"));
				board.setTitle(rs.getString("title"));
				board.setContent(rs.getString("content"));
				board.setWriter(rs.getString("writer"));
				board.setRegDate(rs.getString("regdate")); // ⭐ 변경
				board.setHit(rs.getInt("hit"));
				list.add(board);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (ps != null) try { ps.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}

		return list;
	}

	// 5.댓글 조회 test  view 부분에서 호출 중  그외 호출 하는 곳 없음 
	public List<CommentDTO> getCommentsByBoardNum(int boardNum) {

		List<CommentDTO> list = new ArrayList<>();
		String sql = "SELECT * FROM BOARD_COMMENT " + "WHERE board_num = ? " + "ORDER BY id DESC";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, boardNum);
			
			try (ResultSet rs = ps.executeQuery()) {
				
				while (rs.next()) {
					CommentDTO c = new CommentDTO();
					c.setId(rs.getInt("id"));
					c.setBoard_Num(rs.getInt("board_num"));
					c.setWriter(rs.getString("writer"));
					c.setContent(rs.getString("content"));
					c.setRegDate(rs.getDate("regDate"));
					
					list.add(c);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
	
	// 6.게시판 댓글 삭제 〓delete페이지
	public void deleteBoardAndComments(int num) {
		try {
			// 댓글 먼저 삭제
			String delComments = "DELETE FROM BOARD_COMMENT WHERE board_num = ?";
			try (PreparedStatement ps1 = conn.prepareStatement(delComments)) {
				ps1.setInt(1, num);
				ps1.executeUpdate();
			} // post

			// 게시글 삭제
			String delBoard = "DELETE FROM board WHERE num = ?";
			try (PreparedStatement ps2 = conn.prepareStatement(delBoard)) {
				ps2.setInt(1, num);
				ps2.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 7. 게시판 검색  ● list페이지
	public List<BoardDTO> searchBoards(String keyword) {
		List<BoardDTO> list = new ArrayList<>();
		String sql = "SELECT num, title, content, writer, regDate, hit FROM board "
				+ "WHERE title LIKE ? OR content LIKE ? " + "ORDER BY num DESC";
		PreparedStatement ps = null;	
		try {
			ps = conn.prepareStatement(sql);
			String kw = "%" + keyword + "%";
			ps.setString(1, kw);
			ps.setString(2, kw);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					BoardDTO board = new BoardDTO();
					board.setNum(rs.getInt("num"));
					board.setTitle(rs.getString("title"));
					board.setContent(rs.getString("content"));
					board.setWriter(rs.getString("writer"));

					System.out.println("rs.getString(\"regDate\") : " + rs.getString("regDate"));
					board.setRegDate(rs.getString("regDate"));
					board.setHit(rs.getInt("hit"));
					list.add(board);

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (ps != null) try { ps.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}

		return list;
	}
	// 8.DB 연결 객체(Connection)를 생성하여 반환하는 메서드
	private Connection getConnection() throws Exception {
		return OracleConnection.getConnection(); // DBConnection 클래스가 있어야 합니다.
	}

	// 9 글 삭제   ??? 잘 모르겠음 보류 
	public int DeletePost(int num) {
		int result = 0;
		Connection conn = null;
		PreparedStatement ps = null;

		try {
			conn = getConnection();
			String sql = "DELETE FROM board WHERE num = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, num);
			result = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (ps != null)
					ps.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return result;
	}

	// 10 조회수 증가 (한 IP당 1회) ★view 페이지
	public boolean increaseHitByIP(int num, String ip) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean success = false;

		try {
			conn = OracleConnection.getConnection();

			// 1️ 해당 IP가 이미 조회했는지 체크
			String checkSql = "SELECT COUNT(*) FROM board_hit_log WHERE num=? AND ip=?";
			ps = conn.prepareStatement(checkSql);
			ps.setInt(1, num);
			ps.setString(2, ip);
			rs = ps.executeQuery();
			if (rs.next() && rs.getInt(1) == 0) {
				// 2️ 조회수 증가
				String updateSql = "UPDATE board SET hit = hit + 1 WHERE num=?";
				ps = conn.prepareStatement(updateSql);
				ps.setInt(1, num);
				ps.executeUpdate();

				// 3️ 히트 로그 추가
				String insertSql = "INSERT INTO board_hit_log(num, ip) VALUES(?, ?)";
				ps = conn.prepareStatement(insertSql);
				ps.setInt(1, num);
				ps.setString(2, ip);
				ps.executeUpdate();

				success = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
			} catch (Exception e) {
			}
			try {
				if (ps != null)
					ps.close();
			} catch (Exception e) {
			}
			try {
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}

		return success;
	}
	// 11 게시판 전체 게시글 수를 조회하여 반환하는 메서드  ● list페이지 
	public int getBoardCount() {
		int count = 0;
		String sql = "SELECT COUNT(*) FROM board";

		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return count;
	}
	
	// 12 게시글 수정 ▲editPro페이지
	public int update(BoardDTO dto) {
	    int result = 0; // 수정 성공 여부 저장 (0: 실패, 1: 성공)
	    Connection conn = null; // DB 연결 객체
	    PreparedStatement ps = null; // SQL 실행 객체

	    try {
	        conn = getConnection();
	        String sql = "UPDATE board SET title = ?, writer = ?, content = ? WHERE num = ? AND password = ?";
	        ps = conn.prepareStatement(sql);
	        ps.setString(1, dto.getTitle());    // 제목
	        ps.setString(2, dto.getWriter());   // 작성자
	        ps.setString(3, dto.getContent());  // 내용
	        ps.setInt(4, dto.getNum());         // 글 번호
	        ps.setString(5, dto.getPassword()); // 비밀번호
	        result = ps.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace(); // 오류 발생 시 콘솔에 출력
	    } finally {
	        // 5️⃣ 자원 해제: PreparedStatement
	        try {
	            if(ps != null) ps.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        // 6️⃣ 자원 해제: Connection
	        try {
	            if(conn != null) conn.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    // 7️⃣ 수정 결과 반환 (1: 성공, 0: 실패)
	    return result;
	}
	  //13 게시글 리스트에서 삭제 
    public boolean deleteComment(int num, String password) {

        try {

            // 1️⃣ 글 번호로 해당 댓글 비밀번호 조회
            String sqlCheck = "SELECT password FROM board WHERE num = ?";
            pstmt = conn.prepareStatement(sqlCheck);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();

            if(rs.next()) {
                String dbPassword = rs.getString("password");

                if(dbPassword.equals(password)) {
                    // 2️⃣ 비밀번호 일치 → 삭제
                    String sqlDelete = "DELETE FROM board WHERE num = ?";
                    pstmt.close(); // 기존 pstmt 닫기
                    pstmt = conn.prepareStatement(sqlDelete);
                    pstmt.setInt(1, num);
                    int result = pstmt.executeUpdate();

                    return result > 0; // 삭제 성공 → true
                } else {
                    // ❌ 비밀번호 불일치
                    return false;
                }
            } else {
                // ❌ 글 번호 없음
                return false;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            // 자원 반환
            try { if(rs != null) rs.close(); } catch(SQLException e) { e.printStackTrace(); }
            try { if(pstmt != null) pstmt.close(); } catch(SQLException e) { e.printStackTrace(); }
            try { if(conn != null) conn.close(); } catch(SQLException e) { e.printStackTrace(); }
        }
    }
}

