package sm.data;

import java.util.Date;

public class CommentDTO {
	private int postId;
    private int id;
    private int board_Num;
    private String password;
    private String writer;
    private String content;
    private Date regDate;
       
	public int getPostId() {
		return postId;
	}
	public void setPostId(int postId) {
		this.postId = postId;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getBoard_Num() {
		return board_Num;
	}
	public void setBoard_Num(int board_Num) {
		this.board_Num = board_Num;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
}