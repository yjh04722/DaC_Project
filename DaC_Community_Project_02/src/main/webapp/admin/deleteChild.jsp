<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<html>
<head>
    <title>Delete Child Post</title>
</head>
<body>
<%
    // 자식글 번호를 가져옴
    int num = Integer.parseInt(request.getParameter("num"));

    // 데이터베이스 연결 및 자식글 삭제
    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac", "root", "1234");
        
        // 자식글 삭제 쿼리
        String deleteQuery = "DELETE FROM board WHERE num = ?";
        pstmt = conn.prepareStatement(deleteQuery);
        pstmt.setInt(1, num);
        
        int rowsAffected = pstmt.executeUpdate(); // 삭제된 행 수를 반환
        
        if (rowsAffected > 0) {
            // 삭제 성공 시
            out.println("alert('자식글 삭제에 성공했습니다.');");
            response.sendRedirect("qnaManage.jsp"); // 삭제 후 목록 페이지로 이동
        } else {
            // 삭제 실패 시
            out.println("<script>");
            out.println("alert('자식글 삭제에 실패했습니다.');");
            out.println("history.back();"); // 이전 페이지로 이동
            out.println("</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // 자원 해제
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
</body>
</html>
