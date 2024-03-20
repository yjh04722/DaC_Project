<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
</head>
<body>
<table>
	  <tr>
	  <td style="width: 15%;"></td>
	  <td style="width: 70%;">
	      <img src="../img/login-samo.png" alt="login" style="width: 300px; height: 200px; display:block; margin:auto;">
	      <div class="container">
	          <header>
	              <h1>회원가입</h1>
	          </header>
	          <form action="./joinAction.jsp" method="post" name="joinForm" onsubmit="return join()">
	              <div class="form-group">
	              	  <input type="hidden" id="idDuplication" value="idUncheck">
	                  <input type="email" id="userEmail" name="userEmail" placeholder="이메일을 입력하세요." style="width:410px;">
	                  <button type="button" id="btn1" ondblclick="checkid()">중복 확인</button>
	              </div>
	              <div class="form-group">
	                  <input type="password" id="userPassword" name="userPassword" placeholder="비밀번호을 입력하세요." style="width:410px;">
	              </div>
	              <div class="form-group">
	                  <input type="password" id="re_password" name="re_password" placeholder="비밀번호를 재입력하세요.">
	              </div>
	              <div class="form-group">
	                  <input type="text" id="userName" name="userName" placeholder="이름을 입력하세요.">
	              </div>
	              <div class="form-group">
	              	  <input type="hidden" id="zip_code" placeholder="우편번호">
	                  <input type="text" id="userAddr" name="userAddr" placeholder="주소를 입력하세요.">
	                  <button type="button" id="btn2" onclick="openZipSearch()">주소 검색</button>
	              </div>
	              <div class="form-group">
	                  <input type="submit" value="가입하기">
	              </div>
	          </form>
	      </div>
	  </td>
	  <td style="width: 15%;"></td>
	 </tr>
  </table>
</body>
</html>