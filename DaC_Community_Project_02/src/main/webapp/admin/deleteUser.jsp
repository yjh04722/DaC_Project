<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<html>
<head>
    <title>User Deletion</title>
    <script>
        function showAlert(message) {
            alert(message);
        }
        
        function redirectToUserManage() {
            window.location.href = "userManage.jsp";
        }
    </script>
</head>
<body>
<%
    // 이메일 파라미터 가져오기
    String userEmail = request.getParameter("userEmail");

    try {
        // 데이터베이스 연결
        Class.forName("org.mariadb.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac", "root", "1234")) {
            // 삭제 쿼리 실행
            String query = "DELETE FROM user WHERE userEmail = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setString(1, userEmail);
                int rowsAffected = pstmt.executeUpdate();
                
                // 삭제가 성공했는지 여부 확인
                if (rowsAffected > 0) {
%>
                    <script>
                        showAlert("사용자가 성공적으로 삭제되었습니다.");
                        redirectToUserManage();
                    </script>
<%
                } else {
%>
                    <script>
                        showAlert("사용자 삭제에 실패했습니다. 사용자가 존재하지 않을 수 있습니다.");
                        redirectToUserManage();
                    </script>
<%
                }
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
%>
                <script>
                    showAlert("사용자 삭제 중 오류가 발생했습니다. 자세한 내용은 콘솔을 확인하세요.");
                    redirectToUserManage();
                </script>
<%
            }
        } catch (SQLException e) {
            e.printStackTrace();
%>
            <script>
                showAlert("데이터베이스 연결 중 오류가 발생했습니다. 자세한 내용은 콘솔을 확인하세요.");
                redirectToUserManage();
            </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
    <script>
        showAlert("오류가 발생했습니다. 자세한 내용은 콘솔을 확인하세요.");
        redirectToUserManage();
    </script>
<%
    }
%>
</body>
</html>