<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*, java.sql.*" %>
<%@ page import="javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="photobbs.PhotoBbs" %> <!-- PhotoBbs 클래스 import -->

<%
// 이미지 내용과 이미지 파일을 업데이트하는 페이지

// 데이터베이스 연결
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
try {
    // 업로드된 파일을 저장할 디렉토리 경로
    String uploadDir = getServletContext().getRealPath("/") + "bbsUpload/";

    // 파일 업로드를 위한 MultipartRequest 생성
    int maxFileSize = 10 * 1024 * 1024; // 최대 파일 크기 10MB
    String encoding = "UTF-8";
    MultipartRequest multi = new MultipartRequest(request, uploadDir, maxFileSize, encoding, new DefaultFileRenamePolicy());

    // 요청 파라미터에서 이미지 내용과 이미지 파일 정보 추출
    String editContent = multi.getParameter("editContent");
    Enumeration files = multi.getFileNames();
    String fileName = "";
    if (files.hasMoreElements()) {
        String name = (String) files.nextElement();
        fileName = multi.getFilesystemName(name);
    }

    // 요청 파라미터로 전달받은 이미지 ID 가져오기
    int bbsId = Integer.parseInt(multi.getParameter("bbsId"));

    // 데이터베이스 연결
    Class.forName("org.mariadb.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac", "root", "1234");

    // 이미지 내용 업데이트 쿼리
    String updateQuery = "UPDATE photobbs SET bbsContent = ?, photoName = ? WHERE bbsId = ?";
    pstmt = conn.prepareStatement(updateQuery);
    pstmt.setString(1, editContent);
    pstmt.setString(2, fileName);
    pstmt.setInt(3, bbsId);
    pstmt.executeUpdate();

    // 업데이트 성공 시, 이전 페이지로 이동
    response.sendRedirect("photoManage.jsp");
} catch (Exception e) {
    e.printStackTrace();
} finally {
    // 리소스 해제
    try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
    try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
    try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
}
%>
