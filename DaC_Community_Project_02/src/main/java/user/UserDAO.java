package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet; // 단축키 : ctrl + shift + 'o'
import javax.security.auth.message.callback.PrivateKeyCallback.Request;
import javax.servlet.http.HttpSession;
import org.eclipse.jdt.internal.compiler.ast.ContinueStatement;

public class UserDAO {
	private Connection conn; 
	private PreparedStatement pstmt;
	private ResultSet rs; 
	
	public UserDAO() { 
		try {
			String dbURL = "jdbc:mysql://localhost:3306/dac"; //MariaDB 서버의 DAC DB 접근 경로
			String dbID = "root"; //계정
			String dbPassword = "1234"; //비밀번호
			Class.forName("org.mariadb.jdbc.Driver"); //MariaDB에 접속을 도와주는 라이브러리 
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// 로그인 기능 
	public String login(String userEmail, String userPassword) {
		String SQL = "SELECT userEmail, userPassword, userLevel FROM user WHERE userEmail = ?";
		User user = new User();
		String userLevel = null;
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userEmail);
			rs = pstmt.executeQuery(); // 쿼리 실행
			
			if(rs.next()) {
				userLevel = rs.getString(3);
				if (rs.getString(2).equals(userPassword)) { // rs.getString(1) : select된 첫번째 컬럼
					System.out.println(userLevel);
					
					return userLevel; //로그인 성공
				}else {
					return "0"; // 비밀번호 틀림
				}
			}
			return "-1"; // 아이디 없음 
		}catch(Exception e) {
			e.printStackTrace();	
		}
		return "-2"; //DB 오류 
	}
		
	// 회원가입 기능
	public int join(User user) {
		String SQL = "INSERT INTO user VALUES(?, ?, ?, ?, ?);";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserEmail());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserAddr());
			pstmt.setString(5, "1");      // 1 : 일반 유저  || 2 : 관리자
			return pstmt.executeUpdate(); // 0이상 값이 return된 경우 성공 
		}catch(Exception e) {
			e.printStackTrace();
			
		}
		return -1; //DB 오류 
	}
		
	//아이디중복체크 메서드
	public int joinIdCheck(String userEmail){
		int result = -1;
		try {
			String SQL = "SELECT userEmail FROM user WHERE userEmail = ?";
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userEmail);
	
			rs = pstmt.executeQuery();
	
	
			if(rs.next()){	
				result = 0; // 성공
			}else{
				result = 1; // 실패
			}
	
			System.out.println("아이디 중복체크결과 : " + result);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return result; // -1 : DB 오류
		}	
	}