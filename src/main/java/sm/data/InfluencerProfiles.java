package sm.data;

import java.security.Timestamp;

public class InfluencerProfiles {
	
	private int id;
	private String user_id;
	private String diplay_name;
	private String bio;
	private String sns_data;
	private String portfolio_url;
	private String follower_info;
	private Timestamp created_at;
	private Timestamp updated_at;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getDiplay_name() {
		return diplay_name;
	}
	public void setDiplay_name(String diplay_name) {
		this.diplay_name = diplay_name;
	}
	public String getBio() {
		return bio;
	}
	public void setBio(String bio) {
		this.bio = bio;
	}
	public String getSns_data() {
		return sns_data;
	}
	public void setSns_data(String sns_data) {
		this.sns_data = sns_data;
	}
	public String getPortfolio_url() {
		return portfolio_url;
	}
	public void setPortfolio_url(String portfolio_url) {
		this.portfolio_url = portfolio_url;
	}
	
	public String getFollower_info() {
		return follower_info;
	}
	public void setFollower_info(String follower_info) {
		this.follower_info = follower_info;
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
	
	
}
