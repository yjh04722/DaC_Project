<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/include/adminHeader.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="board.BoardDTO" %> <!-- BoardDTO 클래스 import -->

<html>
<head>
    <title>Q&A Management</title>
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
    <h1 class="mb-4">Q&A Management</h1>
    
    <h2>Parent Posts</h2>
    <% 
        int parentPageSize = 2; // 페이지당 부모글 수
        int parentCurrentPage = 1; // 현재 페이지 (기본값은 1)
        if (request.getParameter("parentPage") != null) {
            parentCurrentPage = Integer.parseInt(request.getParameter("parentPage"));
        }
        int parentStartRow = (parentCurrentPage - 1) * parentPageSize; // 시작 로우
        int parentTotalSize = 0; // 전체 부모글 수
        
        // 데이터베이스 연결 및 부모글 가져오기
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac", "root", "1234");
            
            // 전체 부모글 수 조회 쿼리
            String parentCountQuery = "SELECT COUNT(*) AS count FROM board WHERE ref = num";
            PreparedStatement parentCountStmt = conn.prepareStatement(parentCountQuery);
            ResultSet parentCountRs = parentCountStmt.executeQuery();
            if (parentCountRs.next()) {
                parentTotalSize = parentCountRs.getInt("count");
            }
            parentCountRs.close();
            
            // 부모글 목록 조회 쿼리 (페이징 적용)
            String parentQuery = "SELECT * FROM board WHERE ref = num ORDER BY num DESC LIMIT ?, ?";
            PreparedStatement parentPstmt = conn.prepareStatement(parentQuery);
            parentPstmt.setInt(1, parentStartRow);
            parentPstmt.setInt(2, parentPageSize);
            ResultSet parentRs = parentPstmt.executeQuery();
            
            // 결과를 리스트에 저장
            while (parentRs.next()) {
                // BoardDTO 객체 생성
                BoardDTO parentPost = new BoardDTO();
                parentPost.setNum(parentRs.getInt("num"));
                parentPost.setId(parentRs.getString("id"));
                parentPost.setSubject(parentRs.getString("subject"));
                parentPost.setRegDate(parentRs.getString("reg_date"));
                parentPost.setReadcount(parentRs.getInt("readcount"));
                parentPost.setRef(parentRs.getInt("ref"));
                parentPost.setReStep(parentRs.getInt("re_step"));
                parentPost.setReLevel(parentRs.getInt("re_level"));
                parentPost.setContent(parentRs.getString("content"));
                parentPost.setIp(parentRs.getString("ip"));
                parentPost.setStatus(parentRs.getInt("status"));
                parentPost.setWriter(parentRs.getString("writer"));
                // 부모글 정보 설정
                
                // 출력 부분 시작
                %>
                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title"><%= parentPost.getSubject() %></h5>
                        <p class="card-text">작성자: <%= parentPost.getWriter() %></p>
                        <p class="card-text">작성일: <%= parentPost.getRegDate() %></p>
                        <p class="card-text">Ref: <%= parentPost.getRef() %></p>
                        <p class="card-text">내 용: <%= parentPost.getContent() %></p>
                        <!-- 내용 등 추가 정보 표시 -->
                        <button type="button" class="btn btn-primary" onclick="showEditModal('parent', <%= parentPost.getNum() %>, '<%= parentPost.getSubject() %>', '<%= parentPost.getContent() %>')">Edit</button>
                        <button type="button" class="btn btn-danger" onclick="showDeleteModal('parent', <%= parentPost.getNum() %>)">Delete</button>
                    </div>
                </div>
                <%
                // 출력 부분 종료
            }
            parentRs.close();
            parentPstmt.close();
            parentCountStmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    <!-- 부모글 페이징 -->
    <ul class="pagination justify-content-center">
        <% 
            int parentTotalPage = (int) Math.ceil((double) parentTotalSize / parentPageSize); // 총 페이지 수
            int parentPageBlockSize = 5; // 페이지 블록 사이즈
            int parentStartPage = ((parentCurrentPage - 1) / parentPageBlockSize) * parentPageBlockSize + 1; // 시작 페이지
            int parentEndPage = Math.min(parentStartPage + parentPageBlockSize - 1, parentTotalPage); // 끝 페이지
            
            // 이전 페이지 링크
            if (parentStartPage > 1) {
                %>
                <li class="page-item">
                    <a class="page-link" href="?parentPage=<%= parentStartPage - 1 %>" tabindex="-1">Previous</a>
                </li>
                <%
            }
            
            // 페이지 링크
            for (int i = parentStartPage; i <= parentEndPage; i++) {
                %>
                <li class="page-item <%= i == parentCurrentPage ? "active" : "" %>">
                    <a class="page-link" href="?parentPage=<%= i %>"><%= i %></a>
                </li>
                <%
            }
            
            // 다음 페이지 링크
            if (parentEndPage < parentTotalPage) {
                %>
                <li class="page-item">
                    <a class="page-link" href="?parentPage=<%= parentEndPage + 1 %>">Next</a>
                </li>
                <%
            }
        %>
    </ul>
    
    <h2>Child Posts</h2>
    <% 
        int childPageSize = 2; // 페이지당 자식글 수
        int childCurrentPage = 1; // 현재 페이지 (기본값은 1)
        if (request.getParameter("childPage") != null) {
            childCurrentPage = Integer.parseInt(request.getParameter("childPage"));
        }
        int childStartRow = (childCurrentPage - 1) * childPageSize; // 시작 로우
        int childTotalSize = 0; // 전체 자식글 수
        
        // 데이터베이스 연결 및 자식글 가져오기
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac", "root", "1234");
            
            // 전체 자식글 수 조회 쿼리
            String childCountQuery = "SELECT COUNT(*) AS count FROM board WHERE ref <> num";
            PreparedStatement childCountStmt = conn.prepareStatement(childCountQuery);
            ResultSet childCountRs = childCountStmt.executeQuery();
            if (childCountRs.next()) {
                childTotalSize = childCountRs.getInt("count");
            }
            childCountRs.close();
            
            // 자식글 목록 조회 쿼리 (페이징 적용)
            String childQuery = "SELECT * FROM board WHERE ref <> num ORDER BY num DESC LIMIT ?, ?";
            PreparedStatement childPstmt = conn.prepareStatement(childQuery);
            childPstmt.setInt(1, childStartRow);
            childPstmt.setInt(2, childPageSize);
            ResultSet childRs = childPstmt.executeQuery();
            
            // 결과를 리스트에 저장
            while (childRs.next()) {
                // BoardDTO 객체 생성
                BoardDTO childPost = new BoardDTO();
                childPost.setNum(childRs.getInt("num"));
                childPost.setId(childRs.getString("id"));
                childPost.setSubject(childRs.getString("subject"));
                childPost.setRegDate(childRs.getString("reg_date"));
                childPost.setReadcount(childRs.getInt("readcount"));
                childPost.setRef(childRs.getInt("ref"));
                childPost.setReStep(childRs.getInt("re_step"));
                childPost.setReLevel(childRs.getInt("re_level"));
                childPost.setContent(childRs.getString("content"));
                childPost.setIp(childRs.getString("ip"));
                childPost.setStatus(childRs.getInt("status"));
                childPost.setWriter(childRs.getString("writer"));
                // 자식글 정보 설정
                
                // 출력 부분 시작
                %>
                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title"><%= childPost.getSubject() %></h5>
                        <p class="card-text">작성자: <%= childPost.getWriter() %></p>
                        <p class="card-text">작성일: <%= childPost.getRegDate() %></p>
                        <p class="card-text">Ref: <%= childPost.getRef() %></p>
                        <p class="card-text">내 용: <%= childPost.getContent() %></p>
                        
                        <!-- 내용 등 추가 정보 표시 -->
                        <button type="button" class="btn btn-primary" onclick="showEditModal('child', <%= childPost.getNum() %>, '<%= childPost.getSubject() %>', '<%= childPost.getContent() %>')">Edit</button>
                        <button type="button" class="btn btn-danger" onclick="showDeleteModal('child', <%= childPost.getNum() %>)">Delete</button>
                    </div>
                </div>
                <%
                // 출력 부분 종료
            }
            childRs.close();
            childPstmt.close();
            childCountStmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
        <!-- 자식글 페이징 -->
    <ul class="pagination justify-content-center">
        <% 
            int childTotalPage = (int) Math.ceil((double) childTotalSize / childPageSize); // 총 페이지 수
            int childPageBlockSize = 5; // 페이지 블록 사이즈
            int childStartPage = ((childCurrentPage - 1) / childPageBlockSize) * childPageBlockSize + 1; // 시작 페이지
            int childEndPage = Math.min(childStartPage + childPageBlockSize - 1, childTotalPage); // 끝 페이지
            
            // 이전 페이지 링크
            if (childStartPage > 1) {
                %>
                <li class="page-item">
                    <a class="page-link" href="?childPage=<%= childStartPage - 1 %>" tabindex="-1">Previous</a>
                </li>
                <%
            }
            
            // 페이지 링크
            for (int i = childStartPage; i <= childEndPage; i++) {
                %>
                <li class="page-item <%= i == childCurrentPage ? "active" : "" %>">
                    <a class="page-link" href="?childPage=<%= i %>"><%= i %></a>
                </li>
                <%
            }
            
            // 다음 페이지 링크
            if (childEndPage < childTotalPage) {
                %>
                <li class="page-item">
                    <a class="page-link" href="?childPage=<%= childEndPage + 1 %>">Next</a>
                </li>
                <%
            }
        %>
    </ul>
