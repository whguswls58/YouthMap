package com.example.demo.controller;

import java.io.FileReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.model.PolicyModel;
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
		
        // System.out.println(path);
        
        // JSON 파싱
        JSONParser parser = new JSONParser();
        Reader reader = new FileReader(path);
        JSONObject jsonObject = (JSONObject) parser.parse(reader);
        JSONObject dataObject = (JSONObject) jsonObject.get("result");
        
        // JSON에서 정책 데이터 추출
        JSONArray plycList = (JSONArray)dataObject.get("youthPolicyList");
        
        List<PolicyModel> pm = new ArrayList<PolicyModel>();
        
        for( Object obj : plycList) {
        	JSONObject policy = (JSONObject) obj;
        	PolicyModel plcyMd = new PolicyModel();
        	
        	plcyMd.setPlcy_no((String)policy.get("plcyNo"));
        	plcyMd.setPlcy_nm((String)policy.get("plcyNm"));
        	plcyMd.setPlcy_expln_cn((String)policy.get("plcyExplnCn"));
        	plcyMd.setPlcy_kywd_nm((String)policy.get("plcyKywdNm"));
        	plcyMd.setLclsf_nm((String)policy.get("lclsfNm"));
        	plcyMd.setMclsf_nm((String)policy.get("mclsfNm"));
        	plcyMd.setPlcy_sprt_cn((String)policy.get("plcySprtCn"));
        	
        	pm.add(plcyMd);
        }
        
        for( PolicyModel obj : pm) {
        	
        	System.out.println(obj.getPlcy_no());
        	System.out.println(obj.getPlcy_nm());
        	System.out.println(obj.getPlcy_expln_cn());
        	System.out.println(obj.getPlcy_kywd_nm());
        	System.out.println(obj.getLclsf_nm());
        	System.out.println(obj.getMclsf_nm());
        	System.out.println(obj.getPlcy_sprt_cn());
        	
        	System.out.println("---------------------------------------------------------------------");
        }
        
        
        
		return "test";
	}
	
}
