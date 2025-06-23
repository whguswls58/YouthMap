package com.example.demo.controller;


import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.model.MemberModel;
import com.example.demo.model.Board;
import com.example.demo.model.Comment;
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
	
	// 내 게시물 조회
	@GetMapping("/mypage/posts")
	public String showMyPosts(HttpSession session, Model model, 
	                         @org.springframework.web.bind.annotation.RequestParam(value = "page", defaultValue = "1") int page) {
		Long memNo = (Long) session.getAttribute("memberNo");
		
		if (memNo == null) {
			return "redirect:/login";
		}
		
		int limit = 10; // 페이지당 10개
		List<Board> myPosts = mypageService.getMyPosts(memNo, page, limit);
		MemberModel member = mypageService.getMemberInfo(memNo);
		int postCount = mypageService.getPostCount(memNo);
		
		// 페이징 정보 계산
		int totalPages = (int) Math.ceil((double) postCount / limit);
		
		model.addAttribute("myPosts", myPosts);
		model.addAttribute("member", member);
		model.addAttribute("postCount", postCount);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("limit", limit);
		
		return "member/mypage-posts";
	}
	
	// 내 댓글 조회
	@GetMapping("/mypage/comments")
	public String showMyComments(HttpSession session, Model model,
	                            @org.springframework.web.bind.annotation.RequestParam(value = "page", defaultValue = "1") int page) {
		Long memNo = (Long) session.getAttribute("memberNo");
		
		if (memNo == null) {
			return "redirect:/login";
		}
		
		int limit = 10; // 페이지당 10개
		List<Comment> myComments = mypageService.getMyComments(memNo, page, limit);
		MemberModel member = mypageService.getMemberInfo(memNo);
		int commentCount = mypageService.getCommentCount(memNo);
		
		// 페이징 정보 계산
		int totalPages = (int) Math.ceil((double) commentCount / limit);
		
		model.addAttribute("myComments", myComments);
		model.addAttribute("member", member);
		model.addAttribute("commentCount", commentCount);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("limit", limit);
		
		return "member/mypage-comments";
	}
}
