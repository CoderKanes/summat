<%@ page import="java.util.Random, java.net.URLEncoder, sm.util.EmailUtil, sm.data.MemberDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String email = request.getParameter("email");
    if (email == null || email.trim().isEmpty()) {
        session.setAttribute("verifyMsg", "이메일이 필요합니다.");
        response.sendRedirect("verifyEmailForm.jsp");
        return;
    }

    // (선택) 가입 여부 확인
    MemberDAO dao = MemberDAO.getInstance();
    boolean exists = dao.existsByEmail(email); // 구현 필요: 이메일 존재 확인 메서드
    if (!exists) {
        session.setAttribute("verifyMsg", "해당 이메일로 가입된 계정이 없습니다.");
        response.sendRedirect("verifyEmailForm.jsp");
        return;
    }

    // OTP 생성
    String otp = String.format("%06d", new Random().nextInt(1000000));
    long expiry = System.currentTimeMillis() + 10 * 60 * 1000L;

    // 세션에 저장 (키 일관성)
    session.setAttribute("otp:" + email, otp);
    session.setAttribute("otp_expiry:" + email, Long.valueOf(expiry));

    // 이메일 발송
    String subject = "회원가입 인증코드";
    String body = "인증코드: " + otp + "\n10분 내 입력하세요.";
    try {
        EmailUtil.sendEmail(email, subject, body);
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("verifyMsg", "인증코드 발송 실패. 다시 시도하세요.");
        response.sendRedirect("verifyEmailForm.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
        return;
    }

    session.setAttribute("verifyMsg", "인증코드를 발송했습니다. 이메일을 확인하세요.");
    response.sendRedirect("verifyEmailForm.jsp?email=" + URLEncoder.encode(email, "UTF-8"));
%>