<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, board.BoardDTO" %> <!-- 필요한 클래스 import -->

<%
request.setCharacterEncoding("UTF-8"); // 이 코드는 이미 존재하고 있습니다.

// 요청으로부터 파라미터를 가져옵니다.
String type = request.getParameter("type");
int num = Integer.parseInt(request.getParameter("num"));
String subject = request.getParameter("subject");
String content = request.getParameter("content");

// 업데이트 프로세스 로직
try {
    // 데이터베이스 연결
    Class.forName("org.mariadb.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac?useUnicode=yes&characterEncoding=UTF-8", "root", "1234");
    
    // 업데이트 쿼리
    String updateQuery = "UPDATE board SET subject=?, content=? WHERE num=?";
    PreparedStatement pstmt = conn.prepareStatement(updateQuery);
    pstmt.setString(1, subject);
    pstmt.setString(2, content);
    pstmt.setInt(3, num);
    
    // 업데이트 쿼리 실행
    int rowsAffected = pstmt.executeUpdate();
    
    // 자원 닫기
    pstmt.close();
    conn.close();
    
    // 업데이트 성공 후 게시판 페이지로 리다이렉트
    response.sendRedirect("qnaManage.jsp");
} catch (Exception e) {
    e.printStackTrace();
    // 예외를 적절하게 처리합니다. 에러 메시지를 표시하는 등의 작업이 필요합니다.
    // 필요에 따라 사용자 입력의 유효성 검사와 SQL 인젝션 등의 보안 취약점 방지를 위한 작업을 추가할 수 있습니다.
}
%>
