package sm.data;

import java.security.Timestamp;

public class Journalists {

	private int journalist_id;
	private String user_id;
	private String organization;
	private String title;
	private String email;
	private String phone;
	private String bio;
	private String verified;
	private Timestamp created_at;
	private Timestamp updated_at;
	private String status;
	private Timestamp requested_at;
	private String processed_by;
	private Timestamp processed_at;
	private String admin_note;
	public int getJournalist_id() {
		return journalist_id;
	}
	public void setJournalist_id(int journalist_id) {
		this.journalist_id = journalist_id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getOrganization() {
		return organization;
	}
	public void setOrganization(String organization) {
		this.organization = organization;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getBio() {
		return bio;
	}
	public void setBio(String bio) {
		this.bio = bio;
	}
	//String 을 boolean으로 
	public String getVerified() {
		return verified;
	}
	public void setVerified(String verified) {
		if(verified == null) {
			this.verified = "N";
		}else {
			this.verified = verified.equalsIgnoreCase("Y")? "Y":"N";
		}
		
	}
	
	 // 편의 메서드: boolean으로 사용 둘 다 가능 선택해서 써라
    public boolean isVerified() { 
    	return "Y".equalsIgnoreCase(this.verified); 
    	}
    public void setVerified(boolean verified) { 
    	this.verified = verified ? "Y" : "N"; 
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Timestamp getRequested_at() {
		return requested_at;
	}
	public void setRequested_at(Timestamp requested_at) {
		this.requested_at = requested_at;
	}
	public String getProcessed_by() {
		return processed_by;
	}
	public void setProcessed_by(String processed_by) {
		this.processed_by = processed_by;
	}
	public Timestamp getProcessed_at() {
		return processed_at;
	}
	public void setProcessed_at(Timestamp processed_at) {
		this.processed_at = processed_at;
	}
	public String getAdmin_note() {
		return admin_note;
	}
	public void setAdmin_note(String admin_note) {
		this.admin_note = admin_note;
	}
	
	
	
}
