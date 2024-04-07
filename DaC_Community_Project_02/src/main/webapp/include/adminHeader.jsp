<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 페이지</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            background-color: #f0f8ff; /* 하늘색톤 배경색 */
        }
        .sidebar {
            width: 200px;
            background-color: #4682b4; /* 파란색 사이드바 */
            color: #fff;
            padding-top: 20px;
            height: 100vh; /* 화면 높이에 맞추기 */
        }
        .sidebar a {
            display: block;
            color: #fff;
            padding: 20px 20px;
            text-decoration: none;
            border-bottom: 1px solid #87ceeb; /* 하늘색톤 선 */
            transition: background-color 0.3s;
        }
        .sidebar a:hover {
            background-color: #87ceeb; /* 하늘색톤 hover 배경색 */
        }
        .content {
            flex: 1;
            padding: 20px;
        }
        h1 {
            color: #333;
        }
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #fff;
            overflow-x: auto;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #333;
            color: #fff;
            text-decoration: none;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            margin-right: 10px;
        }
        .btn:hover {
            background-color: #555;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        .table th, .table td {
            padding: 10px;
            border-bottom: 1px solid #ccc;
        }
        .table th {
            background-color: #333;
            color: #fff;
            text-align: left;
        }
        .table td {
            text-align: center;
        }
    </style>
</head>
<body>
<%
// 사용자가 로그인한 경우에만 페이지에 액세스할 수 있도록 확인
String loggedInUser = (String) session.getAttribute("userEmail");
if (loggedInUser == null) {
    // 로그인하지 않은 경우 로그인 페이지로 리다이렉션
    response.sendRedirect("/login/login.jsp");
    return; // 페이지 렌더링 중지
}

// 로그인한 사용자의 권한을 확인하여 관리자만 이 페이지에 액세스할 수 있도록 함
String userRole = (String) session.getAttribute("userLevel");
if (!"2".equals(userRole)) {
    // 사용자가 관리자 권한이 없는 경우 접근 거부 메시지 출력
    response.getWriter().println("<h1>Access Denied</h1>");
    return; // 페이지 렌더링 중지
}
%>
    <div class="sidebar">
       	<a href="./adminPage.jsp">홈화면</a>
        <a href="./userManage.jsp">이용자 관리</a>
        <a href="./freeManage.jsp">자유게시판 관리</a>
        <a href="./photoManage.jsp">사진게시판 관리</a>
        <a href="./qnaManage.jsp">문의사항 관리</a>
        <a href="./commentManage.jsp">댓글 관리</a>  
        <a href="/">나가기 <img src="../img/free-icon-font-exit-3917349.png" style="wight:10px; height:10px"></a> 
    </div>