</div>

<!-- 수정 및 삭제 모달 창 -->
<div class="modal fade" id="editDeleteModal" tabindex="-1" role="dialog" aria-labelledby="editDeleteModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editDeleteModalLabel">글 수정 및 삭제</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <!-- 수정 및 삭제 폼 -->
		<form id="editDeleteForm" action="updateProcess.jsp" method="post">
		    <input type="hidden" id="editDeleteType" name="type">
		    <input type="hidden" id="editDeleteNum" name="num">
		    <div class="form-group">
		        <label for="editDeleteSubject">제목</label>
		        <input type="text" class="form-control" id="editDeleteSubject" name="subject" required>
		    </div>
		    <div class="form-group">
		        <label for="editDeleteContent">내용</label>
		        <textarea class="form-control" id="editDeleteContent" name="content" rows="3" required></textarea>
		    </div>
		    <!-- 기타 필요한 입력 항목 추가 -->
		    <button type="submit" class="btn btn-primary">Edit</button>
		    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button> <!-- 수정 버튼 대신 닫기 버튼으로 변경 -->
		</form>
      </div>
    </div>
  </div>
</div>

<!-- 자바스크립트 코드 -->
<script>
  // 수정 및 삭제 모달 창 표시 함수
  function showEditModal(type, num, subject, content) {
    $('#editDeleteType').val(type);
    $('#editDeleteNum').val(num);
    $('#editDeleteSubject').val(subject);
    $('#editDeleteContent').val(content);
    $('#editDeleteModal').modal('show'); // 모달 창 표시
  }

  // 삭제 함수
  function deletePost() {
    var type = $('#editDeleteType').val();
    var num = $('#editDeleteNum').val();
    // 삭제 처리 로직 추가
  }
</script>

</body>
</html>
