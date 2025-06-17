
package com.example.demo.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.model.MemberModel;
import com.example.demo.service.MypageService;

import jakarta.servlet.http.HttpSession;

@Controller
public class MypageController {

	@Autowired
	private MypageService mypageService;
	
	
	
	@GetMapping("/mypage")
	public String showMypage(HttpSession session, Model model) {
		//로그인 된 사용자 번호 가져오기
		Long memNo = (Long) session.getAttribute("memberNo");
		
		//로그인 안된 경우 로그인 페이지로 이동
		if (memNo == null) {
			return "redirect:/login";
			
		}
		
		// 회원 정보 + 게시물/댓글 수 조회
		MemberModel member = mypageService.getMemberInfo(memNo);
	
		
		int postCount = mypageService.getPostCount(memNo);
		int commentCount = mypageService.getCommentCount(memNo);
		
		model.addAttribute("member", member);
		model.addAttribute("postCount", postCount);
		model.addAttribute("commentCount", commentCount);
		
		//페이지 리턴 
		return "member/mypage";
		
		
	}
}
