package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.service.PolicyService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor			// Constructor DI :생성자의 매개변수로 의존성 주입
@Controller
public class PolicyController {

	
//	@Autowired						// setter DI
//	private PolicyService service; 

	private final PolicyService service;
	
	@RequestMapping("/")
	public String main() {
		return "test";
	}
	
	
}
