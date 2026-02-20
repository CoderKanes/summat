<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%--
    작성자 : 김용진
    내용 : (실험용페이지) 비밀번호를 확인하고 맞을경우 다음요청 페이지로 넘겨주는 UtilPage
--%>   

<%
    String href = request.getParameter("next");
	
    Boolean isAuth = null;
	if (session != null) {
    	Object authAttr = session.getAttribute("authenticated");
    	isAuth = (authAttr instanceof Boolean) ? (Boolean) authAttr : null;
	}
	
	String sid= (String)session.getAttribute("sid");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>

<link rel="stylesheet" href="/summat/resources/css/style.css">

<style>
.password-wrap {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #f5f3ef;
}

.password-card {
    background: #fff;
    width: 360px;
    padding: 32px;
    border-radius: 16px;
    box-shadow: 0 8px 24px rgba(0,0,0,0.08);
    text-align: center;
}

.password-card h2 {
    margin-bottom: 8px;
    font-size: 20px;
}

.password-card p {
    font-size: 14px;
    color: #666;
    margin-bottom: 24px;
}

.password-card input[type="password"] {
    width: 100%;
    padding: 12px;
    border-radius: 8px;
    border: 1px solid #ccc;
    font-size: 14px;
    margin-bottom: 16px;
     box-sizing: border-box;
}

.password-actions {
    display: flex;
    gap: 12px;
}

.password-actions button {
    flex: 1;
    padding: 12px 0;
    border-radius: 8px;
    border: none;
    cursor: pointer;
    font-size: 14px;
}

.password-actions .confirm {
    background: #ff8a00;
    color: #fff;
}

.password-actions .cancel {
    background: #e0e0e0;
    color: #333;
}
</style>
</head>

<body>
<div class="password-wrap">
    <div class="password-card">
        <h2>비밀번호 확인</h2>
        
       
       <%if(isAuth == null || sid == null || sid.isEmpty()){%>
        	 <p>로그인정보를 확인 할 수 없습니다. <br/>이 작업을 진행하려면 로그인 정보가 필요합니다. </p>
          	    <div class="password-actions">
                 <button class="confirm" type="button" onclick="location.href='/summat/main/main.jsp'">홈으로</button>
                 <button class="cancel" type="button" onclick="history.back()">이전페이지로</button>
             </div>
       <% }else{%>        
        
        <p>이 작업을 진행하려면 비밀번호를 입력하세요.</p>
        <input type="password" id="password" placeholder="비밀번호 입력" autofocus>
	
	    <div class="password-actions">
            <button class="confirm" type="button" onclick="checkPassword()">확인</button>
            <button class="cancel" type="button" onclick="history.back()">취소</button>
        </div>
        <% }%>
    </div>
</div>

<script>
function checkPassword() {
    const pw = document.getElementById("password").value;
    if (!pw) {
        alert("비밀번호를 입력하세요.");
        return;
    }
    // 기존 로직 연결
}
</script>

</body>
</html>


<script>
function checkPassword() {
    const password = document.getElementById("password").value;

    fetch("/summat/util/checkPasswordPro.jsp", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: new URLSearchParams({
            password: password
        })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            // 히스토리 안 쌓이게 replace 사용
            const url = new URL("<%=href%>", window.location.origin);
			url.searchParams.set("checkAuthenticated", "true");
			location.replace(url);
        } else {
            alert("비밀번호를 확인해 주세요.");
        }
    });
}
</script>
