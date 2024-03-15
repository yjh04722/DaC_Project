<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<body>
<%
	String userEmail = null;
	if (session.getAttribute("userEmail") != null){
        userEmail = (String)session.getAttribute("userEmail");
	}
	if (userEmail == null){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인하세요.')");
        script.println("location.href = '../login/login.jsp'");    // 메인 페이지로 이동
        script.println("</script>");
	}
	int bbsId = 0;
	if (request.getParameter("bbsId") != null){
		bbsId = Integer.parseInt(request.getParameter("bbsId"));
	}
	if (bbsId == 0)
    {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다')");
        script.println("location.href = './bbs.jsp'");
        script.println("</script>");
    }
    Bbs bbs = new BbsDAO().getBbs(bbsId);
    if (!userEmail.equals(bbs.getUserId())){
    	PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.')");
        script.println("location.href = './bbs.jsp'");
        script.println("</script>");
    }else{
		
  		BbsDAO bbsDAO = new BbsDAO();
        int result = bbsDAO.delete(bbsId);
        if (result == -1){ // 글삭제 실패시
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('글삭제에 실패했습니다.')");
            script.println("history.back()");    // 이전 페이지로 사용자를 보냄
            script.println("</script>");
        }else{ // 글삭제 성공시
          	PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('게시글이 삭제되었습니다.')");
            script.println("location.href = './bbs.jsp'");    // 메인 페이지로 이동
            script.println("</script>");    
        }
    }	
%>

</body>
</html>