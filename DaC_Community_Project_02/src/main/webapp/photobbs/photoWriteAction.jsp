<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import = "java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="photobbs.PhotoBbs" %>
<%@ page import="photobbs.PhotoBbsDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">	
</head>
<body>
 <%
 	request.setCharacterEncoding("utf-8"); //한글 깨짐 방지
 	String bbsContent = null;
	String photoName = null;
	String uploadPath = "C:\\Users\\yjh_0\\git\\repository\\DaC_Community_Project_02\\src\\main\\webapp\\bbsUpload";
	int size = 5*1024*1024;
	PhotoBbs photobbs = new PhotoBbs();
	
	// 세션에 저장된 아이디와 레벨 불러옴
	String userEmail = null;
	String userLevel = null;
	
	if (session.getAttribute("userEmail") != null){
	    userEmail = (String)session.getAttribute("userEmail");
	    userLevel = (String)session.getAttribute("userLevel");
	}
	
 	try{
		MultipartRequest multi = new MultipartRequest(request, uploadPath, size, "utf-8", new DefaultFileRenamePolicy());		

 		bbsContent = multi.getParameter("bbsContent");
 		photobbs.setBbsContent(bbsContent);
		Enumeration files = multi.getFileNames();
	
		String file =(String)files.nextElement();
		photoName = multi.getFilesystemName(file);
		photobbs.setPhotoName(photoName);
		
	}catch(Exception e){
		e.printStackTrace();
	}

 	if (userEmail == null){
         PrintWriter script = response.getWriter();
         script.println("<script>");
         script.println("alert('로그인하세요.')");
         script.println("location.href = '/login/login.jsp'");    // 로그인 페이지로 이동
         script.println("</script>");
 	}else{
 		if (photobbs.getPhotoName() == null || photobbs.getBbsContent() == null){
     		PrintWriter script = response.getWriter();
             script.println("<script>");
             script.println("alert('모든 문항을 입력해주세요.')");
             script.println("history.back()");    // 이전 페이지로 사용자를 보냄
             script.println("</script>");
     	}else{
     		PhotoBbsDAO bbsDAO = new PhotoBbsDAO();
             int result = bbsDAO.write(photobbs.getPhotoName(), userEmail, photobbs.getBbsContent());
             if (result == -1){ // 글쓰기 실패시
                 PrintWriter script = response.getWriter();
                 script.println("<script>");
                 script.println("alert('글쓰기에 실패했습니다.')");
                 script.println("history.back()");    // 이전 페이지로 사용자를 보냄
                 script.println("</script>");
             }else{
		 		PrintWriter script = response.getWriter();
		 		script.println("<script>");
		 		script.println("alert('글쓰기에 성공했습니다.')");
				script.println("location.href= '../photobbs/photoBbs.jsp'");
		 		script.println("</script>");
			 }
     	}	
 	}
 %>
</body>
</html>