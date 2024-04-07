<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // 삭제할 이미지의 ID를 파라미터로부터 받아옵니다.
    int bbsId = Integer.parseInt(request.getParameter("bbsId"));
    
    // 데이터베이스 연결
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac", "root", "1234");
        
        // 이미지 삭제 쿼리
        String deleteQuery = "DELETE FROM photobbs WHERE bbsId = ?";
        pstmt = conn.prepareStatement(deleteQuery);
        pstmt.setInt(1, bbsId);
        
        // 쿼리 실행
        int rowsAffected = pstmt.executeUpdate();
        
        // 삭제 성공 여부 확인
        if (rowsAffected > 0) {
            // 이미지 삭제 성공 시 메시지 출력
            out.println("<script>alert('이미지가 성공적으로 삭제되었습니다.');</script>");
        } else {
            // 이미지 삭제 실패 시 메시지 출력
            out.println("<script>alert('이미지 삭제에 실패했습니다.');</script>");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // 자원 해제
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // 삭제 후 이미지 목록 페이지로 리다이렉트
    response.sendRedirect("photoManage.jsp");
%>