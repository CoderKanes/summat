package sm.data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {

	private Connection conn;

	public BoardDAO() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.219.198:1521:orcl", "dev04", "1234");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 게시글 목록
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
	
// 게시글 등록   
// ----------------------------------------------------------------------
	public void insert(BoardDTO dto) {
	    String sql = "INSERT INTO board (num, title, content, writer, regdate, hit) "
	               + "VALUES (board_seq.NEXTVAL, ?, ?, ?, SYSDATE, 0)";
	    	// 쿼리문 작성 물음표 값에 dto 값을 대입 한다 
	    try {
	        PreparedStatement ps = conn.prepareStatement(sql);
	        ps.setString(1, dto.getTitle());
	        ps.setString(2, dto.getContent());
	        ps.setString(3, dto.getWriter());
	        ps.executeUpdate();

	        System.out.println(">>> 게시글 등록 성공");

	    } catch (Exception e) {
	        System.out.println(">>> 게시글 등록 실패");
	        e.printStackTrace();
	    }
	}
// ----------------------------------------------------------------------	
	public void save(BoardDTO dto) {

		String sql = "INSERT INTO board (num, title, content, writer, regdate, hit) "
				+ "VALUES (board_seq.NEXTVAL, ?, ?, ?, SYSDATE, 0)";

		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, dto.getTitle());
			ps.setString(2, dto.getContent());
			ps.setString(3, dto.getWriter());
			ps.executeUpdate();

			System.out.println(">>> INSERT 성공");

		} catch (Exception e) {
			System.out.println(">>> INSERT 실패");
			e.printStackTrace();
		}
	}

	public BoardDTO getBoardByNum(int num) {
		BoardDTO board = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "SELECT num, title, content, writer, regDate FROM board WHERE num = ?";

		try {
			ps = conn.prepareStatement(sql);
			ps.setInt(1, num);
			rs = ps.executeQuery();

			if (rs.next()) {
				board = new BoardDTO();
				board.setNum(rs.getInt("num"));
				board.setTitle(rs.getString("title"));
				board.setContent(rs.getString("content"));
				board.setWriter(rs.getString("writer"));

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return board;
	}

	public List<BoardDTO> getAllBoards() {
		List<BoardDTO> list = new ArrayList<>();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "SELECT num, title, content, writer, regDate, hit FROM board ORDER BY num DESC";

		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();

			while (rs.next()) {
				BoardDTO board = new BoardDTO();
				board.setNum(rs.getInt("num"));
				board.setTitle(rs.getString("title"));
				board.setContent(rs.getString("content"));
				board.setWriter(rs.getString("writer"));
				board.setRegDate(rs.getTimestamp("regDate").toString());
				board.setHit(rs.getInt("hit"));
				list.add(board);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return list;
	}

	public class CommentDAO {

		private Connection conn;

		public CommentDAO() throws Exception {
			String url = "jdbc:oracle:thin:@localhost:1521:xe"; // Oracle 연결
			String user = "yourUser";
			String password = "yourPassword";
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url, user, password);
		}

		// 댓글 조회
		public List<CommentDTO> getCommentsByBoardNum(int boardNum) {
			List<CommentDTO> list = new ArrayList<>();
			String sql = "SELECT id, board_num, writer, content, reg_date FROM comment_table WHERE board_num=? ORDER BY id ASC";

			try (PreparedStatement ps = conn.prepareStatement(sql)) {
				ps.setInt(1, boardNum);
				ResultSet rs = ps.executeQuery();
				while (rs.next()) {
					CommentDTO c = new CommentDTO();
					c.setId(rs.getInt("id"));
					c.setBoardNum(rs.getInt("board_num"));
					c.setWriter(rs.getString("writer"));
					c.setContent(rs.getString("content"));
					c.setRegDate(rs.getDate("reg_date"));
					list.add(c);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			return list;
		}

		// 댓글 작성
		public void insertComment(CommentDTO comment) {
			String sql = "INSERT INTO comment_table(board_num, writer, content) VALUES(?,?,?)";
			try (PreparedStatement ps = conn.prepareStatement(sql)) {
				ps.setInt(1, comment.getBoardNum());
				ps.setString(2, comment.getWriter());
				ps.setString(3, comment.getContent());
				ps.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		public void close() {
			try {
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public void increaseHit(int num) {
		String sql = "UPDATE board SET hit = hit + 1 WHERE num = ?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, num);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	

	public void deleteBoardAndComments(int num) {
		try {
			// 댓글 먼저 삭제
			String delComments = "DELETE FROM comment_table WHERE board_num = ?";
			try (PreparedStatement ps1 = conn.prepareStatement(delComments)) {
				ps1.setInt(1, num);
				ps1.executeUpdate();
			}  // post

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

	// 게시글 삭제
	public void deleteBoard(int num) {
		String sql = "DELETE FROM board WHERE num = ?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, num);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 검색 메서드
	public List<BoardDTO> searchBoards(String keyword) {
		List<BoardDTO> list = new ArrayList<>();
		String sql = "SELECT num, title, content, writer, regDate, hit FROM board "
				+ "WHERE title LIKE ? OR content LIKE ? " + "ORDER BY num DESC";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
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
					board.setRegDate(rs.getTimestamp("regDate").toString());
					board.setHit(rs.getInt("hit"));
					list.add(board);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public int deletePost(int id) {
		int result = 0;
		Connection conn = null;
		PreparedStatement ps = null;

		try {
			conn = OracleConnection.getConnection(); // DB 연결
			String sql = "DELETE FROM board WHERE id=?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			result = ps.executeUpdate(); // 성공하면 1 반환
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// 자원 해제
			try {
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	private Connection getConnection() throws Exception {
		return OracleConnection.getConnection(); // DBConnection 클래스가 있어야 합니다.
	}

	// 1️⃣ 게시글 목록 가져오기
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

	// 2️⃣ 글 하나 가져오기
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

	// 3️⃣ 글 수정
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

	// 4️⃣ 글 삭제
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
	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if(ps != null) ps.close(); } catch(Exception e) { e.printStackTrace(); }
	        try { if(conn != null) conn.close(); } catch(Exception e) { e.printStackTrace(); }
	    }

	    return result;
	
	}
	// 조회수 증가 (한 IP당 1회)
	public boolean increaseHitByIP(int num, String ip) {
	    Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    boolean success = false;

	    try {
	        conn = OracleConnection.getConnection();

	        // 1️⃣ 해당 IP가 이미 조회했는지 체크
	        String checkSql = "SELECT COUNT(*) FROM board_hit_log WHERE num=? AND ip=?";
	        ps = conn.prepareStatement(checkSql);
	        ps.setInt(1, num);
	        ps.setString(2, ip);
	        rs = ps.executeQuery();
	        if(rs.next() && rs.getInt(1) == 0) {
	            // 2️⃣ 조회수 증가
	            String updateSql = "UPDATE board SET hit = hit + 1 WHERE num=?";
	            ps = conn.prepareStatement(updateSql);
	            ps.setInt(1, num);
	            ps.executeUpdate();

	            // 3️⃣ 히트 로그 추가
	            String insertSql = "INSERT INTO board_hit_log(num, ip) VALUES(?, ?)";
	            ps = conn.prepareStatement(insertSql);
	            ps.setInt(1, num);
	            ps.setString(2, ip);
	            ps.executeUpdate();

	            success = true;
	        }
	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        try { if(rs != null) rs.close(); } catch(Exception e) {}
	        try { if(ps != null) ps.close(); } catch(Exception e) {}
	        try { if(conn != null) conn.close(); } catch(Exception e) {}
	    }

	    return success;
	}
	
	// 리스트 화면에서 게시글 삭제 
	public void delete(int num) {
	    Connection conn = null;
	    PreparedStatement ps = null;

	    try {
	        conn = getConnection();

	        String sql = "DELETE FROM board WHERE num = ?";
	        ps = conn.prepareStatement(sql);
	        ps.setInt(1, num);

	        ps.executeUpdate();

	        System.out.println("게시글 삭제 성공 : num = " + num);

	    } catch (Exception e) {
	        e.printStackTrace();
	   
	    }
	}
}
