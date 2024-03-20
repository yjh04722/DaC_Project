<%@ page import = "user.UserDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
</head>
<body>
<h2>아이디중복체크</h2>
<%

request.setCharacterEncoding("UTF-8");
String userEmail = (String)request.getParameter("userEmail");


UserDAO udao = new UserDAO();


int result = udao.joinIdCheck(userEmail);
if (result == 1){
	out.print("사용가능한 아이디입니다");
	
	
%>
	 <input type="button" value="아이디 사용하기" onclick="result()">
<%	

}else if(result == 0){
	out.print("중복된 아이디입니다");
	
}else{
	out.print("DB에러 발생!!!(-1)"); 
}

%>
<!-- 팝업창구현  -->
<fieldset>
	<form action="./joinIdCheck.jsp" method="post" name="wfr" onsubmit="">
		<input type="text" name="userEmail" value="<%=userEmail%>">
		<input type="submit" value="확인" onclick="close_tab()">	 
	</form>
</fieldset>

 <script type="text/javascript">
    function result(){
    	opener.document.joinForm.userEmail.value = document.wfr.userEmail.value;
    	opener.document.joinForm.userEmail.readOnly = true;
    	opener.document.joinForm.idDuplication.value = "true";
 	  	window.close();  	
    }
    
    function close_tab(){
    	opener.document.joinForm.idDuplication.value = "false";
 	  	window.close();  	
    }
 </script>

</body>