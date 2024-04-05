<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">    
</head>
<body>
<%
    String userEmail = null;
    String subject = request.getParameter("subject");
    String content = request.getParameter("content");
    int parentId = Integer.parseInt(request.getParameter("parentId")); // 부모 글의 ID 받아오기
    
    if (session.getAttribute("userEmail") != null){
        userEmail = (String)session.getAttribute("userEmail");
    }
    BoardDTO newBoard = new BoardDTO();
    newBoard.setId(userEmail); // 사용자 ID 설정
    newBoard.setWriter(userEmail); // 작성자 이름 설정
    newBoard.setSubject(subject); // 게시글 제목 설정
    newBoard.setReadcount(0); // 조회수 초기화
    newBoard.setRef(parentId); // 참조 초기화 (부모 글의 ID로 설정)
    newBoard.setReStep(0); // 답변 순서 초기화
    newBoard.setReLevel(0); // 답변 레벨 초기화
    newBoard.setContent(content); // 게시글 내용 설정
    newBoard.setIp("127.0.0.1"); // 사용자 IP 주소 설정
    newBoard.setStatus(1); // 게시글 상태 설정
    
    if (userEmail == null){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인하세요.')");
        script.println("location.href = '/login/login.jsp'");    // 메인 페이지로 이동
        script.println("</script>");
    } else {
        if (newBoard.getSubject() == null || newBoard.getContent() == null){
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('모든 문항을 입력해주세요.')");
            script.println("history.back()");    // 이전 페이지로 사용자를 보냄
            script.println("</script>");
        } else {
            BoardDAO boa = new BoardDAO();
            int result = boa.insertBoard(newBoard);
            if (result == -1){ // 글쓰기 실패시
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('글쓰기에 실패했습니다.')");
                script.println("history.back()");    // 이전 페이지로 사용자를 보냄
                script.println("</script>");
            } else { // 글쓰기 성공시
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('게시글이 작성되었습니다.')");
                script.println("location.href = 'board.jsp'");    // 메인 페이지로 이동
                script.println("</script>");    
            }
        }   
    }
%>
</body>
</html>
