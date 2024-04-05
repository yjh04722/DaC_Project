<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="missingbbs.MissingBbsDAO" %>
<%@ page import="missingbbs.MissingBbs" %>
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
	.search_aban {
	  	position: relative;
	  	width: 500px;
	  	marigin: 0 auto;
	}
	input {
	 	width: 100%;
	  	border: 1px solid #bbb;
	  	border-radius: 8px;
	  	padding: 10px 12px;
	  	font-size: 14px;
	}
	#inp_dt {
		position: absolute;
		width: 250px;
	}
	.search_img {
	  	position : absolute;
	  	width: 17px;
	  	top: 10px;
	  	right: 12px;
	  	margin: 0;
	}
</style>
</head>
<body>
	<%
		String code = request.getParameter("code"); //db : table 명
		String searchText = request.getParameter("searchText");
		MissingBbsDAO missingBbsDAO = new MissingBbsDAO();
		
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

	    String userEmail = null; // 로그인이 된 사람들은 로그인정보를 담을 수 있도록한다
	    if (session.getAttribute("userEmail") != null){
	        userEmail = (String)session.getAttribute("userEmail");
	    }
    
		// 총 게시글 수
		int cnt = missingBbsDAO.getCount();
		
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
     	<td style="width: 15%;"></td>
     	<td style="width: 70%; height: 50px; text-align: center;">
     	<form method="post" name="search" action="searchbbs.jsp">
			<div class="search_aban">
			  <input type="text" name="searchText" placeholder="장소를 입력해 주세요.">
			  <button type="submit" class="search_btn"><img class="search_img" src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"></button>
			</div>
		</form>
     	</td>
    	<td style="width: 15%;"></td>
	</tr>
    <tr>
     	<td style="width: 15%; height: 700px;"></td>
     	<td style="width: 70%; height: 700px;">
     		<br>
			<span style="margin-right: 1050px;"><b>총게시글 수 : </b><%=cnt %></span>
   		<%
			ArrayList<MissingBbs> list = missingBbsDAO.getList(currentPage);
			for (int i =0; i < list.size(); i++){
		%>
		<div class= "container_img">
		<div class= "row">
		    <table class= "table table-hover" style= "text-align: center; boarder: 1px solid #dddddd">
					<tr>
						<td><img src="<%=list.get(i).getFilename()%>" style="width:200px; height:200px; display:inline;"></td>
					</tr>
					<tr>
						<td style="text-align: left;">
							<p>유기날짜 : <%=list.get(i).getHappenDt()%></p>
							<p>유기장소 : <%=list.get(i).getHappenPlace()%></p>
							<p>보 호 소 : <%=list.get(i).getCareNm()%></p>
							<p>보호소번호 : <%=list.get(i).getCareTel()%></p>
						</td>
		 			</tr>
			    </table>
			</div>
		</div>
		
	<%
		}
	%>
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
		    	    	<li><a href="missingBbs.jsp?pageNum=<%=startPage-pageBlock %>&searchText=<%=searchText %>">Prev</a></li>
		    	    <% } %>
		    	    
		    	     <% for(int i = startPage; i <= endPage; i++){ %>
		    	    	<li><a href="missingBbs.jsp?pageNum=<%=i %>&searchText=<%=searchText %>"><%=i %></a></li>
		    	    <% } %>
		    	    
		    	     <% if(endPage < pageCount){ %>
		    	    	<li><a href="missingBbs.jsp?pageNum=<%=startPage+pageBlock %>&searchText=<%=searchText %>">Next</a></li>
		    	    <% } %>	    	    	
		    	    <%}  %>
		 </ul>
      	</td>
   		<td style="width: 15%; height: 700px;"></td>
    </tr>
  </table>
</body>
</html>