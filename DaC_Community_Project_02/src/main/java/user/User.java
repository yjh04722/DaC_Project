package user;

public class User {
	private String userEmail;
	private String userPassword;
	private String userName;
	private String userAddr;
	private String userLevel;
	
	
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

	public String getUserLevel() {
		return userLevel;
	}

	public void setUserLevel(String userLevel) {
		this.userLevel = userLevel;
	}

	@Override
	public String toString() {
		return "User [userEmail=" + userEmail + ", userPassword=" + userPassword + ", userName=" + userName
				+ ", userAddr=" + userAddr + ", userLevel=" + userLevel + "]";
	}
	

	
    
	
}