<%@page import="sm.data.MemberDAO"%>
<%@page import="sm.data.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>update</title>
<style>
  :root {
    --bg: #f4f7f6;
    --card: #ffffff;
    --text: #2b2b2b;
    --muted: #6b7280;
    --primary: #4f6bd9;     /* 메인 컬러(파란계열) */
    --primary-dark: #3a50b0;
    --accent: #28a745;        /* 확인/성공 색상 */
    --danger: #e24b4b;
    --border: #e5e7eb;
    --shadow: 0 6px 18px rgba(0,0,0,.08);
  }

  * { box-sizing: border-box; }
  html, body { height: 100%; }
  body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: var(--bg);
    color: var(--text);
    display: flex;
    justify-content: center;
    align-items: flex-start;
    padding: 40px 16px;
  }

  .container {
    width: 100%;
    max-width: 800px;
  }

  /* 카드 스타일링으로 메인과 어울리게 꾸미기 */
  .card {
    background: var(--card);
    border-radius: 12px;
    padding: 20px;
    margin: 12px 0;
    box-shadow: var(--shadow);
    border: 1px solid var(--border);
  }

  h1 {
    font-size: 28px;
    margin: 0 0 12px;
    color: var(--text);
  }

  .form-grid {
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: 12px 20px;
    align-items: center;
  }

  .form-grid > label {
    justify-self: start;
    padding-right: 6px;
    color: var(--muted);
  }

  .form-grid .field {
    display: flex;
    flex-direction: column;
  }

  input[type="text"],
  input[type="password"] {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid var(--border);
    border-radius: 6px;
    font-size: 16px;
    background: #fff;
  }

  input[readonly] {
    background: #f3f4f6;
    color: #555;
  }

  .btns {
    display: flex;
    gap: 12px;
    margin-top: 14px;
  }

  button, input[type="submit"] {
    padding: 10px 16px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 600;
  }

  .btn {
    background: var(--primary);
    color: #fff;
  }

  .btn.secondary {
    background: #e6e6e6;
    color: #333;
  }

  .btn.danger {
    background: var(--danger);
    color: #fff;
  }

  .hint {
    font-size: 12px;
    color: var(--muted);
    margin-top: 6px;
  }

  /* 반응형: 작은 화면에서 한 열로 */
  @media (max-width: 640px) {
    .form-grid {
      grid-template-columns: 1fr;
    }
  }
</style>
</head>
<body>
	<h1>정보 수정</h1>
<%
	MemberDTO dto = new MemberDTO();
	MemberDAO dao = MemberDAO.getInstance();
	
	String user_id = (String)session.getAttribute("sid");
	dto = dao.getInfo(user_id);
%>
<div>
	<form action="infoUpdatePro.jsp" method="post" class="update-form" onsubmit="return sendData()">
		<div class="form-grid">
            <label>아이디</label>
            <div class="field">
              	<input readonly="readonly" type="text" name="user_id" value="<%=user_id%>"/>
              	<span class="hint" style="margin-top:4px;">아이디는 변경할 수 없습니다.</span>
            </div>

            <label>이름</label>
            <div class="field">
              	<input type="text" name="username" value="<%=dto.getUsername()%>"/>
            </div>

            <label>이메일</label>
            <div class="field">
           	  	<input type="text" name="email" value="<%=dto.getEmail() %>"/>
            </div>
            
            <label>주소</label>
            <div class="field">
           	  	<input type="text" name="address" value="<%=dto.getAddress() %>"/>
            </div>

            <label>전화번호</label>
            <div class="field">
              	<input type="text" name="phone" value="<%=dto.getPhone() %>"/>
            </div>

            <label>주민번호</label>
            <div class="field">
              	<input type="text" name="resident_registration_number" value="<%=dto.getResident_registration_number()%>"/>
            </div>

            <label>비밀번호</label>
            <div class="field">
              	<input type="password" name="password_hash" id="password_hash"/>
              	<span class="hint" id="password_hint" style="margin-top:4px;"></span>
            </div>
          </div>

          <div class="btns" style="justify-content:flex-start;">
            <input type="submit" value="수정" class="btn" />
            <input type="reset" value="다시쓰기" class="btn secondary" />
		</div>
	</form>
</div>

  
<script type="text/javascript">
	function sendData() {
		var pw = document.getElementById("password_hash").value.trim();
		var hint = document.getElementById("password_hint");
		
		if(pw.length == 0){
			hint.textContent = '비밀번호를 입력하세요.';
			return false;
		}else{
			return true;
		}	
	}
	
</script>
</body>
</html>