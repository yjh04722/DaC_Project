<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="photobbs.PhotoBbs" %>
<%@ page import="photobbs.PhotoBbsDAO" %><%--데이터베이스 접근 객체 가져오기 --%>
<%@ page import="comment.Comment" %>
<%@ page import="comment.CommentDAO" %><%--데이터베이스 접근 객체 가져오기 --%>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/include/header.jsp" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <style>
		.comment_write {
			display:flex;
		}
    </style>
</head>
<body>
<%
	String code = request.getParameter("code");
	
	String userEmail = null;
	if(session.getAttribute("userEmail")!=null){
		userEmail = (String)session.getAttribute("userEmail");
	}
	int bbsId = 0;
	if(request.getParameter("bbsId") != null)
		bbsId = Integer.parseInt(request.getParameter("bbsId"));
	if(bbsId == 0){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href='/bbs/bbs.jsp'");
		script.println("</script>");
	}
	
	PhotoBbs photoBbs = new PhotoBbsDAO().getPhotoBbs(bbsId);
	
	int commentId = 0;
	if(request.getParameter("commentId") != null)
		commentId = Integer.parseInt(request.getParameter("commentId"));
	Comment comment = new CommentDAO().getComment(commentId);
	
%>
    <table style="width: 100%; height: 50px; text-align:center;">
        <tr>
            <td style="width: 15%;"></td>
            <td style="width: 70%;">
				<div class="container">
					<div class="row">
						<header>
                            <h1>게시판 글 보기</h1>
                        </header>
						<table class="table table-hover">
								<tr>
									<td colspan="2"><img src="/bbsUpload/<%=photoBbs.getPhotoName()%>" style="width:250px; display:inline;"></td>
								</tr>						
								<tr>
									<td><b>내용</b></td>
								</tr>
								<tr>
									<td colspan="2" style="min-height: 200px; text-align: left;"><%= photoBbs.getBbsContent().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
								</tr>
						</table>
						<a href="/photobbs/photoBbs.jsp" class="btn btn-success">목록</a>
						
						<%
							if(userEmail != null && userEmail.equals(photoBbs.getUserId())){//해당 글이 본인이라면 수정과 삭제가 가능
						%>
						<a href="./photoBbsUpdate.jsp?bbsId=<%=bbsId%>" class="btn btn-warning">수정</a>
						<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsId=<%=bbsId%>" class="btn btn-danger">삭제</a>
						<%
							}
						%>
						<br>
						<br>
						<br>
						<!-- 댓글 부분 -->
                        <table class="table table-striped">
							<tr>
								<td><b>작성자</b></td>
								<td><b>내용</b></td>
                                <td><b>작성시간</b></td>
                                <td></td>
							</tr>
							<tr>
						<%
                            CommentDAO commentDAO = new CommentDAO();
                            ArrayList<Comment> list = commentDAO.getList(bbsId, code);
                            for(int i=0; i<list.size(); i++){
						%>
                            <tr>
                                <td align="left"><img src="/img/arrow-turn-down-right-9247304.png" alt="" style="weight:15px; height:15px">&nbsp;&nbsp;<%= list.get(i).getUserId() %></td>
                                <td align="left"><%= list.get(i).getCommentContent() %></td>
                                <td align="right"><%= list.get(i).getCommentDate().substring(0,11)+list.get(i).getCommentDate().substring(11,13)+"시"+list.get(i).getCommentDate().substring(14,16)+"분" %></td>
                                <td align="right"><a href="/comment/photoCommentUpdateAction.jsp?bbsId=<%=bbsId%>&commentId=<%=list.get(i).getCommentId()%>&code=<% %>" class="btn btn-warning">수정</a>
                                <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="../comment/commentDeleteAction.jsp?bbsId=<%=bbsId%>&commentId=<%=list.get(i).getCommentId() %>" class="btn btn-danger">삭제</a></td>
                            </tr>
						<%
							}
						%>
                            </tr>
					</table>
			        <form method="post" action="photoCommentUpdateAction.jsp?bbsId=<%=bbsId%>&commentId=<%=commentId%>&code=<%=code%>" class="comment_write">
                        <input type="text" class="form-control" placeholder="댓글 쓰기" name="commentContent" maxlength="300" value=<%=comment.getCommentContent()%>>
                        <input type="submit" class="btn btn-success pull-right" value="댓글 수정">
                    </form>
					</div>	
				</div>
            </td>
            <td style="width: 15%;"></td>
        </tr>
    </table>
</body>
</html>