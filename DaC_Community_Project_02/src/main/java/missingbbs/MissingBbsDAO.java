package missingbbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import missingbbs.MissingBbs;

public class MissingBbsDAO {
	private Connection conn; 
	private ResultSet rs;
	PreparedStatement pstmt;
	
	// db 접속
	public MissingBbsDAO() {
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
			String SQL = "SELECT bbsId FROM abandog ORDER BY bbsId DESC";
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
	
	// 이미지 목록보기 & 6행씩 반환(LIMIT)
	public ArrayList<MissingBbs> getList(int pageNumber){
		String SQL = "SELECT * FROM abandog WHERE bbsId < ? ORDER BY bbsId DESC LIMIT 6";
		ArrayList<MissingBbs> list = new ArrayList<MissingBbs>();
		try {

			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-( pageNumber - 1 ) * 6);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				MissingBbs missingBbs = new MissingBbs();
				missingBbs.setBbsId(rs.getInt(1));
				missingBbs.setDesertionNo(rs.getString(2));
				missingBbs.setFilename(rs.getString(3));
				missingBbs.setHappenDt(rs.getString(4));
				missingBbs.setHappenPlace(rs.getString(5));
				missingBbs.setKindCd(rs.getString(6));
				missingBbs.setColorCd(rs.getString(7));
				missingBbs.setAge(rs.getString(8));
				missingBbs.setWeight(rs.getString(9));
				missingBbs.setSexCd(rs.getString(10));
				missingBbs.setNeuterYn(rs.getString(11));
				missingBbs.setSpecialMark(rs.getString(12));
				missingBbs.setCareNm(rs.getString(13));
				missingBbs.setCareTel(rs.getString(14));
				missingBbs.setCareAddr(rs.getString(15));
				missingBbs.setOrgNm(rs.getString(16));
				missingBbs.setChargeNm(rs.getString(17));
				missingBbs.setOfficetel(rs.getString(18));
				list.add(missingBbs);	
			}
		}catch(Exception e) {
			System.out.println("목록 불러오기 실패 : " + e);
		}
		return list;
	}
	
	// 이미지 목록보기 & 2행씩 반환(LIMIT)
	public ArrayList<MissingBbs> getList2(int pageNumber){
		String SQL = "SELECT * FROM abandog WHERE bbsId < ? ORDER BY bbsId DESC LIMIT 1";
		ArrayList<MissingBbs> list2 = new ArrayList<MissingBbs>();
		try {

			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-( pageNumber - 1 ) * 1);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				MissingBbs missingBbs = new MissingBbs();
				missingBbs.setBbsId(rs.getInt(1));
				missingBbs.setDesertionNo(rs.getString(2));
				missingBbs.setFilename(rs.getString(3));
				missingBbs.setHappenDt(rs.getString(4));
				missingBbs.setHappenPlace(rs.getString(5));
				missingBbs.setKindCd(rs.getString(6));
				missingBbs.setColorCd(rs.getString(7));
				missingBbs.setAge(rs.getString(8));
				missingBbs.setWeight(rs.getString(9));
				missingBbs.setSexCd(rs.getString(10));
				missingBbs.setNeuterYn(rs.getString(11));
				missingBbs.setSpecialMark(rs.getString(12));
				missingBbs.setCareNm(rs.getString(13));
				missingBbs.setCareTel(rs.getString(14));
				missingBbs.setCareAddr(rs.getString(15));
				missingBbs.setOrgNm(rs.getString(16));
				missingBbs.setChargeNm(rs.getString(17));
				missingBbs.setOfficetel(rs.getString(18));
				list2.add(missingBbs);	
			}
		}catch(Exception e) {
			System.out.println("목록 불러오기 실패 : " + e);
		}
		return list2;
	}
	
	// 총게시글 수
	public int getCount() {
		String SQL = "SELECT COUNT(*) FROM abandog WHERE bbsId";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {	
				return rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public ArrayList<MissingBbs> getSearch(String searchText){//특정한 리스트를 받아서 반환
	      ArrayList<MissingBbs> list = new ArrayList<MissingBbs>();
	      String SQL ="select * from abandog where happenPlace";
	      try {
	            if(searchText != null && !searchText.equals("") ){
	                SQL +=" LIKE '%"+searchText.trim()+"%' order by bbsId desc limit 6";
	            }
	            PreparedStatement pstmt=conn.prepareStatement(SQL);
				rs=pstmt.executeQuery();//select
	         while(rs.next()) {
					MissingBbs missingBbs = new MissingBbs();
					missingBbs.setBbsId(rs.getInt(1));
					missingBbs.setDesertionNo(rs.getString(2));
					missingBbs.setFilename(rs.getString(3));
					missingBbs.setHappenDt(rs.getString(4));
					missingBbs.setHappenPlace(rs.getString(5));
					missingBbs.setKindCd(rs.getString(6));
					missingBbs.setColorCd(rs.getString(7));
					missingBbs.setAge(rs.getString(8));
					missingBbs.setWeight(rs.getString(9));
					missingBbs.setSexCd(rs.getString(10));
					missingBbs.setNeuterYn(rs.getString(11));
					missingBbs.setSpecialMark(rs.getString(12));
					missingBbs.setCareNm(rs.getString(13));
					missingBbs.setCareTel(rs.getString(14));
					missingBbs.setCareAddr(rs.getString(15));
					missingBbs.setOrgNm(rs.getString(16));
					missingBbs.setChargeNm(rs.getString(17));
					missingBbs.setOfficetel(rs.getString(18));
					list.add(missingBbs);
	         }  
	         
	         System.out.println("정상 등록");
	      } catch(Exception e) {
	         e.printStackTrace();
	      }
	      return list;//게시글 리스트 반환
	   }
}
