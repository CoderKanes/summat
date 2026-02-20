package sm.data;

import java.sql.Timestamp;

public class InfluencerRequestDTO {
	
	private int id;					//신청자 번호
	private String user_id;			
	private int requested_grade;	//신청 등급
	private String reason;			//신청 이유
	private String sns_urls;
	private String status;			//'PENDING'(대기), 'APPROVED'(승인), 'REJECTED'(거절)
	private Timestamp requested_at;	//신청일
	private String processed_by;	//처리자
	private Timestamp processed_at;	//처리 시간
	private String admin_note;		//관리자 노트
	
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
	public int getRequested_grade() {
		return requested_grade;
	}
	public void setRequested_grade(int requested_grade) {
		this.requested_grade = requested_grade;
	}
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
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
	public String getSns_urls() {
		return sns_urls;
	}
	public void setSns_urls(String sns_urls) {
		this.sns_urls = sns_urls;
	}
	
	
}
