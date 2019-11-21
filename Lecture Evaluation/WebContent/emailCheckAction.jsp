<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "user.UserDAO"%>
<%@ page import = "util.SHA256"%>
<%@ page import = "java.io.PrintWriter"%>

<%
	request.setCharacterEncoding("UTF-8");
	String code = null;
	String userID = null;
	
	if(session.getAttribute("code") != ""){
		code = request.getParameter("code");					//request.getParameter로 받음
	}
	
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");		//객체로 받아오기 때문에 형 변환
	}

	UserDAO userDAO = new UserDAO();
	
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요')");
		script.println("history.back()");
		script.println("</script>");
		script.close();
		return;
	}
	
	String userEmail = userDAO.getUserEmail(userID);
	boolean isRight = (new SHA256().getSHA256(userEmail).equals(code))? true : false;	// 정상적인 인증인지 검사
	
	if(isRight == true){
		userDAO.setUserEmailChecked(userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공하였습니다')");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	else{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('잘못된 코드입니다')");
		script.println("alert('your code = "+code+"')");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>