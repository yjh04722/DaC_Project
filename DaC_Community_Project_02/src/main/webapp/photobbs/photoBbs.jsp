<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		String code = request.getParameter("code"); //db : table 명
		PhotoBbsDAO photoBbsDAO = new PhotoBbsDAO();
		
		// 게시판 이름
		String bbs_title = "";
		if(code != null &&  code.equals("bbs")){
			bbs_title = "자유게시판";
		}else if(code != null && code.equals("photobbs")){
			bbs_title = "사진게시판";
		}else if(code != null && code.equals("missingbbs")){
			bbs_title = "실종신고";
		}else if(code != null && code.equals("qnabbs")){
			bbs_title = "문의사항";
		}

		// 세션에 저장된 아이디와 레벨 불러옴
		String userEmail = null;
		String userLevel = null;
		
		if (session.getAttribute("userEmail") != null){
		    userEmail = (String)session.getAttribute("userEmail");
		    userLevel = (String)session.getAttribute("userLevel");
		}
		
		// 총 게시글 수
		int cnt = photoBbsDAO.getCount();
		
		// 한 페이지에 출력될 글 수
		int pageSize = 6; 
  
		// 현 페이지 정보 설정
	    String pageNum = request.getParameter("pageNum");
	    if (pageNum == null){
	    		pageNum = "1";
	    }
		
	    int currentPage = Integer.parseInt(pageNum);
		int startRow = (currentPage - 1) * pageSize + 1;
	%>
	<table style="width: 100%; height: 50px;">
    <tr>
      <td style="width: 15%; height: 700px;"></td>
      <td style="width: 70%; height: 700px;">
      	<span style="margin-right: 1050px;"><b>총게시글 수 : </b><%=cnt %></span>
      		
		<%
			ArrayList<PhotoBbs> list = photoBbsDAO.getList(currentPage);
			for (int i =0; i < list.size(); i++){
		%>
	<div class= "container_img">
		<div class= "row">
		    <table class= "table table-hover" style= "text-align: center; boarder: 1px solid #dddddd">
					<tr>
						<td><a href ="./photoView.jsp?bbsId=<%=list.get(i).getBbsId()%>&code=<%=list.get(i).getCode()%>"><img src="../bbsUpload/<%=list.get(i).getPhotoName()%>" style="width:250px; height: 250px; display:inline;"></a></td>
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
			<a href= "../photobbs/photoBbsWrite.jsp" class= "btn btn-primary pull-right">글쓰기</a>
		</div>
		<ul class="pagination">
		    	    <% 
		    	    	if(cnt != 0){
		    	    		int pageCount = cnt / pageSize + (cnt % pageSize == 0?0:1);
		    	    		
		    	    		// 한 페이지에 보여줄 페이지 블럭
		    	    		int pageBlock = 10;
		    	    		int startPage = ((currentPage - 1)/pageBlock) * pageBlock + 1;
		    	    		
		    	    		// 한 페이지에 보여줄 페이지 블럭 끝 번호 계산
		    	    		int endPage = startPage + pageBlock - 1;
		    	    		if(endPage > pageCount){
		    	    			endPage = pageCount;
		    	    		}
					%>
		    	    <% if(startPage > pageBlock){ %>
		    	    	<li><a href="photBbs.jsp?pageNum=<%=startPage-pageBlock %>">Prev</a></li>
		    	    <% } %>
		    	    
		    	     <% for(int i = startPage; i <= endPage; i++){ %>
		    	    	<li><a href="photoBbs.jsp?pageNum=<%=i %>"><%=i %></a></li>
		    	    <% } %>
		    	    
		    	     <% if(endPage < pageCount){ %>
		    	    	<li><a href="photoBbs.jsp?pageNum=<%=startPage+pageBlock %>">Next</a></li>
		    	    <% } %>	    	    	
		    	    <%}  %>
		 </ul>
      </td>
      <td style="width: 15%; height: 700px;"></td>
    </tr>
  </table>
</body>
</html>