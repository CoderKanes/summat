package sm.util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {
											  
	private static final String SMTP_HOST = "smtp.gmail.com";  
    private static final String SMTP_PORT = "587";  
    private static final String SMTP_USER = "";  
    private static final String SMTP_PASSWORD = ""; 
    
    
    
    
    //Session생성 메서드
    private static Session createSession() {
    	Properties properties = new Properties();
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
                    }
                });
        return session;
    }
	
    //이메일 보내기 
	public static void sendEmail(String to, String subject, String body) throws Exception {
		Session session = createSession();
		
		Message message = new MimeMessage(session);
		//보내는 주소
		message.setFrom(new InternetAddress(SMTP_USER, "No-Prply"));
		//받는 주소
		message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("darkelf1304@naver.com"));
		session.setDebug(true);
		message.setSubject(subject);
		message.setText(body);

		Transport.send(message);
		
	}
	
	// 예시 메인
    public static void main(String[] args) {
        try {
            sendEmail("kdw8309@gmail.com",
                    "테스트 제목",
                    "안녕하세요, 이 이메일은 Jakarta Mail 테스트입니다.");
            System.out.println("Email sent successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
	
}
