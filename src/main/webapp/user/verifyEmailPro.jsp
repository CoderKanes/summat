<%@ page import="java.net.URLEncoder, sm.data.MemberDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String email = request.getParameter("email");
    String otp = request.getParameter("otp");

    if (email == null || otp == null) {
        session.setAttribute("verifyMsg", "잘못된 요청입니다.");
        response.sendRedirect("verifyEmailForm.jsp");
        return;
    }

    String sessOtp = (String) session.getAttribute("otp:" + email);
    Object oe = session.getAttribute("otp_expiry:" + email);
    long expiry = (oe instanceof Long) ? ((Long) oe).longValue() : 0L;

    if (sessOtp == null || expiry == 0L) {
        session.setAttribute("verifyMsg", "인증코드가 없습니다. 다시 발송하세요.");
        response.sendRedirect("verifyEmailForm.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
        return;
    }

    if (System.currentTimeMillis() > expiry) {
        session.removeAttribute("otp:" + email);
        session.removeAttribute("otp_expiry:" + email);
        session.setAttribute("verifyMsg", "인증코드가 만료되었습니다. 다시 발송해주세요.");
        response.sendRedirect("verifyEmailForm.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
        return;
    }

    if (!sessOtp.equals(otp)) {
        session.setAttribute("verifyMsg", "인증코드가 일치하지 않습니다.");
        response.sendRedirect("verifyEmailForm.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
        return;
    }

    // 검증 성공 -> DB 업데이트
    try {
        MemberDAO dao = MemberDAO.getInstance();
        dao.verifyEmailByEmail(email); // 구현 필요: email_verified=1 업데이트
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("verifyMsg", "인증 처리 중 오류가 발생했습니다.");
        response.sendRedirect("verifyEmailForm.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
        return;
    }

    // 세션에서 otp 제거
    session.removeAttribute("otp:" + email);
    session.removeAttribute("otp_expiry:" + email);

    session.setAttribute("verifyMsg", "이메일 인증이 완료되었습니다. 로그인 해주세요.");
    response.sendRedirect("loginForm.jsp");
%>