<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "user.UserDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
 
<jsp:useBean id="user" class="user.User" scope="page"></jsp:useBean>
<jsp:setProperty name="user" property="userEmail"/>
<jsp:setProperty name="user" property="userPassword"/>
 
<head>
	<meta charset="UTF-8">
</head>
<body>
    <%
	    String userEmail = null;
    	String userLevel = null;
    	
	    if (session.getAttribute("userEmail") != null){
	    	userEmail = (String)session.getAttribute("userEmail");
	    	userLevel = (String)session.getAttribute("userLevel");
	    	
	    }
	    if (userEmail != null){
	        PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('이미 로그인되었습니다.')");
	        script.println("location.href = '/'");    // 메인 페이지로 이동
	        script.println("</script>");
	    }
	    
	    UserDAO userDAO = new UserDAO();
	    
	    String result = userDAO.login(user.getUserEmail(), user.getUserPassword());
	    if (result.equals("1") || result.equals("2")){
	    	session.setAttribute("userEmail", user.getUserEmail());
	    	session.setAttribute("userLevel", result);
	        PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('환영합니다.')");
	        script.println("location.href = '/'");
	        script.println("</script>");
	    }
	    else if (result.equals("0")){
	        PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('비밀번호가 틀립니다.')");
	        script.println("history.back()");    // 이전 페이지로 사용자를 보냄
	        script.println("</script>");
	    }
	    else if (result.equals("-1")){
	        PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('존재하지 않는 아이디입니다.')");
	        script.println("history.back()");    
	        script.println("</script>");
	    }
	    else if (result.equals("-2")){
	        PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('DB 오류가 발생했습니다.')");
	        script.println("history.back()");   
	        script.println("</script>");
	    }
    %>
 
</body>
</html>