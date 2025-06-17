package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;

@Controller
public class TLoginController {
	
	@GetMapping("/temp-login")
    public String tempLogin(HttpSession session) {
        // 임시 로그인 정보 저장
        session.setAttribute("loginId", "tester");   // 사용자 아이디
        session.setAttribute("loginNo", 21);          // 사용자 번호
        session.setAttribute("loginRole", "USER"); // 사용자 권한 (USER 또는 ADMIN)
        return "redirect:/boardlist"; // 로그인 후 게시판으로 이동
    }
	
	@GetMapping("/admin-login")
	public String adminLogin(HttpSession session) {
	    session.setAttribute("loginId", "admin");     // 관리자 ID
	    session.setAttribute("loginNo", 43);         // 관리자 번호 (임의 숫자)
	    session.setAttribute("loginRole", "ADMIN");   // 관리자 권한

	    return "redirect:/boardlist"; // 메인페이지나 원하는 위치로 이동
	}

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 초기화
        return "redirect:/boardlist";
    }

}
