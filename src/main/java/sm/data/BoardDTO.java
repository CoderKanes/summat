package sm.data;
import java.sql.*; 
import java.util.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

import sm.data.*;


public class BoardDTO {
	private int id;
    private int num;
    private String title;  // 3 
    private String content;
    private String writer;
    private String regDate;
    private int hit;
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {  // 접근 가능 돌려줄 필요 없다 . 저장 제목 문자타입 제목 1 받은 값을 
		this.title = title; // 2 자신을 호출 한다 타이틀 
	}
	public String getContent() {
		return content;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public int getHit() {
		return hit;
	}
	public void setHit(int hit) {
		this.hit = hit;
	}
}
   