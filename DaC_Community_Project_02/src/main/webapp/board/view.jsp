<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/include/header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        .comment_write {
            display:flex;
        }
    </style>
</head>
<body>
<%
    String code = request.getParameter("code"); //db : table 명
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

    // 게시글 번호
    int num = 0;

    if(request.getParameter("num") != null){
        num = Integer.parseInt(request.getParameter("num"));
    }
    if(num == 0){
        PrintWriter script=response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다.')");
        script.println("location.href='/bbs/bbs.jsp'");
        script.println("</script>");
    }

    BoardDAO boa = new BoardDAO();
    BoardDTO board = boa.getBoard(num); // 해당 번호의 게시글 정보 가져오기

%>
<table style="width: 100%; height: 50px; text-align:center;">
    <tr>
        <td style="width: 15%;"></td>
        <td style="width: 70%;">
            <div class="container">
                <div class="row">
                    <header>
                        <h1>게시판 글 보기</h1>
                    </header>
                    <table class="table table-hover">
                        <tr>
                            <td style="width: 20%"><b>글 제목</b></td>
                            <td colspan="2"><%= board.getSubject().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
                        </tr>
                        <tr>
                            <td><b>작성자</b></td>
                            <td colspan="2"><%= board.getId() %></td>
                        </tr>
                        <tr>
                            <td><b>작성일자</b></td>
                            <td colspan="2"><%= board.getRegDate() %></td>
                        </tr>
                        <tr>
                            <td><b>내용</b></td>
                            <td colspan="2" style="min-height: 200px; text-align: left;"><%= board.getContent().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
                        </tr>
                    </table>
                    <a href="./board.jsp" class="btn btn-success">목록</a>
                    <%
                        if(userEmail != null && userEmail.equals(board.getId()) || userLevel != null && userLevel.equals("2")){//해당 글이 본인 alc 관리자이라면 수정과 삭제가 가능
                    %>
                    <a href="./boardUpdate.jsp?num=<%=num%>" class="btn btn-warning">수정</a>
                    <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?num=<%=num%>" class="btn btn-danger">삭제</a>
                    <%
                        }
                    %>
                    <a href= "/board/boardReply.jsp?num=<%=board.getNum() %>&parentId=<%=board.getNum() %>" class= "btn btn-primary pull-right">답글쓰기</a>
                </div>
            </div>
        </td>
        <td style="width: 15%;"></td>
    </tr>
</table>
</body>
</html>