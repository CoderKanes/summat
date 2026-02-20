package sm.data;

import java.sql.Timestamp;
import java.util.List;

public class PostCommentDTO {
	private int id;
	private int postNum;
	private String user_Id;
	private String guestName;
	private String guestPassword;
	private String content;
	private int likeCount;
	private int dislikeCount;
	private Timestamp created_at; 
	private Timestamp updated_at; 
	private int replyTarget;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getPostNum() {
		return postNum;
	}

	public void setPostNum(int postNum) {
		this.postNum = postNum;
	}

	public String getUser_Id() {
		return user_Id;
	}

	public void setUser_Id(String user_Id) {
		this.user_Id = user_Id;
	}

	public String getGuestName() {
		return guestName;
	}

	public void setGuestName(String guestName) {
		this.guestName = guestName;
	}

	public String getGuestPassword() {
		return guestPassword;
	}

	public void setGuestPassword(String guestPassword) {
		this.guestPassword = guestPassword;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Timestamp getCreated_at() {
		return created_at;
	}

	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}

	public Timestamp getUpdated_at() {
		return updated_at;
	}

	public void setUpdated_at(Timestamp updated_at) {
		this.updated_at = updated_at;
	}

	public int getReplyTarget() {
		return replyTarget;
	}

	public void setReplyTarget(int replyTarget) {
		this.replyTarget = replyTarget;
	}
	
	public String getWriter() {
		String writer = "";
		if(user_Id != null){
			MemberDTO memberdto = MemberDAO.getInstance().getInfo(user_Id);
			if(memberdto !=null) {
				writer = memberdto.getUsername();
			}
		}else if(guestName != null){
			writer = guestName;
		}		
		return writer;
	}
	
	public List<PostCommentDTO> getReplies() {
		PostDAO pdao = new PostDAO();
		List<PostCommentDTO> subComments = pdao.getSubPostComments(postNum, id);				
		return subComments;
	}
	
	public int getLikes() {
		PostDAO pdao = new PostDAO();			
		return pdao.GetTotalLike(id);
	}
	
	public int getDislikes() {
		PostDAO pdao = new PostDAO();			
		return pdao.GetTotalDislike(id);
	}
}
