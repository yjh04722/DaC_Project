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
	// 세션에 저장된 아이디와 레벨 불러옴
	String userEmail = null;
	String userLevel = null;
	
	if (session.getAttribute("userEmail") != null){
	   userEmail = (String)session.getAttribute("userEmail");
	   userLevel = (String)session.getAttribute("userLevel");
	}
	 
	// 로그인 안되어 있으면 로그인 창으로 이동 
	if (userEmail == null){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인하세요.')");
        script.println("location.href = '../login/login.jsp'");    // 메인 페이지로 이동
        script.println("</script>");
	}
	
	// 게시글 유효성 검사
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
	
	// 작성자와 관리자만 삭제가능
    Bbs bbs = new BbsDAO().getBbs(bbsId);
    if (!userEmail.equals(bbs.getUserId()) && userLevel.equals("1")){
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