<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<!DOCTYPE html>
<html>
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
                   <h1>로그인</h1>
               </header>
               <form action="./loginAction.jsp" method="post">
                   <div class="form-group">
                       <input type="text" id="userEmail" name="userEmail" placeholder="이메일을 입력하세요." style="width:410px;">
                   </div>
                   <div class="form-group">
                       <input type="password" id="userPassword" name="userPassword" placeholder="비밀번호을 입력하세요." style="width:410px;">
                   </div>
                   <div class="form-group">
                       <input type="hidden" id="userLevel" name="userLevel">
                       <input type="submit" value="로그인" />
                   </div>
               </form>
           </div>
        </td>
        <td style="width: 15%;"></td>