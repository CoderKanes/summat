package sm.data;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {

	private Connection conn;

	// 생성자: DB 연결
	public CommentDAO() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.219.198:1521:orcl", "Web1", "1234");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	// 1️ 특정 게시글의 댓글 목록 조회★view 페이지
	public List<CommentDTO> getCommentsByBoard_Num(int boardNum) {
		List<CommentDTO> list = new ArrayList<>();
		String sql = "SELECT id, board_num, writer, content, regdate FROM BOARD_COMMENT WHERE board_num=? ORDER BY id ASC";

		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, boardNum);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					CommentDTO c = new CommentDTO();
					c.setId(rs.getInt("id"));
					c.setBoard_Num(rs.getInt("board_num"));
					c.setWriter(rs.getString("writer"));
					c.setContent(rs.getString("content"));
					Timestamp ts = rs.getTimestamp("regdate");
					if (ts != null) {
						c.setRegDate(ts); // CommentDTO에서 Date 타입 사용
					}
					list.add(c); // list에 추가하는 위치 반드시 while 안쪽
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	// 댓글 등록 ( ID 는 외부에서 생성되어 전달됨) ◐comment_insert페이지
	public void insertComment(CommentDTO comment) {
	    String sql = "INSERT INTO BOARD_COMMENT(id, board_num, password, content, writer, regdate) " +
	                 "VALUES(board_comment_seq.NEXTVAL, ?, ?, ?, ?, SYSDATE)";

	    try (PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, comment.getBoard_Num());      // board_num
	        ps.setString(2, comment.getPassword());    // password
	        ps.setString(3, comment.getContent());     // content
	        ps.setString(4, comment.getWriter());      // writer
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	// 3️  특정 게시글의 댓글 수 조회  ● list페이지
	public int getCommentCountByBoardNum(int boardNum) {
		int count = 0;
		String sql = "SELECT COUNT(*) FROM BOARD_COMMENT WHERE board_num=?";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, boardNum);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					count = rs.getInt(1);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;    
		
	}
	// DB Connection 종료  ● list페이지   ★view 페이지
	public void close() {
		try {
			if (conn != null)
				conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
    // 3. 댓글 삭제 ▦comment_delete페이지
	public boolean deleteComment(int id, String password) {

	    String sql = "DELETE FROM board_comment WHERE id=? AND password=?";
	   
	    try (PreparedStatement ps = conn.prepareStatement(sql)){
	    	ps.setInt(1, id);
	    	ps.setString(2, password);

	        int result = ps.executeUpdate();
	        return result > 0;

	    } catch(Exception e) {
	        e.printStackTrace();
	    }

	    return false;
	}
    // 4. 댓글 수정
    public boolean updateComment(int id, String content) {
        String sql = "UPDATE BOARD_COMMENT SET content=? WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, content);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
