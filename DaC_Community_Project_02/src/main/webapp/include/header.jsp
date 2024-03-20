<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import = "user.UserDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- jQuery -->
    <script src="http://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script src="http://code.jquery.com/jquery-migrate-1.4.1.min.js"></script>

    <!-- javascript -->
    <script src="../js/index.js"></script>
    <script src="../js/join.js"></script>
    <script src="../js/login.js"></script>
    <script src="../js/weather.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../js/effectiveness.js"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <!-- font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Hi+Melody&display=swap" rel="stylesheet">

    <!-- css -->
    <link rel="stylesheet" href="../css/index.css">
    <link rel="stylesheet" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/join.css">
    <link rel="stylesheet" href="../css/bbs.css">
  
    <title>Dog & Cat Community</title>

</head>
<% 
String rq_userEmail = null;
String rq_userId = null;
if (session.getAttribute("userEmail") != null){
	rq_userEmail = (String) session.getAttribute("userEmail");
	rq_userId = (String) session.getAttribute("userId");
}
%>
<body>
    <table style="width: 100%; height: 50px;">
        <tr>
            <td style="width: 15%; height: 50px;"></td>
            <td style="width: 70%; height: 50px;">
                <div class="hi-melody-regular" style="text-align: left; padding-top: 10px;">강아지와 고양이를<br>사랑하는 사람들의 모임</div>
                <div id="weather_info" style="margin-top: -30px;">
                    <section>
                        <figure class="icon" style="float: right; margin-top: -14px;"></figure>
                        <span style="float: right; font-size: 12.5pt;">현재온도 : <p class="temp" style="float: right;"></p></span>
                        <aside>
                            <span style="float: right; font-size: 12.5pt;">최고기온 : <p class="temp_max" style="float: right;"></p></span>
                            <span style="float: right; font-size: 12.5pt;">최저기온 : <p class="temp_min" style="float: right;"></p></span>
                        </aside>
                    </section>
                    <img src="https://www.vedantaresources.com/SiteAssets/Images/loading.gif" alt="" id="load_img">
                </div>
            </td>
            <td style="width: 15%; height: 50px;"></td>
        </tr>

        <tr>
            <td style="width: 15%; height: 50px;"></td>
            <td style="width: 70%; height: 50px;">
                <div><img src="../img/logo.png" alt="logo" style="padding-left: 30px; float: left; width: 130px; height: 70px; right: 12px;"></div>
                <div style="margin-right: 400px;">
                    <nav id="gnb">
                        <ul style="padding-top: 25px;">
                            <li><a href="/">HOME</a></li>
                            <li><a href="../bbs/bbs.jsp">자유게시판</a></li>
                            <li><a href="#">사진게시판</a></li>
                            <li><a href="#">실종신고</a></li>
                            <li><a href="#">문의사항</a></li>
                        </ul>
                    </nav>
                </div>
                <!--<div class="search">
                    <input type="text" id="search" placeholder="검색어 입력" style="float: right; width: 100%; border: 1px solid #bbb; border-radius: 8px; padding: 10px 12px; font-size: 14px;">
                    <img src="../img/free-icon-font-search-3917132.png" alt="search" style="position : absolute; width: 17px; bottom: 10px; left: 170px;">
                </div>-->
                <div class="login">
                	<%
                		if(rq_userEmail == null){
                	%>
                    <a href="../join/join.jsp" style="float: left;">회원가입</a>
                    <img src="../img/free-icon-font-tally-1-9585497.png" alt="" style="width: 17px; padding-left: 10px;">
                    <a href="../login/login.jsp" style="float: right;">로그인</a>
                    <%
                    	}else{
                    %>
                    <a href="#" style="float: left;"><%=rq_userEmail %> 님</a>
                    <img src="../img/free-icon-font-tally-1-9585497.png" alt="" style="width: 17px; padding-left: 10px;">
                    <a href="../login/logoutAction.jsp" style="float: right;">로그아웃</a>
                    <%
                    	}
                    %>
                </div>
            </td>
            <td style="width: 15%; height: 50px;"></td>
        </tr>
     </table>
</body>
</html>