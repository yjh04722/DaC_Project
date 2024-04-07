package visitor;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.Date;

public class VisitorFilter implements Filter {
    private FilterConfig filterConfig;

    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        String ipAddress = req.getRemoteAddr(); // 클라이언트 IP 주소 가져오기

        // 방문자 정보 저장
        saveVisitorInfo(ipAddress);

        chain.doFilter(request, response);
    }

    public void destroy() {
        // 필터 종료 시 호출되는 메서드
    }

    public void saveVisitorInfo(String ipAddress) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            // JDBC 드라이버 로드
            Class.forName("org.mariadb.jdbc.Driver");

            // 데이터베이스 연결 및 쿼리 실행
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac", "root", "1234");
            String sql = "INSERT INTO VisitorStats (ipAddress, visitDate) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, ipAddress);
            pstmt.setTimestamp(2, new Timestamp(new Date().getTime()));
            pstmt.executeUpdate();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            // 리소스 해제
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
