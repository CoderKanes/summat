package sm.data;
import java.sql.Timestamp;

public class FoodCommentDTO {
	    private int id;
	    private int boardNum;
	    private String writer;
	    private String password;
	    private String content;
	    private Timestamp  CreatedDate;
		public int getId() {
			return id;
		}
		public void setId(int id) {
			this.id = id;
		}
		public int getBoardNum() {
			return boardNum;
		}
		public void setBoardNum(int boardNum) {
			this.boardNum = boardNum;
		}
		public String getWriter() {
			return writer;
		}
		public void setWriter(String writer) {
			this.writer = writer;
		}
		public String getPassword() {
			return password;
		}
		public void setPassword(String password) {
			this.password = password;
		}
		public String getContent() {
			return content;
		}
		public void setContent(String content) {
			this.content = content;
		}
		public Timestamp getCreatedDate() {
			return CreatedDate;
		}
		public void setCreatedDate(Timestamp createdDate) {
			CreatedDate = createdDate;
		}
	    
	    
	}
