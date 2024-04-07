<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/adminHeader.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="bbs.Bbs" %> <!-- Bbs 클래스 import -->

<%
	request.setCharacterEncoding("UTF-8");
    // 게시물 수정 처리
    if (request.getMethod().equals("POST")) {
        int bbsId = Integer.parseInt(request.getParameter("bbsId"));
        int bbsAvailable = Integer.parseInt(request.getParameter("bbsAvailable"));
        String bbsTitle = request.getParameter("bbsTitle");
        String bbsContent = request.getParameter("bbsContent");
        
        try {
            // 데이터베이스 연결
            Class.forName("org.mariadb.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac?useUnicode=true&characterEncoding=UTF-8", "root", "1234");
            PreparedStatement pstmt = conn.prepareStatement("UPDATE bbs SET bbsTitle = ?, bbsContent = ?, bbsAvailable = ? WHERE bbsId = ?");
            pstmt.setString(1, bbsTitle);
            pstmt.setString(2, bbsContent);
            pstmt.setInt(3, bbsAvailable);
            pstmt.setInt(4, bbsId);
            
            pstmt.executeUpdate(); // 쿼리 실행
            
            pstmt.close();
            conn.close();
            
            // 수정 완료 후 목록 페이지로 이동
            response.sendRedirect("freeManage.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!-- 수정 완료 메시지 -->
<div class="container">
    <div class="alert alert-success" role="alert">
        게시물이 성공적으로 수정되었습니다.
    </div>
</div>

<!-- 수정 완료 알림 -->
<script>
    alert("게시물이 성공적으로 수정되었습니다.");
</script>
