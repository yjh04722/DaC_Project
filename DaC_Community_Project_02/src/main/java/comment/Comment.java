package comment;

public class Comment {
	private String commentContent;
	private int commentId;
	private String userId;
	private int commentAvailable;
	private int bbsId;
	private String commentDate;
	
	public String getCommentContent() {
		return commentContent;
	}
	
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}
	
	public int getCommentId() {
		return commentId;
	}
	
	public void setCommentID(int commentId) {
		this.commentId = commentId;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public int getCommentAvailable() {
		return commentAvailable;
	}
	
	public void setCommentAvailable(int commentAvailable) {
		this.commentAvailable = commentAvailable;
	}
	
	public int getBbsId() {
		return bbsId;
	}
	
	public void setBbsId(int bbsId) {
		this.bbsId = bbsId;
	}
	
	public String getCommentDate() {
		return commentDate;
	}
	
	public void setCommentDate(String commentDate) {
		this.commentDate = commentDate;
	}

	@Override
	public String toString() {
		return "Comment [commentContent=" + commentContent + ", commentId=" + commentId + ", userId=" + userId
				+ ", commentAvailable=" + commentAvailable + ", bbsId=" + bbsId + ", commentDate=" + commentDate + "]";
	}
	
}

