<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/include/adminHeader.jsp" %>
<%@ page import="java.util.*, java.sql.*, comment.Comment" %> <!-- 필요한 클래스 import -->
<!DOCTYPE html>
<html>
<head>
    <title>댓글 관리 페이지</title>
    <!-- 부트스트랩 CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- 필요한 CSS 파일을 여기에 추가하세요 -->
    <style>
        .comment-table {
            margin-top: 20px;
        }
        .comment-table th, .comment-table td {
            padding: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
<%request.setCharacterEncoding("UTF-8"); %>
    <div class="container">
        <h1 class="mt-5">댓글 관리 페이지</h1>
        
        <!-- 콤보박스를 통해 게시판 타입 선택 -->
        <form action="commentManage.jsp" method="get" class="mt-3">
            <div class="form-group">
                <label for="bbsType">게시판 타입:</label>
                <select name="bbsType" id="bbsType" class="form-control">
                    <option value="all">전체</option>
                    <option value="bbs">일반 게시판</option>
                    <option value="photobbs">사진 게시판</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">선택</button>
        </form>

		<!-- 검색 폼 추가 -->
		<form action="commentManage.jsp" method="get" class="mt-3">
		    <div class="form-group">
		        <label for="keyword">검색어:</label>
		        <input type="text" name="keyword" id="keyword" class="form-control" placeholder="댓글 내용을 검색하세요">
		    </div>
		    <button type="submit" class="btn btn-primary">검색</button>
		</form>
        
        <hr>
        <%     
        // 페이지 번호 가져오기
        int pageNumber = 1;
        if (request.getParameter("page") != null) {
            pageNumber = Integer.parseInt(request.getParameter("page"));
        }
        
        // 선택된 게시판 타입에 따라 적절한 댓글 목록을 불러오기
        String selectedBbsType = request.getParameter("bbsType");
    	String keyword = request.getParameter("keyword");
        if (selectedBbsType != null && !selectedBbsType.equals("") || keyword != null && !keyword.equals("")) {
            try {
            	// 데이터베이스 연결
            	Class.forName("org.mariadb.jdbc.Driver");
            	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac?useUnicode=true&characterEncoding=utf8mb4", "root", "1234");

            	String commentQuery = "SELECT * FROM comment WHERE 1=1";

            	// 선택된 게시판 타입에 따라 쿼리 조건 추가
            	if (selectedBbsType != null && !selectedBbsType.equals("all")) {
            	    commentQuery += " AND code='" + selectedBbsType + "'";
            	}
				
            	if(keyword != null){
            	// 추가된 검색 기능: 키워드가 입력되었는지 확인하고 SQL 쿼리에 반영
           	    commentQuery += " AND commentContent LIKE '%" + keyword + "%'";
            	}


            	// 쿼리 실행을 위한 Statement 생성
            	Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            	// 쿼리 실행 및 결과셋 획득
            	ResultSet rs = stmt.executeQuery(commentQuery);
            	
                // 출력할 쿼리 확인을 위해 로그에 쿼리 출력
                System.out.println("실행된 쿼리: " + commentQuery);
                
                // 댓글 총 개수 구하기
                rs.last();
                int totalComments = rs.getRow();
                rs.beforeFirst();
                
                // 페이지당 댓글 개수 설정
                int commentsPerPage = 6;
                
                // 전체 페이지 수 계산
                int totalPages = (int) Math.ceil((double) totalComments / commentsPerPage);
                
                // 페이지 범위 설정
                int start = (pageNumber - 1) * commentsPerPage;
                int end = start + commentsPerPage;
                if (end > totalComments) {
                    end = totalComments;
                }
                
                // rs 커서를 시작 위치로 이동
                rs.absolute(start);
        %>

                <!-- 댓글 목록 테이블 -->
                <table class="table comment-table">
                    <thead>
                        <tr>
                            <th>댓글 ID</th>
                            <th>작성자</th>
                            <th>내용</th>
                            <th>작성일</th>
                            <th>게시판 타입</th>
                            <!-- 수정 버튼을 삭제 -->
                            <th>삭제</th>
                        </tr>
                    </thead>
                    <tbody>
        <%          
                // 댓글 목록 출력
                while (rs.next() && start < end) {
                    // CommentDTO 객체 생성 및 설정
                    Comment comment = new Comment();
                    comment.setCommentId(rs.getInt("commentId"));
                    comment.setUserId(rs.getString("userId"));
                    comment.setCommentContent(rs.getString("commentContent"));
                    comment.setCommentAvailable(rs.getInt("commentAvailable"));
                    comment.setBbsId(rs.getInt("bbsId"));
                    comment.setCommentDate(rs.getString("commentDate"));
                    comment.setCode(rs.getString("code"));
        %>                  
                        <tr>
                            <td><%= comment.getCommentId() %></td>
                            <td><%= comment.getUserId() %></td>
                            <td><%= comment.getCommentContent() %></td>
                            <td><%= comment.getCommentDate() %></td>
                            <td><%= comment.getCode() %></td>
                            <!-- 수정 버튼 삭제 -->
                            <td><a href="deleteComment.jsp?commentId=<%= comment.getCommentId() %>" class="btn btn-danger">삭제</a></td>
                        </tr>
        <% 
                    start++;
                }
        %>
                    </tbody>
                </table>
                
                <!-- 페이지 링크 -->
                <nav aria-label="Page navigation example">
                    <ul class="pagination justify-content-center">
                        <li class="page-item <%= (pageNumber == 1) ? "disabled" : "" %>">
                            <a class="page-link" href="commentManage.jsp?page=<%= pageNumber - 1 %>&bbsType=<%= selectedBbsType %>">이전</a>
                        </li>
        <%      
                for (int i = 1; i <= totalPages; i++) {
        %>
                        <li class="page-item <%= (pageNumber == i) ? "active" : "" %>">
                            <a class="page-link" href="commentManage.jsp?page=<%= i %>&bbsType=<%= selectedBbsType %>"><%= i %></a>
                        </li>
        <%          
                }
        %>
                        <li class="page-item <%= (pageNumber == totalPages) ? "disabled" : "" %>">
                            <a class="page-link" href="commentManage.jsp?page=<%= pageNumber + 1 %>&bbsType=<%= selectedBbsType %>">다음</a>
                        </li>
                    </ul>
                </nav>
        <%      
                // 자원 닫기
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                // 예외 발생 시 로그에 출력
                e.printStackTrace();
            }
        }
        %>
    </div>
</body>
</html>
