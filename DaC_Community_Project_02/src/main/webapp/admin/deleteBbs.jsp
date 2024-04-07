<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // 삭제할 게시물의 ID를 파라미터로부터 받아옴
    int bbsId = Integer.parseInt(request.getParameter("bbsId"));
    
    try {
        // 데이터베이스 연결
        Class.forName("org.mariadb.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac?useUnicode=true&characterEncoding=UTF-8", "root", "1234");
        
        // 게시물 삭제 쿼리 실행
        String query = "DELETE FROM bbs WHERE bbsId = ?";
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, bbsId);
        int rowsAffected = pstmt.executeUpdate();
        
        pstmt.close();
        conn.close();
        
        if (rowsAffected > 0) {
            // 삭제 완료 메시지 표시
            out.println("<script>alert('게시물이 성공적으로 삭제되었습니다.'); window.location.href='./freeManage.jsp';</script>");
        } else {
            // 삭제 실패 메시지 표시
            out.println("<script>alert('게시물 삭제에 실패했습니다.'); window.location.href='./freeManage.jsp';</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
