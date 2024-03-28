<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="comment.Comment" %>
<%@ page import="comment.CommentDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="comment" class="comment.Comment" scope="page"/>
<jsp:setProperty name="comment" property="commentContent" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
</head>
<body>
<%
	String code = request.getParameter("code");

	String userEmail = null;
	if(session.getAttribute("userEmail")!= null){
		userEmail = (String)session.getAttribute("userEmail");
	}
	if(userEmail == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href='/login/login.jsp'");
		script.println("</script>");
	}
	
	int bbsId = 0;
	if(request.getParameter("bbsId") != null)
		bbsId=Integer.parseInt(request.getParameter("bbsId"));
	
	int commentId = 0;
	if(request.getParameter("commentId") != null)
		commentId=Integer.parseInt(request.getParameter("commentId"));
	if(commentId == 0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href='/photobbs/photoBbs.jsp'");
		script.println("</script>");
	}
	Comment comment2 = new CommentDAO().getComment(commentId);
	if(!userEmail.equals(comment2.getUserId())){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.')");
		script.println("location.href='/photobbs/photoBbs.jsp'");
		script.println("</script>");
	} else{
		if(request.getParameter("commentContent") == null){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else{
				CommentDAO commentDAO = new CommentDAO();//하나의 인스턴스
				int result = commentDAO.update(bbsId, commentId, request.getParameter("commentContent"), code);
				
				if(result == -1){//데이터 베이스 오류가 날 때
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('댓글 수정에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else{
					PrintWriter script=response.getWriter();
					script.println("<script>");
					script.println("alert('댓글 수정에 성공했습니다.')");
					script.println("location.href= \'/photobbs/photoView.jsp?bbsId="+bbsId+"&code="+code+"\'");
					script.println("</script>");
				}
	}
	
	}
%>
</body>
</html>