package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.model.MemberModel;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {

    // 로그인 성공 후 이동하는 홈 화면
	@GetMapping("/home")
	public String home(HttpSession session, Model model) {
	    MemberModel loginMember = (MemberModel) session.getAttribute("loginMember");

	    if (loginMember != null) {
	        model.addAttribute("name", loginMember.getMemName()); // 로그인 한 경우에만 이름 전달
	    }

	    return "main"; // views/home.jsp로 통일
	}
	 @GetMapping("/")
	    public String home(@RequestParam(value = "withdrawSuccess", required = false) String success, Model model) {
	        if ("true".equals(success)) {
	            model.addAttribute("withdrawSuccess", true);
	        }
	        return "main"; // views/home.jsp로 통일
	    }
}
