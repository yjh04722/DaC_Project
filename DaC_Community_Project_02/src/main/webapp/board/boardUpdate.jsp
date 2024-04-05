<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="board.BoardDAO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
</head>
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
        script.println("location.href = '/login/login.jsp'");
        script.println("</script>");
    }
    
	// 게시글 유효성 검사
    int num = 0;
    if (request.getParameter("num") != null)
    {
        num = Integer.parseInt(request.getParameter("num"));
    }
    if (num == 0)
    {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다')");
        script.println("location.href = './bbs.jsp'");
        script.println("</script>");
    }
    
    // 게시글 번호와 아이디를 비교하여 권한이 있는지를 확인
    BoardDTO board = new BoardDAO().getBoard(num);
    if (!userEmail.equals(board.getId()) && userLevel.equals("1")){
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
    		<form method="post" action="boardUpdateAction.jsp?num=<%=num%>">
    			<table class= "table table-hover" style= "text-align: center; boarder: 1px solid #dddddd">
	    	    	<thead>
		    	    	<tr>
		    	    		<th colspan= "2" style= "background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
		    	    	</tr>
	    	    	</thead>
			    	<tbody>
			    		<tr>
			    			<td><input type="text" class="form-control" placeholder="글 제목"  name="subject" maxlength="50" value="<%= board.getSubject()%>"></td>
			    		</tr>
			    		<tr>
			    			<td><textarea class="form-control" placeholder="글 내용"  name="content" maxlength="2048" style= "height:350px"><%= board.getContent()%></textarea></td>
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