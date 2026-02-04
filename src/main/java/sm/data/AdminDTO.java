package sm.data;

import java.sql.Timestamp;

public class AdminDTO {
	private String user_id;
	private String username;
	private String email;
	private String phone;
	private String address;
	private String resident_registration_number;
	private String password_hash;
	private String password_salt;
	private String user_status; //ACTIVE 정상, DEACTIVE 탈퇴, STOPPED 정지
	private int email_verified;
	private int phone_verified;
	private String profile_image_url;
	private Timestamp created_at;
	private Timestamp updated_at; //회원 상태 변경 관련 변수
	private Timestamp last_login_at; //회원 정지 상태 회복 및 데이터 삭제를 위한 변수
	private Timestamp password_changed_at; //일정 시간 후 비번 변경을 위한 변수
	private int grade; // 0 관리자, 1 일반 회원, 2 인플루언서, 3 기자
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
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
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getResident_registration_number() {
		return resident_registration_number;
	}
	public void setResident_registration_number(String resident_registration_number) {
		this.resident_registration_number = resident_registration_number;
	}
	public String getPassword_hash() {
		return password_hash;
	}
	public void setPassword_hash(String password_hash) {
		this.password_hash = password_hash;
	}
	public String getPassword_salt() {
		return password_salt;
	}
	public void setPassword_salt(String password_salt) {
		this.password_salt = password_salt;
	}
	public String getUser_status() {
		return user_status;
	}
	public void setUser_status(String user_status) {
		this.user_status = user_status;
	}
	public int getEmail_verified() {
		return email_verified;
	}
	public void setEmail_verified(int email_verified) {
		this.email_verified = email_verified;
	}
	public int getPhone_verified() {
		return phone_verified;
	}
	public void setPhone_verified(int phone_verified) {
		this.phone_verified = phone_verified;
	}
	public String getProfile_image_url() {
		return profile_image_url;
	}
	public void setProfile_image_url(String profile_image_url) {
		this.profile_image_url = profile_image_url;
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
	public Timestamp getLast_login_at() {
		return last_login_at;
	}
	public void setLast_login_at(Timestamp last_login_at) {
		this.last_login_at = last_login_at;
	}
	public Timestamp getPassword_changed_at() {
		return password_changed_at;
	}
	public void setPassword_changed_at(Timestamp password_changed_at) {
		this.password_changed_at = password_changed_at;
	}
	public int getGrade() {
		return grade;
	}
	public void setGrade(int grade) {
		this.grade = grade;
	}
	
}
