package board;

public class BoardDTO {
    private int num;        // 게시물의 고유 번호
    private String id;      // 게시물을 작성한 사용자의 식별자
    private String writer;  // 게시물을 작성한 사용자의 이름
    private String subject; // 게시물의 제목
    private String regDate; // 게시물의 작성일시
    private int readcount;  // 게시물의 조회수
    private int ref;        // 답글의 그룹을 식별하기 위한 참조 번호
    private int reStep;     // 답글의 순서를 나타내는 단계
    private int reLevel;    // 답글의 깊이를 나타내는 수준
    private String content; // 게시물의 내용
    private String ip;      // 게시물을 작성한 사용자의 IP 주소
    private int status;     // 게시물의 상태를 나타내는 필드 (예: 게시, 비게시)
    
    
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public int getReadcount() {
		return readcount;
	}
	public void setReadcount(int readcount) {
		this.readcount = readcount;
	}
	public int getRef() {
		return ref;
	}
	public void setRef(int ref) {
		this.ref = ref;
	}
	public int getReStep() {
		return reStep;
	}
	public void setReStep(int reStep) {
		this.reStep = reStep;
	}
	public int getReLevel() {
		return reLevel;
	}
	public void setReLevel(int reLevel) {
		this.reLevel = reLevel;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	} 
}
