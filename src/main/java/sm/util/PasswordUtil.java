package sm.util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

//비번 해시와 솔트 생성 메서드
public class PasswordUtil {
	//16바이트 솔트
	private static final int SALT_LEN = 16;
	//65536번 반복
	private static final int ITERATION = 65536;
	//최종 256비트 키 생성
	private static final int KEY_LEN = 256;
	
	//16 바이트 솔트 생성 및 Base64로 인코딩 된 문자열 번호
	public static String generateSalt() {
		//16바이트 솔트 배열 생성
		byte[] salt = new byte[SALT_LEN];
		//무작위 숫자 생성
		new SecureRandom().nextBytes(salt);
		//Base64로 인코딩해 반환
		return Base64.getEncoder().encodeToString(salt);
		
	}//end
	
	//password + salt 로 해시 생성 매서드(PBKDF2WithHmacSHA256)
	public static String passwordHash(String password, String salt) {
		try {
			PBEKeySpec space = new PBEKeySpec(password.toCharArray(), Base64.getDecoder().decode(salt), ITERATION, KEY_LEN);
			SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
			byte[] hash = skf.generateSecret(space).getEncoded();
			return Base64.getEncoder().encodeToString(hash);
		} catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
			throw new RuntimeException("Password hashing failed", e);
		}
	
	}
	
}
