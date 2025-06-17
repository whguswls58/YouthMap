package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.service.AdminService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	private  AdminService adminService;

    // 관리자 로그인 페이지 (GET)
    @GetMapping("/login")
    public String adminLoginForm() {
        return "admin/login"; // templates/admin/login.html
    }

    // 관리자 로그인 처리 (POST)
    @PostMapping("/loginProc")
    public String adminLoginProc(@RequestParam("adminId") String adminId,
                                 @RequestParam("adminPass") String adminPass,
                                 HttpSession session,
                                 Model model) {

        // 간단한 예시 (나중에 DB 연동 가능)
        if ("admin".equals(adminId) && "1234".equals(adminPass)) {
            session.setAttribute("adminLogin", true);
            return "redirect:/admin/dashboard";
        } else {
            model.addAttribute("error", "아이디 또는 비밀번호가 틀렸습니다.");
            return "admin/login";
        }
    }

    // 관리자 대시보드
    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        if (session.getAttribute("adminLogin") == null) {
            return "redirect:/admin/login";
        }

        model.addAttribute("userCount", adminService.getUserCount());
        model.addAttribute("postCount", adminService.getPostCount());
        model.addAttribute("commentCount", adminService.getCommentCount());

        return "admin/dashboard";
    }

    // 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/admin/login";
    }
    
}
