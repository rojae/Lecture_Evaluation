package user;


public class UserDTO {
	private String userID;
	String userPassword;
	private String userEmail;
	private String userEmailHash;
	private boolean userEmailchecked;
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getUserPassword() {
		return userPassword;
	}
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getUserEmailHash() {
		return userEmailHash;
	}
	public void setUserEmailHash(String userEmailHash) {
		this.userEmailHash = userEmailHash;
	}
	public boolean isUserEmailchecked() {
		return userEmailchecked;
	}
	public void setUserEmailchecked(boolean userEmailchecked) {
		this.userEmailchecked = userEmailchecked;
	}
	public UserDTO() {
		
	}
	public UserDTO(String userID, String userPassword, String userEmail, String userEmailHash, boolean userEmailchecked) {
		this.userID = userID;
		this.userPassword = userPassword;
		this.userEmail = userEmail;
		this.userEmailHash = userEmailHash;
		this.userEmailchecked = userEmailchecked;
	}
	
}
