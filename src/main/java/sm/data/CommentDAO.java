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
            conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@192.168.219.198:1521:orcl",
                "dev04",
                "1234"
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 1️⃣ 특정 게시글의 댓글 목록 조회
    public List<CommentDTO> getCommentsByBoardNum(int boardNum) {
        List<CommentDTO> list = new ArrayList<>();
        String sql = "SELECT id, board_num, writer, content, reg_date FROM comment_table WHERE board_num=? ORDER BY id ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, boardNum);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CommentDTO c = new CommentDTO();
                    c.setId(rs.getInt("id"));
                    c.setBoardNum(rs.getInt("board_num"));
                    c.setWriter(rs.getString("writer"));
                    c.setContent(rs.getString("content"));
                    Timestamp ts = rs.getTimestamp("reg_date");
                    if(ts != null) {
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

    // 2️⃣ 댓글 작성
    public void insertComment(CommentDTO comment) {
        String sql = "INSERT INTO comment_table(board_num, writer, content, reg_date) VALUES(?,?,?, SYSDATE)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, comment.getBoardNum());
            ps.setString(2, comment.getWriter());
            ps.setString(3, comment.getContent());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 3️⃣ 특정 게시글의 댓글 수 조회
    public int getCommentCountByBoardNum(int boardNum) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM comment_table WHERE board_num=?";
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

    // DB 연결 종료
    public void close() {
        try { 
            if (conn != null) conn.close(); 
        } catch(Exception e) { 
            e.printStackTrace(); 
        }
    }
}
    

       
