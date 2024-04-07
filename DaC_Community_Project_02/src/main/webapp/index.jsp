<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="missingbbs.MissingBbsDAO" %>
<%@ page import="missingbbs.MissingBbs" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="visitor.VisitorFilter" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="stylesheet" href="./css/main.css">
</head>
<body>
 <%  
	 MissingBbsDAO missingBbsDAO = new MissingBbsDAO();
 
	 String userEmail = null; // 로그인이 된 사람들은 로그인정보를 담을 수 있도록한다
	 if (session.getAttribute("userEmail") != null){
	     userEmail = (String)session.getAttribute("userEmail");
	 }
	 int pageNumber = 1; // 기본페이지 기본적으로 페이지 1부터 시작하므로
	 if (request.getParameter("pageNumber") != null){
	 	pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	 }
	 
		// 총 게시글 수
		int cnt = missingBbsDAO.getCount();
		
		// 한 페이지에 출력될 글 수
		int pageSize = 2; 

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
  	    			<td style=""><a href ="./bbs/bbs.jsp" style="font-size:10pt; text-align:right; margin-left:50px;">>>더보기<<</a></td>
  	    		</tr>
    	    </table>
    	</div>
    	</div>
    	 <div class= "container_right">
   		<%
			ArrayList<MissingBbs> list2 = missingBbsDAO.getList2(currentPage);
			for (int j =0; j < list2.size(); j++){
		%>
		<div class= "container_img" style="margin-top:-20px;">
				<h3>오늘의 정보</h3>
			    <table class= "table table-stripped" style= "text-align: center; boarder: 1px solid #dddddd">
						<tr>
							<td><img src="<%=list2.get(j).getFilename()%>" style="width:200px; height:200px;"></td>
							<td style="text-align: left;">
								<p>유기날짜 : <%=list2.get(j).getHappenDt()%></p>
								<p>유기장소 : <%=list2.get(j).getHappenPlace()%></p>
								<p>특   징 : <%=list2.get(j).getSpecialMark()%></p>
								<p>보 호 소 : <%=list2.get(j).getCareNm()%></p>
								<p>보호소번호 : <%=list2.get(j).getCareTel()%></p>
								<p>보호소주소 : <%=list2.get(j).getCareAddr()%></p>
							</td>
						</tr>
				    </table>
				</div>
			</div>
	    <%
			}
		%>
         </td>
         <td style="width: 15%;"></td>
      </tr>
  </table>
</body>
</html>