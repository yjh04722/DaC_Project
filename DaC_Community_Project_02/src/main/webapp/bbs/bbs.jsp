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
		<div class= "container">
		    	<div class= "row">
		    	    <table class= "table table-stripped" style= "text-align: center; boarder: 1px solid #dddddd">
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
		   	    				BbsDAO bbsDAO = new BbsDAO();
		   	    				ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
		   	    				for (int i =0; i<list.size(); i++){
		   	    			%>
		   	    			<tr>
		   	    				<td><%=list.get(i).getBbsId()%></td>
		   	    				<td><a href ="./view.jsp?bbsId=<%=list.get(i).getBbsId()%>"><%=list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>")%></a></td>
		   	    				<td><%=list.get(i).getUserId()%></td>
		   	    				<td><%=list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시" + list.get(i).getBbsDate().substring(14, 16) + "분" %></td>
		   	    			</tr>
		   	    			<%
		   	    				}
		   	    			%>
		    	    	</tbody>
		    	    </table>
		    	    <%
		    	    	if(pageNumber != 1){
		    	    %>		
		    	    		<a href= "bbs.jsp?pageNumber=<%=pageNumber -1%>" class="btn btn-success btn-arraw-left">이전</a>
		    	    <% 
		    	    	}if(bbsDAO.nextPage(pageNumber + 1)){
		    	    %>		
		    	    		<a href= "bbs.jsp?pageNumber=<%=pageNumber +1%>" class="btn btn-success btn-arraw-left">다음</a>
		    	    <% 
		    	    	}
		    	    %>
		    	    
		    	    <a href= "../bbs/bbsWrite.jsp" class= "btn btn-primary pull-right">글쓰기</a>
		    	</div>
	    </div>
      </td>
      <td style="width: 15%; height: 700px;"></td>
    </tr>
  </table>
</body>
</html>