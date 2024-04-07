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
        String updateQuery = "UPDATE user SET userPassword = ?, userName = ?, addr = ?, userLevel = ? WHERE userEmail = ?";
        PreparedStatement pstmt = conn.prepareStatement(updateQuery);
        pstmt.setString(1, password);
        pstmt.setString(2, name);
        pstmt.setString(3, address);
        pstmt.setString(4, level);
        pstmt.setString(5, email);

        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();
        conn.close();

        if (rowsAffected > 0) {
            // 업데이트가 성공한 경우
            out.println("<script>alert('사용자 정보가 성공적으로 업데이트되었습니다.'); window.location.href='userManage.jsp';</script>");
        } else {
            // 업데이트가 실패한 경우
            out.println("<script>alert('사용자 정보 업데이트에 실패했습니다.'); window.location.href='userManage.jsp';</script>");
        }
    } catch (Exception e) {
        // 예외 발생 시
        e.printStackTrace();
        out.println("<script>alert('사용자 정보를 업데이트하는 중에 오류가 발생했습니다.'); window.location.href='userManage.jsp';</script>");
    }
}
%>
