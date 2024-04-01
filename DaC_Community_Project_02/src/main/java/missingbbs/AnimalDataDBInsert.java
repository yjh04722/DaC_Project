package missingbbs;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;


public class AnimalDataDBInsert {
    private static final String API_URL = "http://apis.data.go.kr/1543061/abandonmentPublicSrvc/abandonmentPublic";
    private static final String SERVICE_KEY = "D7pKWuy44zRHbsCgRoPUhMxnIGzZbgOw8UveNr7mcV3Lca5ujKv1oISnGU2iac60E88PmGsIo%2FAYrlr72WLjTg%3D%3D";
    private static final String START_DATE = "20240323";
    private static final String END_DATE = "20240329";
    private static final String NUM_OF_ROWS = "1000";
    
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/dac";
    private static final String JDBC_USERNAME = "root";
    private static final String JDBC_PASSWORD = "1234";
    
    public static void main(String[] args) {
        fetchAndSaveDataToDB();
        System.out.println("종료");
    }
    
    public static void fetchAndSaveDataToDB() {
        try {
            // Fetch data from API
            StringBuilder urlBuilder = new StringBuilder(API_URL);
            urlBuilder.append("?bgnde=").append(START_DATE);
            urlBuilder.append("&endde=").append(END_DATE);
            urlBuilder.append("&serviceKey=").append(SERVICE_KEY);
            urlBuilder.append("&numOfRows=").append(NUM_OF_ROWS);
            URL url = new URL(urlBuilder.toString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/xml");
            
            // Parse XML response
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(new InputSource(new InputStreamReader(conn.getInputStream(), "UTF-8")));
            
            // Extract data and save to database
            NodeList itemList = document.getElementsByTagName("item");
            for (int i = 0; i < itemList.getLength(); i++) {
                Node itemNode = itemList.item(i);
                if (itemNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element itemElement = (Element) itemNode;
	                    String desertionNo = getNodeTextContent(itemElement,"desertionNo");
	                    String filename = getNodeTextContent(itemElement,"filename");
	                    String happenDt = getNodeTextContent(itemElement,"happenDt");
	                    String happenPlace = getNodeTextContent(itemElement,"happenPlace");
	                	String kindCd = getNodeTextContent(itemElement,"kindCd");
	                	String colorCd = getNodeTextContent(itemElement,"colorCd");
	                	String age = getNodeTextContent(itemElement,"age");
	                	String weight = getNodeTextContent(itemElement,"weight");
	                	String sexCd = getNodeTextContent(itemElement,"sexCd");
	                	String neuterYn = getNodeTextContent(itemElement,"neuterYn");
	                	String specialMark = getNodeTextContent(itemElement,"specialMark");
	                	String careNm = getNodeTextContent(itemElement,"careNm");
	                	String careTel = getNodeTextContent(itemElement,"careTel");
	                	String careAddr = getNodeTextContent(itemElement,"careAddr");
	                	String orgNm = getNodeTextContent(itemElement,"orgNm");
	                	String chargeNm = getNodeTextContent(itemElement,"chargeNm");
	                	String officetel = getNodeTextContent(itemElement,"officetel");
                    
	            if (filename != null && happenDt != null) {
                    insertData(desertionNo, filename, happenDt, happenPlace, kindCd, colorCd, age, weight, 
                    		sexCd, neuterYn, specialMark, careNm, careTel, careAddr, orgNm, chargeNm, officetel);
	            	}
	            }
            }
            conn.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private static String getNodeTextContent(Element element, String tagName) {
        Node node = element.getElementsByTagName(tagName).item(0);
        return node != null ? node.getTextContent() : null;
    }
    
    private static void insertData(String desertionNo, String filename, String happenDt, String happenPlace, String kindCd,
    		String colorCd, String age, String weight, String sexCd, String neuterYn, String specialMark, String careNm, 
    		String careTel, String careAddr, String orgNm, String chargeNm, String officetel) {
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD)) {
            String sql = "INSERT INTO abanDog (desertionNo, filename, happenDt,"
            		+ "happenPlace, kindCd, colorCd, age, weight, sexCd,"
            		+ "neuterYn, specialMark, careNm, careTel, careAddr, orgNm, chargeNm, officetel) "
            		+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, desertionNo);
                pstmt.setString(2, filename);
                pstmt.setString(3, happenDt);
                pstmt.setString(4, happenPlace);
                pstmt.setString(5, kindCd);
                pstmt.setString(6, colorCd);
                pstmt.setString(7, age);
                pstmt.setString(8, weight);
                pstmt.setString(9, sexCd);
                pstmt.setString(10, neuterYn);
                pstmt.setString(11, specialMark);
                pstmt.setString(12, careNm);
                pstmt.setString(13, careTel);
                pstmt.setString(14, careAddr);
                pstmt.setString(15, orgNm);
                pstmt.setString(16, chargeNm);
                pstmt.setString(17, officetel);
                pstmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }   
    }
    
}