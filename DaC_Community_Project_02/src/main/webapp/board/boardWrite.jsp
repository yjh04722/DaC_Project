<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
</head>
<body>
 <% 
 	String code = request.getParameter("code"); //db : table 명
	
 	// 세션에 저장된 아이디와 레벨 불러옴
    String userEmail = null;
 	String userLevel = null;
    if (session.getAttribute("userEmail") != null){
        userEmail = (String)session.getAttribute("userEmail");
        userLevel = (String)session.getAttribute("userLevel");
    }
    
    if (userEmail == null){
    	PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인하세요.')");
        script.println("location.href = '/login/login.jsp'");
        script.println("</script>");
    }
%>
	<table style="width: 100%; height: 50px;">
    <tr>
      <td style="width: 15%; height: 700px;"></td>
      <td style="width: 70%; height: 700px;">
		 <div class= "container">
    	<div class= "row">
    		<form method="post" action="boardWriteAction.jsp">
    		<input type="hidden" name="parentId" value="<%=request.getParameter("parentId")%>">
    			<table class= "table table-hover" style= "text-align: center; boarder: 1px solid #dddddd">
	    	    	<thead>
		    	    	<tr>
		    	    		<th colspan= "2" style= "background-color: #eeeeee; text-align: center;">질의응답</th>
		    	    	</tr>
	    	    	</thead>
			    	<tbody>
			    		<tr>
			    			<td><input type="text" class="form-control" placeholder="글 제목"  name="subject" maxlength="50" ></td>
			    		</tr>
			    		<tr>
			    			<td><textarea class="form-control" placeholder="글 내용"  name="content" maxlength="2048" style= "height:350px" ></textarea></td>
			    		</tr>
			    	</tbody>
    	    	</table>
    	    	<input type="submit" class="btn btn-primary pull-right" value="글쓰기">
    		</form>
    	    </div>
    	</div>
      </td>
      <td style="width: 15%; height: 700px;"></td>
    </tr>
  </table>
</body>
</html>