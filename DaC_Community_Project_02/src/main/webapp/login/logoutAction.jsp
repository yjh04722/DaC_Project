<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
</head>
<body>
	<%
		session.invalidate(); // 세션값 제거
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그아웃되었습니다.')");
		script.println("</script>");
	%>
	<script>
            location.href = '../index.jsp'; <!-- 메인 페이지로 이동 -->
	</script>
</body>
</html>