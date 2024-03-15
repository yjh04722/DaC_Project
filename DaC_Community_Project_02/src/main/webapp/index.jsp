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
<link rel="stylesheet" href="./css/main.css">
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
        <td style="width: 15%;"></td>
        <td style="width: 70%;">
        <div id="slide">
            <div class="slidebanner">
                <ul>
                    <li><img src="./img/dog/group-portrait-adorable-puppies.jpg" alt="slide1" style="width: 100%; height: 100%;"></li>
                    <li><img src="./img/dog/group-portrait-adorabpuppies.jpg" alt="slide2" style="width: 100%; height: 100%;"></li>
                    <li><img src="./img/dog/pet-accessories-still-life-concept-with-i-love-pets-text.jpg" alt="slide3" style="width: 100%; height: 100%;"></li>
                    <li><img src="./img/dog/portrait-collection-adorable-puppies.jpg" alt="slide3" style="width: 100%; height: 100%;"></li>
                    <li><img src="./img/dog/quotes-about-family-concept.jpg" alt="slide3" style="width: 100%; height: 100%;"></li>
                </ul>
            </div>
         </div>       
   		<div class= "container_left">
    	<div class= "row">
    	    <table class= "table table-stripped" style= "text-align: center; boarder: 1px solid #dddddd">
    	    	<thead>
	    	    	<tr>
	    	    		<th class="tt2">제목</th>
	    	    		<th class="tt3">작성자</th>
	    	    	</tr>
    	    	</thead>
    	    	<tbody>
   	    			<%
   	    				BbsDAO bbsDAO = new BbsDAO();
   	    				ArrayList<Bbs> list = bbsDAO.getList2(pageNumber);
   	    				for (int i =0; i<list.size(); i++){
   	    			%>
   	    			<tr>
   	    				<td><a href ="./bbs/view.jsp?bbsId=<%=list.get(i).getBbsId()%>"><%=list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>")%></a></td>
   	    				<td><%=list.get(i).getUserId()%></td>
   	    			</tr>
   	    			<%
   	    				}
   	    			%>
    	    	</tbody>
   	    	   	 <tr>
  	    			<td style=""><a href ="./bbs/bbs.jsp" style = "font-size:10pt; text-align:right; margin-left:100px;">>>더보기<<</a></td>
  	    		</tr>
    	    </table>
    	</div>
    	</div>
    	 <div class= "container_right">
	    	    <table class= "table table-stripped" style= "text-align: center">
		   	    	<tr>
		   	    		<th class="tt2">제목</th>
	    	    		<th class="tt3">작성자</th>
		   	    	</tr>
		    		<tr>
		    			<td>관리자</td>
		    			<td>안녕하세요</td>
		    		</tr>
	    	    </table>
    	 </div>
         </td>
         <td style="width: 15%;"></td>
      </tr>
  </table>
</body>
</html>