<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
</head>
<body>
 <% 
    String userEmail = null;
    if (session.getAttribute("userEmail") != null){
        userEmail = (String) session.getAttribute("userEmail");
    }
    if (userEmail == null){
    	PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인하세요.')");
        script.println("location.href = '../login/login.jsp'");
        script.println("</script>");
    }
    int bbsId = 0;
    if (request.getParameter("bbsId") != null)
    {
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
    }
%>
	<table style="width: 100%; height: 50px;">
    <tr>
      <td style="width: 15%; height: 700px;"></td>
      <td style="width: 70%; height: 700px;">
	  <div class= "container">
    	<div class= "row">
    		<form method="post" action="updateAction.jsp?bbsId=<%= bbsId%>">
    			<table class= "table table-stripped" style= "text-align: center; boarder: 1px solid #dddddd">
	    	    	<thead>
		    	    	<tr>
		    	    		<th colspan= "2" style= "background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
		    	    	</tr>
	    	    	</thead>
			    	<tbody>
			    		<tr>
			    			<td><input type="text" class="form-control" placeholder="글 제목"  name="bbsTitle" maxlength="50" value="<%= bbs.getBbsTitle()%>"></td>
			    		</tr>
			    		<tr>
			    			<td><textarea class="form-control" placeholder="글 내용"  name="bbsContent" maxlength="2048" style= "height:350px"><%= bbs.getBbsContent()%></textarea></td>
			    		</tr>
			    	</tbody>
    	    	</table>
    	    	<input type="submit" class="btn btn-primary pull-right" value="글수정">
    		</form>
    	  </div>
     </div>
      </td>
      <td style="width: 15%; height: 700px;"></td>
    </tr>
  </table>
</body>
</html>