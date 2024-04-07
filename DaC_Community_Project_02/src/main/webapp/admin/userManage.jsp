<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/include/adminHeader.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="user.User" %> <!-- 사용자 클래스 import -->

<html>
<head>
    <title>User List</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <style>
        td {
            padding: 8px;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        .modal-content {
            background-color: #f8f9fa; /* 배경색 변경 */
            border-radius: 10px; /* 모서리 둥글게 */
        }

        .modal-header {
            background-color: #007bff; /* 헤더 배경색 변경 */
            color: #fff; /* 헤더 텍스트 색상 변경 */
            border-bottom: none; /* 헤더의 하단 경계선 제거 */
        }

        .modal-title {
            font-size: 24px; /* 제목 폰트 크기 조정 */
        }

        .modal-body {
            font-size: 18px; /* 본문 폰트 크기 조정 */
            color: #333; /* 본문 텍스트 색상 변경 */
        }

        .btn-primary, .btn-secondary {
            padding: 10px 20px; /* 버튼 내부 여백 조정 */
            font-size: 16px; /* 버튼 폰트 크기 조정 */
            border-radius: 5px; /* 모서리 둥글게 */
        }

        .btn-primary {
            background-color: #007bff; /* 기본 버튼 배경색 변경 */
            border-color: #007bff; /* 기본 버튼 테두리 색상 변경 */
        }

        .btn-primary:hover, .btn-secondary:hover {
            background-color: #0056b3; /* 마우스 호버시 버튼 배경색 변경 */
            border-color: #0056b3; /* 마우스 호버시 버튼 테두리 색상 변경 */
        }

        .btn-secondary {
            background-color: #6c757d; /* 보조 버튼 배경색 변경 */
            border-color: #6c757d; /* 보조 버튼 테두리 색상 변경 */
        }

        .btn-secondary:hover {
            background-color: #545b62; /* 마우스 호버시 보조 버튼 배경색 변경 */
            border-color: #545b62; /* 마우스 호버시 보조 버튼 테두리 색상 변경 */
        }
    </style>
</head>
<body>
<div class="container">
    <h1>User List</h1>
    <!-- Add User 버튼 -->
    <button type="button" class="btn btn-success mb-2" data-toggle="modal" data-target="#addUserModal">Add User</button>

    <!-- Add User 모달 -->
    <div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="addUser.jsp" method="post">
                        <div class="form-group">
                            <label for="inputEmailAdd">Email</label>
                            <input type="text" class="form-control" id="inputEmailAdd" name="email" required>
                        </div>
                        <div class="form-group">
                            <label for="inputPasswordAdd">Password</label>
                            <input type="password" class="form-control" id="inputPasswordAdd" name="password" required>
                        </div>
                        <div class="form-group">
                            <label for="inputNameAdd">Name</label>
                            <input type="text" class="form-control" id="inputNameAdd" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="inputAddressAdd">Address</label>
                            <input type="text" class="form-control" id="inputAddressAdd" name="address" required>
                        </div>
                        <div class="form-group">
                            <label for="inputLevelAdd">Level</label>
                            <input type="text" class="form-control" id="inputLevelAdd" name="level" required>
                        </div>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Add User</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <table class="table table-hover">
        <thead class="thead-light">
        <tr>
            <th class="text-center">Email</th>
            <th class="text-center">Password</th>
            <th class="text-center">Name</th>
            <th class="text-center">Address</th>
            <th class="text-center">Level</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        <% 
            try {
                // 데이터베이스 연결
                Class.forName("org.mariadb.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dac?useUnicode=true&characterEncoding=UTF-8", "root", "1234");
                Statement stmt = conn.createStatement();
                
                // 사용자 목록 조회 쿼리
                String query = "SELECT * FROM user";
                ResultSet rs = stmt.executeQuery(query);
                
                // 결과를 리스트에 저장
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("userEmail") %></td>
            <td><%= rs.getString("userPassword") %></td>
            <td><%= rs.getString("userName") %></td>
            <td><%= rs.getString("addr") %></td>
            <td><%= rs.getString("userLevel") %></td>
            <td>
                <!-- Edit 버튼 -->
				<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#editModal_<%= rs.getString("userEmail").replaceAll("[^a-zA-Z0-9]", "") %>">Edit</button>
				<div class="modal fade" id="editModal_<%= rs.getString("userEmail").replaceAll("[^a-zA-Z0-9]", "") %>" tabindex="-1" role="dialog" aria-labelledby="editModalLabel_<%= rs.getString("userEmail").replaceAll("[^a-zA-Z0-9]", "") %>" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title" id="editModalLabel<%= rs.getString("userEmail") %>">Edit User</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <form action="updateUser.jsp" method="post">
                                    <input type="hidden" name="email" value="<%= rs.getString("userEmail") %>">
                                    <input type="text" class="form-control" id="inputPasswordEdit_<%= rs.getString("userEmail").replaceAll("[^a-zA-Z0-9]", "") %>" name="password" value="<%= rs.getString("userPassword") %>">
								    <input type="text" class="form-control" id="inputNameEdit_<%= rs.getString("userEmail").replaceAll("[^a-zA-Z0-9]", "") %>" name="name" value="<%= rs.getString("userName") %>">
								    <input type="text" class="form-control" id="inputAddressEdit_<%= rs.getString("userEmail").replaceAll("[^a-zA-Z0-9]", "") %>" name="address" value="<%= rs.getString("addr") %>">
								    <input type="text" class="form-control" id="inputLevelEdit_<%= rs.getString("userEmail").replaceAll("[^a-zA-Z0-9]", "") %>" name="level" value="<%= rs.getString("userLevel") %>">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    <input type="submit" class="btn btn-primary" value="Save Changes">
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <a href="deleteUser.jsp?userEmail=<%= rs.getString("userEmail") %>" class="btn btn-danger">Delete</a>
            </td>
        </tr>
        <% 
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) { // SQLException 대신 Exception으로 수정하여 모든 예외를 처리할 수 있도록 함
                e.printStackTrace();
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
