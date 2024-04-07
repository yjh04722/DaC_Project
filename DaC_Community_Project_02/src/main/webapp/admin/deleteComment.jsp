<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %> <!-- 필요한 클래스 import -->
<!DOCTYPE html>
<html>
<head>
    <title>댓글 삭제 결과</title>
    <!-- 부트스트랩 CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1 class="mt-5">댓글 삭제 결과</h1>
        <% 
        // 댓글 삭제 처리
        boolean isUpdated = false; // 댓글 업데이트 여부, 실제 데이터베이스와 연결하여 처리해야 합니다.
        
        try {
            // 데이터베이스 연결
            Class.forName("org.mariadb.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac?useUnicode=true&characterEncoding=utf8mb4", "root", "1234");

            // 댓글을 "관리자에 의해 삭제된 댓글입니다."로 업데이트하는 쿼리
            String updateQuery = "UPDATE comment SET commentContent = '관리자에 의해 삭제된 댓글입니다.' WHERE commentId = ?";

            // PreparedStatement를 사용하여 쿼리 실행
            PreparedStatement pstmt = conn.prepareStatement(updateQuery);
            pstmt.setInt(1, Integer.parseInt(request.getParameter("commentId"))); // commentId 파라미터 설정

            // 쿼리 실행 및 업데이트된 행 수 반환
            int rowsAffected = pstmt.executeUpdate();

            // 쿼리 실행 결과에 따라 처리
            if (rowsAffected > 0) {
                isUpdated = true;
            }

            // 자원 닫기
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isUpdated) {
        %>
            <script>
                alert("댓글이 성공적으로 삭제되었습니다.");
                window.location.href = "commentManage.jsp"; // 댓글 목록 페이지로 이동
            </script>
        <% } else { %>
            <script>
                alert("댓글 삭제에 실패했습니다.");
                window.location.href = "commentManage.jsp"; // 댓글 목록 페이지로 이동
            </script>
        <% } %>
    </div>
</body>
</html>
