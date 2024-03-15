package user;

public class User {
	private String userEmail;
	private String userPassword;
	private String userName;
	private String userAddr;
	private String userId;
	
	
	public String getUserEmail() {
		return userEmail;
	}
	
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	
	public String getUserPassword() {
		return userPassword;
	}
	
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	
	public String getUserName() {
		return userName;
	}
	
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getUserAddr() {
		return userAddr;
	}
	
	public void setUserAddr(String userAddr) {
		this.userAddr = userAddr;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId =userId;
	}

	@Override
	public String toString() {
		return "User [userEmail=" + userEmail + ", userPassword=" + userPassword + ", userName=" + userName
				+ ", userAddr=" + userAddr + ", userId=" + userId + "]";
	}
	
	// 로그인 정보 담을 객체
    
	
}