<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "user.UserDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page"></jsp:useBean>
<jsp:setProperty name="user" property="userEmail"/>
<jsp:setProperty name="user" property="userPassword"/>
<jsp:setProperty name="user" property="userName"/>
<jsp:setProperty name="user" property="userAddr"/>
<jsp:setProperty name="user" property="userLevel"/>
 
<head>
	<meta charset="UTF-8">
</head>
<body>
    <%
	UserDAO userDAO = new UserDAO();
       int result = userDAO.join(user);
       if (result == -1){ // 회원가입 실패시
           PrintWriter script = response.getWriter();
           script.println("<script>");
           script.println("alert('회원가입 실패. 관리자에게 문의주세요.')");
           script.println("history.back()");    // 이전 페이지로 사용자를 보냄
           script.println("</script>");
       }else{ // 회원가입 성공시
           PrintWriter script = response.getWriter();
           script.println("<script>");
           script.println("alert('가입이 완료되었습니다.')");
           script.println("location.href = '/'");    // 메인 페이지로 이동
           script.println("</script>");
       }
    %>
 
</body>
</html>