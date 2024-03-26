<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="photobbs.PhotoBbsDAO" %>
<%@ page import="photobbs.PhotoBbs" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<style type="text/css">
	a, a:hover{
		color: #000000;
		text-decoration:none;
	}
	.container_img {
		width: 400px;
		height: 350px;
	    margin: 0 auto;
	    background-color: #fff;
	    padding: 20px;
	    border-radius: 8px;
	    text-align: center;
	    float: left;
	}
	
	.btn_all {
		display:block;
   		clear:both;
	}

</style>
</head>
<body>
    <% 
    String userEmail = null; // 로그인이 된 사람들은 로그인정보를 담을 수 있도록한다
    if (session.getAttribute("userEmail") != null){
        userEmail = (String)session.getAttribute("userEmail");
    }
    int pageNumber = 1; // 기본페이지 기본적으로 페이지 1부터 시작하므로
    if (request.getParameter("pageNumber") != null){
    	pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
    }
    %>
	<table style="width: 100%; height: 50px;">
    <tr>
      <td style="width: 15%; height: 700px;"></td>
      <td style="width: 70%; height: 700px;">
		
		<%
			PhotoBbsDAO photoBbsDAO = new PhotoBbsDAO();
			ArrayList<PhotoBbs> list = photoBbsDAO.getList(pageNumber);
			for (int i =0; i < list.size(); i++){
		%>
				  <div class= "container_img">
		<div class= "row">
		    <table class= "table table-stripped" style= "text-align: center; boarder: 1px solid #dddddd">
					<tr>
						<td><img src="../bbsUpload/<%=list.get(i).getPhotoName()%>" style="width:250px; display:inline;"></td>
					</tr>
					<tr>
						<td><%=list.get(i).getUserId()%></td>
		 			</tr>
			    </table>
			</div>
		</div>
		  	<%
		}
		%>
		<div class="btn_all">
			<%
    	    	if(pageNumber != 1){
    	    %>		
    	    		<a href= "photobbs.jsp?pageNumber=<%=pageNumber -1%>" class="btn btn-success btn-arraw-left">이전</a>
    	    <% 
    	    	}if(photoBbsDAO.nextPage(pageNumber + 1)){
    	    %>		
    	    		<a href= "photobbs.jsp?pageNumber=<%=pageNumber +1%>" class="btn btn-success btn-arraw-left">다음</a>
    	    <% 
    	    	}
    	    %>
		 
		 <a href= "../photobbs/photoBbsWrite.jsp" class= "btn btn-primary pull-right">글쓰기</a>
		 </div>
      </td>
      <td style="width: 15%; height: 700px;"></td>
    </tr>
  </table>
</body>
</html>