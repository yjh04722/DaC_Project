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
    
    int parentId = 0;
    String parentIdParam = request.getParameter("parentId");
    if (parentIdParam != null && !parentIdParam.isEmpty()) {
        try {
            parentId = Integer.parseInt(parentIdParam); // 부모 글의 ID 받아오기
        } catch (NumberFormatException e) {
            // 부모 글의 ID가 유효한 숫자가 아닌 경우에 대한 처리
            e.printStackTrace(); // 혹은 로깅하여 디버깅 정보를 기록
        }
    }
    
    if (session.getAttribute("userEmail") != null){
        userEmail = (String)session.getAttribute("userEmail");
    }
    
    BoardDTO board = new BoardDTO();
    board.setId(userEmail); // 사용자 ID 설정
    board.setWriter(userEmail); // 작성자 이름 설정
    board.setSubject(subject); // 게시글 제목 설정
    board.setReadcount(0); // 조회수 초기화
    board.setRef(parentId); // 참조 초기화
    board.setReStep(0); // 답변 순서 초기화
    board.setReLevel(0); // 답변 레벨 초기화
    board.setContent(content); // 게시글 내용 설정
    board.setIp("127.0.0.1"); // 사용자 IP 주소 설정
    board.setStatus(1); // 게시글 상태 설정
    
    if (userEmail == null){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인하세요.')");
        script.println("location.href = '/login/login.jsp'");    // 메인 페이지로 이동
        script.println("</script>");
    } else {
        if (board.getSubject() == null || board.getContent() == null || parentId == 0){ // parentId 대신 board.getRef() == 0을 사용하면 더 직관적일 것입니다.
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('모든 문항을 입력해주세요.')");
            script.println("history.back()");    // 이전 페이지로 사용자를 보냄
            script.println("</script>");
        } else {
            BoardDAO boardDAO = new BoardDAO();
            int result = boardDAO.reply(parentId, board);
            if (result == 0){ // 답글 작성 실패시
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('답글 작성에 실패했습니다.')");
                script.println("history.back()");    // 이전 페이지로 사용자를 보냄
                script.println("</script>");
            } else { // 답글 작성 성공시
            	boardDAO.updateRef(parentId, parentId);
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('답글이 작성되었습니다.')");
                script.println("location.href = 'board.jsp'");    // 메인 페이지로 이동
                script.println("</script>");    
            }
        }   
    }
%>
</body>
</html>
