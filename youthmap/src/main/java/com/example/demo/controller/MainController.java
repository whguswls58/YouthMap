package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.model.Board;
import com.example.demo.service.BoardService;

@Controller
public class MainController {
	
	@Autowired
    private BoardService boardService;

	@GetMapping("/")
	public String mainPage(Model model) {
        // 공지사항 3개 가져오기
        List<Board> noticeList = boardService.getTopNotices(); // 이미 있는 메서드 사용
        model.addAttribute("noticeList", noticeList);

        return "mainPage/main";
	}
}
