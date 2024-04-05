<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
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
</style>
</head>
<body>
	<%
		String code = request.getParameter("code"); //db : table 명
		BbsDAO bbsDAO = new BbsDAO();
		
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
		int cnt = bbsDAO.getCount();
		
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
		<div class= "container">
		    	<div class= "row">
		    		<span style="margin-right: 950px;"><b>총게시글 수 : </b><%=cnt %></span>
		    	    <table class= "table table-hover" style= "text-align: center; boarder: 1px solid #dddddd">
		    	    	<thead>
			    	    	<tr>
			    	    		<th class="tt1">번호</th>
			    	    		<th class="tt2">제목</th>
			    	    		<th class="tt3">작성자</th>
			    	    		<th class="tt4">작성일</th>
			    	    	</tr>
		    	    	</thead>
		    	    	<tbody>
		   	    			<%
		   	    				ArrayList<Bbs> list = bbsDAO.getList(currentPage);
		   	    				int num = cnt - ((currentPage - 1) * pageSize);
		   	    				for (int i =0; i < list.size(); i++){
		   	    			%>
		   	    			<tr>
		   	    				<td><%=num %></td>
		   	    				<td><a href ="./view.jsp?bbsId=<%=list.get(i).getBbsId()%>&code=<%=list.get(i).getCode()%>"><%=list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>")%></a></td>
		   	    				<td><%=list.get(i).getUserId()%></td>
		   	    				<td><%=list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시" + list.get(i).getBbsDate().substring(14, 16) + "분" %></td>
		   	    			</tr>
		   	    			<%
		   	    					num--;
		   	    				}
		   	    			%>
		    	    	</tbody>
		    	    </table>
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
		    	    	<li><a href="bbs.jsp?pageNum=<%=startPage-pageBlock %>">Prev</a></li>
		    	    <% } %>
		    	    
		    	     <% for(int i = startPage; i <= endPage; i++){ %>
		    	    	<li><a href="bbs.jsp?pageNum=<%=i %>"><%=i %></a></li>
		    	    <% } %>
		    	    
		    	     <% if(endPage < pageCount){ %>
		    	    	<li><a href="bbs.jsp?pageNum=<%=startPage+pageBlock %>">Next</a></li>
		    	    <% } %>	    	    	
		    	    <%}  %>
		    	    </ul>
		    	    <a href= "/bbs/bbsWrite.jsp?code=<%=code%>" class= "btn btn-primary pull-right">글쓰기</a>
		    	</div>
	    </div>
      </td>
      <td style="width: 15%; height: 700px;"></td>
    </tr>
  </table>
</body>
</html>