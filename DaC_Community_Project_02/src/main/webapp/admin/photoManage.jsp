<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/include/adminHeader.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="photobbs.PhotoBbs" %> <!-- PhotoBbs 클래스 import -->

<html>
<head>
    <title>Photo Board</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <style>
        .card-content {
            margin-bottom: 0;
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="mb-4">Photo Board</h1>
    
    <% 
        int pageSize = 4; // 페이지당 이미지 수
        int currentPage = 1; // 현재 페이지 (기본값은 1)
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }
        int startRow = (currentPage - 1) * pageSize; // 시작 로우
        int totalSize = 0; // 전체 이미지 수
        try {
            // 데이터베이스 연결
            Class.forName("org.mariadb.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac", "root", "1234");
            Statement stmt = conn.createStatement();
            
            // 전체 이미지 수 조회 쿼리
            String countQuery = "SELECT COUNT(*) AS count FROM photobbs WHERE code = 'photobbs'";
            ResultSet countRs = stmt.executeQuery(countQuery);
            if (countRs.next()) {
                totalSize = countRs.getInt("count");
            }
            countRs.close();
            
            // 이미지 목록 조회 쿼리 (페이징 적용)
            String query = "SELECT * FROM photobbs WHERE code = 'photobbs' ORDER BY bbsId DESC LIMIT ?, ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, startRow);
            pstmt.setInt(2, pageSize);
            ResultSet rs = pstmt.executeQuery();
            
            // 결과를 리스트에 저장
            while (rs.next()) {
                // PhotoBbs 객체 생성
                PhotoBbs image = new PhotoBbs();
                image.setBbsId(rs.getInt("bbsId"));
                image.setPhotoName(rs.getString("photoName"));
                image.setBbsContent(rs.getString("bbsContent"));
                image.setBbsDate(rs.getString("bbsDate"));
                // 이미지 관련 정보 설정
                
    %>
    <div class="card mb-3">
        <div class="row no-gutters">
            <div class="col-md-4">
                <img src="../bbsUpload/<%=image.getPhotoName() %>" class="card-img-top" alt="..." style="width:100px;height:100px;">
            </div>
            <div class="col-md-8">
                <div class="card-body">
                    <p class="card-content"><strong>내용:</strong> <%= image.getBbsContent() %></p>
                    <p class="card-text"><strong>게시일:</strong> <%= image.getBbsDate() %></p>
                    <!-- 이미지 상세 페이지 링크 추가 -->
                    <div class="d-flex justify-content-end">
                        <!-- 모달 토글 버튼 -->
                        <button type="button" class="btn btn-primary mr-2" data-toggle="modal" data-target="#editModal<%= image.getBbsId() %>">Edit</button>
                        <!-- 모달 -->
                        <div class="modal fade" id="editModal<%= image.getBbsId() %>" tabindex="-1" role="dialog" aria-labelledby="editModalLabel<%= image.getBbsId() %>" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editModalLabel<%= image.getBbsId() %>">Edit Image Content</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <!-- 수정 폼 -->
                                        <form id="editForm<%= image.getBbsId() %>" method="post" action="updateImage.jsp" enctype="multipart/form-data">
                                            <input type="hidden" name="bbsId" value="<%= image.getBbsId() %>">
                                            <div class="form-group">
                                                <label for="editContent">내용</label>
                                                <textarea class="form-control" id="editContent" name="editContent" rows="3"><%= image.getBbsContent() %></textarea>
                                            </div>
                                            <div class="form-group">
                                                <label for="editImage">이미지</label>
                                                <input type="file" class="form-control-file" id="editImage" name="editImage">
                                            </div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                        <!-- 수정 버튼 -->
                                        <button type="button" class="btn btn-primary" onclick="document.getElementById('editForm<%= image.getBbsId() %>').submit();">Save changes</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 이미지 삭제 버튼 -->
                        <form method="post" action="deleteImage.jsp">
                            <input type="hidden" name="bbsId" value="<%= image.getBbsId() %>">
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </div>
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
        
        String uri = request.getRequestURI(); // 현재 페이지의 URI 가져오기
        String query = request.getQueryString(); // 쿼리 스트링 가져오기
        String url; // URL 변수 선언
        
        // 쿼리 스트링이 null이 아니면 기존 쿼리 스트링에 page 파라미터를 업데이트하여 URL 구성
        if (query != null) {
            // 기존 페이지 매개변수 제거
            url = uri + "?";
            String[] params = query.split("&");
            for (String param : params) {
                if (!param.startsWith("page=")) {
                    url += param + "&";
                }
            }
        } else {
            url = uri + "?"; // 쿼리 스트링이 없으면 URL 끝에 ? 추가
        }
        
        if (startPage > 1) { // 이전 페이지 링크
    %>
    <li class="page-item"><a class="page-link" href="<%= url + "page=" + (startPage - 1) %>">&laquo;</a></li>
    <% 
        }
        for (int i = startPage; i <= endPage; i++) { // 페이지 링크
    %>
    <li class="page-item <%= i == currentPage ? "active" : "" %>"><a class="page-link" href="<%= url + "page=" + i %>"><%= i %></a></li>
    <% 
        }
        if (endPage < totalPages) { // 다음 페이지 링크
    %>
    <li class="page-item"><a class="page-link" href="<%= url + "page=" + (endPage + 1) %>">&raquo;</a></li>
    <% 
        }
    %>
</ul>

</div>
</body>
</html>
