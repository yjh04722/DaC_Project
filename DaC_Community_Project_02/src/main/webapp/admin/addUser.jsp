<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="user.User" %> <!-- 사용자 클래스 import -->
<%@ page import="java.util.regex.Pattern" %>

<%
request.setCharacterEncoding("UTF-8");

// POST 요청에서 사용자가 입력한 정보를 받아옵니다.
String email = request.getParameter("email");
String password = request.getParameter("password");
String name = request.getParameter("name");
String address = request.getParameter("address");
String level = request.getParameter("level");

if (email == null || email.isEmpty() || password == null || password.isEmpty() || name == null || name.isEmpty() || address == null || address.isEmpty() || level == null || level.isEmpty()) {
    // 필수 입력 필드 중 하나라도 비어있는 경우
    out.println("<script>alert('모든 필드는 필수입니다.'); window.location.href='userManage.jsp';</script>");
} else {
    try {
        // 데이터베이스 연결
        Class.forName("org.mariadb.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/dac?useUnicode=true&characterEncoding=UTF-8";
        Connection conn = DriverManager.getConnection(url, "root", "1234");

        // 사용자 정보 업데이트 쿼리
        String insertQuery = "INSERT INTO user (userEmail, userPassword, userName, addr, userLevel) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(insertQuery);
        pstmt.setString(1, email);
        pstmt.setString(2, password);
        pstmt.setString(3, name);
        pstmt.setString(4, address);
        pstmt.setString(5, level);

        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();
        conn.close();

        if (rowsAffected > 0) {
            // 추가가 성공한 경우
            out.println("<script>alert('새로운 사용자가 추가되었습니다.'); window.location.href='userManage.jsp';</script>");
        } else {
            // 추가가 실패한 경우
            out.println("<script>alert('사용자 추가에 실패했습니다.'); window.location.href='userManage.jsp';</script>");
        }
    } catch (Exception e) {
        // 예외 발생 시
        e.printStackTrace();
        out.println("<script>alert('사용자 추가 중에 오류가 발생했습니다.'); window.location.href='userManage.jsp';</script>");
    }
}
%>
