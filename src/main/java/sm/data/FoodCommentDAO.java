package sm.data;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FoodCommentDAO {

    // 댓글 목록 가져오기
	public List<FoodCommentDTO> getFoodComments(int boardNum) {
		
        List<FoodCommentDTO> list = new ArrayList<>();

        String sql = "SELECT id, boardnum, writer, password, content, CreatedDate " +
                "FROM Food_comment " +
                "WHERE boardnum = ? " +
                "ORDER BY CreatedDate DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = OracleConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, boardNum);
            rs = ps.executeQuery();

            while (rs.next()) {

                // 🔥 여기 수정됨
                FoodCommentDTO dto = new FoodCommentDTO();

                dto.setId(rs.getInt("id"));
                dto.setBoardNum(rs.getInt("boardnum"));
                dto.setWriter(rs.getString("writer"));
                dto.setPassword(rs.getString("password"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedDate(rs.getTimestamp("CreatedDate"));

                list.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            OracleConnection.closeAll(conn, ps, rs);
        }

        return list;
    }

    // 댓글 등록
    public boolean foodComments(FoodCommentDTO dto) {

    	String sql = "INSERT INTO Food_comment " +
                "(id, boardnum, writer, password, content, createddate) " +
                "VALUES (comments_seq.NEXTVAL, ?, ?, ?, ?, SYSDATE)";

        Connection conn = null;
        PreparedStatement ps = null;
        boolean result = false;

        try {
            conn = OracleConnection.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setInt(1, dto.getBoardNum());
            ps.setString(2, dto.getWriter());
            ps.setString(3, dto.getPassword());
            ps.setString(4, dto.getContent());

            int count = ps.executeUpdate();

            if (count > 0) {
                result = true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            OracleConnection.closeAll(conn, ps);
        }

        return result;
    }
    
    public int insert(FoodCommentDTO dto) {

        int result = 0;

        String sql = "INSERT INTO FOOD_COMMENT " +
        	    "(ID, BOARDNUM, WRITER, PASSWORD, CONTENT, CREATEDDATE) " +
        	    "VALUES (FOOD_COMMENT_SEQ.NEXTVAL, ?, ?, ?, ?, SYSDATE)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = OracleConnection.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setInt(1, dto.getBoardNum());   // boardnum
            ps.setString(2, dto.getWriter());
            ps.setString(3, dto.getPassword());
            ps.setString(4, dto.getContent());

            	
            result = ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            OracleConnection.closeAll(conn, ps);
        }

        return result;
    }
    // 삭제 
    public boolean deleteComment(int commentId, String password) {
    	Connection conn = null;
    	PreparedStatement ps =null;
        String sql = "DELETE FROM FOOD_COMMENT WHERE id=? AND password=?";
        try{
        	conn = OracleConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, commentId);
            ps.setString(2, password);
            return ps.executeUpdate() > 0;
        } catch(Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    // 수정 
    public boolean updateComment(int commentId, String password, String content) {
    	Connection conn = null;
    	PreparedStatement ps =null;
        String sql = "UPDATE FOOD_COMMENT SET content=? WHERE id=? AND password=?";
        try{
        	conn = OracleConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, content);
            ps.setInt(2, commentId);
            ps.setString(3, password);
            return ps.executeUpdate() > 0;
        } catch(Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    //삭제 
    public int FoodDeleteComments(int commentId, String password) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql = "DELETE FROM FOOD_COMMENT WHERE id = ? AND password = ?";
        int result = 0; // 삭제 성공 여부
        try {
            conn = OracleConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, commentId);
            ps.setString(2, password);
            result = ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try { if(conn != null) conn.close(); } catch(Exception e){ e.printStackTrace(); }
        }
        return result; // 삭제 성공 여부 반환
    }
}