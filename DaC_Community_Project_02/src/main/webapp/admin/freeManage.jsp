<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/include/adminHeader.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="bbs.Bbs" %> <!-- Bbs 클래스 import -->

<html>
<head>
    <title>Free Board</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
    <h1>Free Board</h1>
    
    <% 
        int pageSize = 3; // 페이지당 게시글 수
        int currentPage = 1; // 현재 페이지 (기본값은 1)
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }
        int startRow = (currentPage - 1) * pageSize; // 시작 로우
        int totalSize = 0; // 전체 게시글 수
        try {
            // 데이터베이스 연결
            Class.forName("org.mariadb.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac?useUnicode=true&characterEncoding=UTF-8", "root", "1234");
            Statement stmt = conn.createStatement();
            
            // 전체 게시글 수 조회 쿼리
            String countQuery = "SELECT COUNT(*) AS count FROM bbs";
            ResultSet countRs = stmt.executeQuery(countQuery);
            if (countRs.next()) {
                totalSize = countRs.getInt("count");
            }
            countRs.close();
            
            // 게시글 목록 조회 쿼리 (페이징 적용)
            String query = "SELECT * FROM bbs ORDER BY bbsId DESC LIMIT ?, ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, startRow);
            pstmt.setInt(2, pageSize);
            ResultSet rs = pstmt.executeQuery();
            
            // 결과를 리스트에 저장
            while (rs.next()) {
                // Bbs 객체 생성
                Bbs board = new Bbs();
                board.setBbsId(rs.getInt("bbsId"));
                board.setBbsTitle(rs.getString("bbsTitle"));
                board.setUserId(rs.getString("userId"));
                board.setBbsDate(rs.getString("bbsDate"));
                board.setBbsContent(rs.getString("bbsContent"));
                board.setBbsAvailable(rs.getInt("bbsAvailable"));
                board.setCode(rs.getString("code"));
    %>
    <div class="card mb-3">
        <div class="card-header">
            <%= board.getBbsTitle() %>
        </div>
        <div class="card-body">
            <p class="card-text"><%= board.getBbsContent() %></p>
            <p class="card-text">작성자: <%= board.getUserId() %></p>
            <p class="card-text">작성일자: <%= board.getBbsDate() %></p>
            <!-- 수정 버튼 클릭시 모달 창 띄우기 -->
            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#editModal<%= board.getBbsId() %>">Edit</button>
            <a href="deleteBbs.jsp?bbsId=<%= board.getBbsId() %>" class="btn btn-danger">Delete</a>
        </div>
    </div>

    <!-- 수정 모달 창 -->
    <div class="modal fade" id="editModal<%= board.getBbsId() %>" tabindex="-1" role="dialog" aria-labelledby="editModalLabel<%= board.getBbsId() %>" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editModalLabel<%= board.getBbsId() %>">Edit Bbs</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="updateBbs.jsp" method="post">
                        <!-- 수정할 내용 입력 -->
                        <input type="hidden" name="bbsId" value="<%= board.getBbsId() %>">
                        <div class="form-group">
                            <label for="bbsTitle">Title</label>
                            <input type="text" class="form-control" id="bbsTitle" name="bbsTitle" value="<%= board.getBbsTitle() %>">
                            <input type="text" class="form-control" id="bbsAvailable" name="bbsAvailable" value="<%= board.getBbsAvailable() %>">
                        </div>
                        <div class="form-group">
                            <label for="bbsContent">Content</label>
                            <textarea class="form-control" id="bbsContent" name="bbsContent" rows="3"><%= board.getBbsContent() %></textarea>
                        </div>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save changes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <% 
            }
            rs.close();
            pstmt.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    
    <!-- 페이징 -->
    <ul class="pagination justify-content-center">
        <% 
            int totalPages = (int) Math.ceil((double) totalSize / pageSize); // 총 페이지 수
            int pageBlockSize = 5; // 한 번에 보여줄 페이지 수
            int startPage = Math.max(1, currentPage - (pageBlockSize / 2)); // 시작 페이지
            int endPage = Math.min(startPage + pageBlockSize - 1, totalPages); // 끝 페이지
            
            if (startPage > 1) { // 이전 페이지 링크
        %>
        <li class="page-item"><a class="page-link" href="?page=<%= startPage - 1 %>">&laquo;</a></li>
        <% 
            }
            for (int i = startPage; i <= endPage; i++) { // 페이지 링크
        %>
        <li class="page-item <%= i == currentPage ? "active" : "" %>"><a class="page-link" href="?page=<%= i %>"><%= i %></a></li>
        <% 
            }
            if (endPage < totalPages) { // 다음 페이지 링크
        %>
        <li class="page-item"><a class="page-link" href="?page=<%= endPage + 1 %>">&raquo;</a></li>
        <% 
            }
        %>
    </ul>
</div>
</body>
</html>
