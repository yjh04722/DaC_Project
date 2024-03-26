package photobbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class PhotoBbsDAO {
	private Connection conn; 
	private ResultSet rs;
	PreparedStatement pstmt;
	
	// db 접속
	public PhotoBbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/dac";
			String dbID = "root";
			String dbPassword = "1234";
			Class.forName("org.mariadb.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// 게시글 인덱스
	public int getNext() {
		String SQL = "SELECT bbsId FROM photobbs ORDER BY bbsId DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //DB 오류 
	}
	
	// 날짜 구하기
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //DB 오류 
	}
	
	// 이미지 이름 반환
	public String selectPhotoName(int bbsId) {
		String photoName = "";
		String SQL = "SELECT photoName From photobbs WHERE bbsId=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				photoName = rs.getString("photoName");
				
				return photoName;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //DB 오류 
	}
	
	// 이미지 목록보기 & 10행씩 반환(LIMIT)
	public ArrayList<PhotoBbs> getList(int pageNumber){
		String SQL = "SELECT * FROM photobbs WHERE bbsId < ? AND bbsAvailable = 1 ORDER BY bbsId DESC LIMIT 6";
		ArrayList<PhotoBbs> list = new ArrayList<PhotoBbs>();
		try {

			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-( pageNumber - 1 ) * 6);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PhotoBbs photoBbs = new PhotoBbs();
				photoBbs.setBbsId(rs.getInt(1));
				photoBbs.setPhotoName(rs.getString(2));
				photoBbs.setUserId(rs.getString(3));
				photoBbs.setBbsDate(rs.getString(4));
				photoBbs.setBbsContent(rs.getString(5));
				photoBbs.setBbsAvailable(rs.getInt(6));
				list.add(photoBbs);	
			}
		}catch(Exception e) {
			System.out.println("목록 불러오기 실패 : " + e);
		}
		return list;
	}
	
	// 전체 행 수
	public int selectPhotoTotalRow() {
		int total = 0;
		String SQL = "SELECT COUNT(*) as cnt FROM photobbs";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			System.out.println("[SQL selectPhotoTotalRow] : " + pstmt);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				total = rs.getInt("cnt");
				
				return total;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //DB 오류 
	}
	
	// 게시판 글작성 DB저장
	public int write(String photoName, String userId, String bbsContent){
		String SQL = "INSERT INTO photobbs VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, photoName);
			pstmt.setString(3, userId);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //DB 오류 
	}
	
	// 해당 페이지로 넘어갈 수 있는지 검사 
	public boolean nextPage(int pageNumber){
		String SQL = "SELECT * FROM photobbs WHERE bbsId < ? AND bbsAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pageNumber -1)*10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				return true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return false; 
	}
}
