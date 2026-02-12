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

	// 1. 전체 게시글 목록 조회 (최신 글 순)
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

	// 2. 게시글 등록
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

		     // 👇 여기 추가
	        System.out.println("password = " + dto.getPassword());
			
		} catch (Exception e) {
			e.printStackTrace(); 
		}
		return result;
	}
	// 3.게시글 번호로 게시글 조회
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

	// 4.전체 게시글 목록 조회 (상세 정보 포함)
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

	// 5.댓글 조회
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

	// 6.댓글 작성
	public void insertComment(CommentDTO comment) {
		String sql = "INSERT INTO comment_table "
		           + "(id, board_num, writer, content, regdate) "
		           + "VALUES (comment_seq.NEXTVAL, ?, ?, ?, SYSDATE)";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, comment.getId());
			ps.setInt(2, comment.getBoard_Num());
			ps.setString(3, comment.getWriter());
			ps.setString(4, comment.getContent());
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	// 6 -1 댓글 삭제 기능 
	public boolean deleteComment(int id, String password) {
		
		 String sql = "DELETE FROM board WHERE id=? AND password=?";
		 
	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	    	ps.setInt(1, id);
	    	ps.setString(2, password);
	    	
	        int result = ps.executeUpdate();
	        return result > 0;
	        
	    } catch(Exception e) {
	        e.printStackTrace();
	        
	        return false;
	    }
	}
	
	// 7.조횟수 증가
	public void increaseHit(int num) {
		String sql = "UPDATE board SET hit = hit + 1 WHERE num = ?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, num);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 8.게시판 댓글 삭제
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

	// 9. 게시글 삭제
	public void deleteBoard(int num) {
		String sql = "DELETE FROM board WHERE num = ?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, num);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 10. 게시판 검색
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
	// 11.DB 연결 객체(Connection)를 생성하여 반환하는 메서드
	private Connection getConnection() throws Exception {
		return OracleConnection.getConnection(); // DBConnection 클래스가 있어야 합니다.
	}

	// 1️2 게시글 목록 가져오기
	public List<BoardDTO> getAllPosts() {
		List<BoardDTO> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			conn = getConnection();
			String sql = "SELECT * FROM board ORDER BY id DESC";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();

			while (rs.next()) {
				BoardDTO post = new BoardDTO();
				post.setId(rs.getInt("id"));
				post.setTitle(rs.getString("title"));
				post.setContent(rs.getString("content"));
				post.setWriter(rs.getString("writer"));
				post.setRegDate(rs.getString("regDate"));
				list.add(post);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
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
		return list;
	}

	// 13 글 하나 가져오기
	public BoardDTO getPost(int id) {
		BoardDTO post = null;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			conn = getConnection();
			String sql = "SELECT * FROM board WHERE id=?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			rs = ps.executeQuery();

			if (rs.next()) {
				post = new BoardDTO();
				post.setId(rs.getInt("id"));
				post.setTitle(rs.getString("title"));
				post.setContent(rs.getString("content"));
				post.setWriter(rs.getString("writer"));
				post.setRegDate(rs.getString("regDate"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
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
		return post;
	}

	// 14 글 수정
	public int updatePost(int id, String title, String content) {
		int result = 0;
		Connection conn = null;
		PreparedStatement ps = null;

		try {
			conn = getConnection();
			String sql = "UPDATE board SET title=?, content=? WHERE id=?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, title);
			ps.setString(2, content);
			ps.setInt(3, id);
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

	// 15 글 삭제
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

	// 16 조회수 증가 (한 IP당 1회)
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
	// 17. 게시판 전체 게시글 수를 조회하여 반환하는 메서드
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
	
	// 18. 검색 결과 페이징 처리를 위해 조건에 맞는 게시글 수를 조회
	public int getArticleCount(String sqry) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int x = 0;

		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select count(*) from board " + sqry);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				x = rs.getInt(1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (SQLException ex) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ex) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ex) {
				}
		}
		return x;
	}

	// 19. 검색 조건과 페이징 범위(start~end)에 따라 게시글 목록을 조회하는 메서드
	public List<BoardDTO> getArticles(int start, int end, String sqry) throws Exception {

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    List<BoardDTO> articleList = null;

	    String sql =
	        "SELECT num, writer, regDate, content " +
	        "FROM ( " +
	        "  SELECT num, writer, regDate, content, rownum r " +
	        "  FROM ( " +
	        "    SELECT num, writer, regDate, content " +
	        "    FROM board " + sqry +
	        "    ORDER BY ref DESC, re_step ASC " +
	        "  ) " +
	        ") " +
	        "WHERE r BETWEEN ? AND ?";

	    try {
	        conn = getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, start);
	        pstmt.setInt(2, end);

	        rs = pstmt.executeQuery();

	        articleList = new ArrayList<>();

	        while (rs.next()) {
	            BoardDTO article = new BoardDTO();
	            article.setNum(rs.getInt("num"));
	            article.setWriter(rs.getString("writer"));
	            article.setContent(rs.getString("content"));
	            article.setRegDate(rs.getString("regDate"));
	            articleList.add(article);
	        }

	    } finally {
	        if (rs != null) rs.close();
	        if (pstmt != null) pstmt.close();
	        if (conn != null) conn.close();
	    }

	    return articleList;
	}

	// 20. 시퀀스를 사용해 게시글 번호를 자동 증가시키며 더미 게시글을 등록
	public void insertDummyArticles(int count) {

		String sql = "INSERT INTO board (num, title, content, writer, regdate, hit) "
				+ "VALUES (board_seq.NEXTVAL, ?, ?, ?, SYSDATE, 0)";

		try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			for (int i = 1; i <= count; i++) {
				pstmt.setString(1, "자동 생성 게시글 제목 " + i);
				pstmt.setString(2, "이것은 자동으로 생성된 게시글 내용입니다. 번호: " + i);
				pstmt.setString(3, "관리자");

				pstmt.executeUpdate();

			}
			System.out.println(count + "개의 더미 게시글 생성 완료");
			pstmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	// 21. 게시글 번호(num)에 해당하는 게시글 정보를 조회하여 반환하는 메서드
	public BoardDTO getArticleByNum(int num) {
	    BoardDTO dto = null;

	    try {
	        conn = getConnection();

	        String sql = "SELECT * FROM board WHERE num = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, num);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            dto = new BoardDTO();
	            dto.setNum(rs.getInt("num"));
	            // 필요한 컬럼 추가 설정 가능 
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        OracleConnection.closeAll(conn, pstmt, rs);
	    }
	    
	    return dto;
	    
	}
	
}