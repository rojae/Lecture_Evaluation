<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter"%>
<%@ page import = "user.UserDAO" %>
<%@ page import = "evaluation.EvaluationDTO" %>
<%@ page import = "evaluation.EvaluationDAO" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="charset=UTF-8">
<meta name="viewport"
	content="width = device-width, initial-scale = 1, shrink-to-fit=no">
<title>강의 평가 웹 사이트</title>
<!-- 부트스트랩 Css 추가 -->
<link rel="stylesheet" href="./css/bootstrap.min.css">
<!-- 커스텀 css 추가 -->
<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	
	String lectureDivide = "전체";
	String searchType = "최신순";
	String search = "";
	int pageNumber = 0;
	if(request.getParameter("lectureDivide") != null){
		lectureDivide = request.getParameter("lectureDivide");
	}
	if(request.getParameter("searchType") != null){
		searchType = request.getParameter("searchType");
	}
	if(request.getParameter("search") != null){
		search = request.getParameter("search");
	}
	if(request.getParameter("pageNumber") != null){
		try{
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));	
		}
		catch(Exception e){
			System.out.println("검색 페이지 오류");
		}
	}
	
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요')");
		script.println("location.href = 'userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
	if(emailChecked == false){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이메일 인증을 해주세요')");
		script.println("location.href = 'emailSendConfirm.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active"><a class="nav-link"
					href="index.jsp">메인</a></li>
				<li class="nav-item dropdown"><a
					class="nav-link dropdown-toggle" id="dropdown"
					data-toggle="dropdown">회원관리</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
<%
		if(userID == null){
%>
					<a class="dropdown-item" href="userLogin.jsp">로그인</a> 
					<a class="dropdown-item" href="userJoin.jsp">회원가입</a> 
<% 
				}else{
%>
					<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
<%
				}
%>
					
					</div></li>
			</ul>
			<form action="./index.jsp" method = "get" class="form-inline my-2 my-lg-0">
				<input type ="text" name = "search" class="form-control mr-sm-2" type="search"
					placeholder="내용을 입력하세요" aria-label="Search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>
	<section class="container">
		<form method="get" action="./index.jsp" class="form-inline mt-3">
			<select name="lectureDivide" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="전공"<%if(lectureDivide.equals("전공")) out.println("selected"); %>>전공</option>
				<option value="교양"<%if(lectureDivide.equals("교양")) out.println("selected"); %>>교양</option>
				<option value="기타"<%if(lectureDivide.equals("기타")) out.println("selected"); %>>기타</option>
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순">최신순</option>
				<option value="추천순"<%if(searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
			</select> 
			<input type="text" name="search" class="form-control mx-1 mt-2"
				placeholder="내용을 입력하세요"></input>
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal"
				href="#registerModal">등록하기</a> <a class="btn btn-danger mx-1 mt-2"
				data-toggle="modal" href="#reportModal">신고</a>
		</form>
<%
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
	
	if(evaluationList != null)
			for(int i = 0; i < evaluationList.size(); i++){
				if(i==5) break;
				EvaluationDTO evaluation = evaluationList.get(i);
%>
	<!-- 위쪽으로 3여백 -->
	<div class="card bg-light mt-3">
		<div class="card-header bg-light">
			<div class = "row">
				<div class = "col-8 text-left"><%= evaluation.getLectureName() %>&nbsp;<small><%= evaluation.getProfessorName() %></small></div>
				<div class = "col-4 text-right">
					종합<span style="color: red;"><%=evaluation.getTotalScore()%></span>
				</div>
			</div>
		</div>
		<div class="card-body">
			<h5 class = "card-title">
				<%= evaluation.getEvaluationTitle() %>&nbsp;<small>(<%= evaluation.getLectureYear() %>)년<%= evaluation.getSemesterDivide()%></small>
			</h5>
			<p class="card-text"><%= evaluation.getEvaluationContent() %></p>
			<div class = "row">
				<div class = "col-9 text-left">
					성적<span style="color: red;"><%= evaluation.getCreditScore() %> </span>
					널널<span style="color: red;"><%= evaluation.getComfortableScore() %> </span>
					강의<span style="color: red;"><%= evaluation.getLectureScore() %> </span>
					<span style="color: green;">(<%= evaluation.getLikeCount() %>)</span>
				</div>
			<div class = "col-3 text-right">
				<a onclick = "return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=<%= evaluation.getEvaluationID() %>">추천</a>
				<a onclick = "return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=<%= evaluation.getEvaluationID() %>">삭제</a>
			</div>
			</div>
		</div>
	</div>
<%
	}
%>
	</section>
<ul class = "pagination justify-content-center mt-3">
<li class = "page-item">
<%
	if(pageNumber <= 0){
%>
	<a class = "page-link disabled">이전</a>
<%
	} else{
%>	
	<a class = "page-link" 
	href="./index.jsp?lectureDivide=<%=URLEncoder.encode(lectureDivide, "UTF-8")%>
	&searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>
	&search=<%= URLEncoder.encode(search,"UTF-8") %>
	&pageNumber=<%= pageNumber-1 %>">이전</a>
<%
	}
%>
</li>
<li>
<%
	if(evaluationList.size() < 6){
%>
	<a class = "page-link disabled">다음</a>
<%
	} else{
%>	
	<a class = "page-link" 
	href="./index.jsp?lectureDivide=<%=URLEncoder.encode(lectureDivide, "UTF-8")%>
	&searchType=<%= URLEncoder.encode(searchType, "UTF-8") %>
	&search=<%= URLEncoder.encode(search,"UTF-8") %>
	&pageNumber=<%= pageNumber+1 %>">다음</a>
<%
	}
%>
	</li>
</ul>
	
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog"
		aria-labelledby="modal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">평가 등록</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./evaluationRegisterAction.jsp" method="post">
						<div class="form-row">
							<div class="form-group col-sm-6">
								<label>강의명</label> <input type="text" name="lectureName"
									class="form-control" maxlength="20" placeholder="강의명을 입력하세요">
							</div>
							<div class="form-group col-sm-6">
								<label>교수명</label> <input type="text" name="professorName"
									class="form-control" maxlength="20" placeholder="교수명을 입력하세요">
							</div>
						</div>
						<!-- 한개의 행은 12개의 열 -->
						<div class="form-row">
							<div class="form-group col-sm-4">
								<label>수강연도</label> <select name="lectureYear"
									class="form-control">
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018" selected>2018</option>
									<option value="2019">2019</option>
									<option value="2020">2020</option>
									<option value="2021">2021</option>
									<option value="2022">2022</option>
									<option value="2023">2023</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>수강학기</label> <select name="semesterDivide"
									class="form-control">
									<option value="1학기" selected>1학기</option>
									<option value="여름학기">여름학기</option>
									<option value="2학기">2학기</option>
									<option value="겨울학기">겨울학기</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>강의 구분</label> <select name="lectureDivide"
									class="form-control">
									<option value="전공" selected>전공</option>
									<option value="교양">교양</option>
									<option value="기타">기타</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label> <input type="text" name="evaluationTitle"
								class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label>내용</label> <textarea name="evaluationContent"
								class="form-control" maxlength="2048" style="height: 180px;">
							</textarea>
						</div>
						<div class = "form-row">
							<div class = "form-group col-sm-3">
								<label>종합</label>
								<select name ="totalScore" class = "form-content">
									<option value = "A" selected>A</option>
									<option value = "B">B</option>
									<option value = "C">C</option>
									<option value = "D">D</option>
									<option value = "E">E</option>
									<option value = "F">F</option>
								</select>
							</div>
							<div class = "form-group col-sm-3">
								<label>성적</label>
								<select name ="creditScore" class = "form-content">
									<option value = "A" selected>A</option>
									<option value = "B">B</option>
									<option value = "C">C</option>
									<option value = "D">D</option>
									<option value = "E">E</option>
									<option value = "F">F</option>
								</select>
							</div>
							<div class = "form-group col-sm-3">
								<label>널널</label>
								<select name ="comfortableScore" class = "form-content">
									<option value = "A" selected>A</option>
									<option value = "B">B</option>
									<option value = "C">C</option>
									<option value = "D">D</option>
									<option value = "E">E</option>
									<option value = "F">F</option>
								</select>
							</div>
							<div class = "form-group col-sm-3">
								<label>강의</label>
								<select name ="lectureScore" class = "form-content">
									<option value = "A" selected>A</option>
									<option value = "B">B</option>
									<option value = "C">C</option>
									<option value = "D">D</option>
									<option value = "E">E</option>
									<option value = "F">F</option>
								</select>
							</div>
						</div>
						<div class = "modal-footer">
							<button type = "button" class = "btn btn-secondary" data-dismiss="modal">취소</button>
							<button type = "submit" class = "btn btn-primary">등록</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog"
		aria-labelledby="modal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label=" Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./reportAction.jsp" method="post">
						<div class="form-group">
							<label>신고 제목</label> <input type="text" name="reportTitle"
								class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label>내용</label> <textarea name="reportContent"
								class="form-control" maxlength="2048" style="height: 180px;">
							</textarea>
						</div>
						<div class = "modal-footer">
							<button type = "button" class = "btn btn-secondary" data-dismiss="modal">취소</button>
							<button type = "submit" class = "btn btn-danger">신고하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<footer class = "bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2019 오재성  All Rights Reserved.
	</footer>
	<!-- 제이쿼리 자바스크립트 투가하기 -->
	<script src="./js/jquery.min.js"></script>
	<!-- pooper 자바스크립트 추가하기 -->
	<script src="./js/pooper.js"></script>
	<!-- bootstrap 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>