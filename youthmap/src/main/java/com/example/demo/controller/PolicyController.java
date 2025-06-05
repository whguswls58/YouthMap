package com.example.demo.controller;

import java.io.FileReader;
import java.io.Reader;
import java.util.Arrays;
import java.util.Set;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.core.io.ClassPathResource;
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
	public String test() throws Exception{
		
		// JSON 파일 경로 설정
        ClassPathResource resource = new ClassPathResource("static/policy/test.json");
        String path = resource.getFile().getAbsolutePath();
		
        System.out.println(path);
        
        // JSON 파싱
        JSONParser parser = new JSONParser();
        Reader reader = new FileReader(path);
        JSONObject jsonObject = (JSONObject) parser.parse(reader);
        JSONObject dataObject = (JSONObject) jsonObject.get("result");
        
        // 정책 이름 정렬
        JSONArray plycList = (JSONArray)dataObject.get("youthPolicyList");
        for( Object obj : plycList) {
        	JSONObject policy = (JSONObject) obj;
        	System.out.println("정책이름 : " + policy.get("plcyNm"));
        }
        
		return "test";
	}
	
}
