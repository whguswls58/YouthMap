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
        
        String jsonData = service.getYouthPolicies();		// service 클래스에 정책 정보 요청 
        System.out.println(jsonData);
        
        // JSON 파싱
        JSONParser parser = new JSONParser();
        JSONObject jsonObject = (JSONObject) parser.parse(jsonData);
        JSONObject dataObject = (JSONObject) jsonObject.get("result");
        
        JSONObject pagging = (JSONObject)dataObject.get("pagging");
        System.out.println(pagging.get("totCount"));
        
        List<PolicyModel> pm = new ArrayList<PolicyModel>();
        
        // JSON에서 정책 데이터 추출
        JSONArray plycList = (JSONArray)dataObject.get("youthPolicyList");
        
        for( Object obj : plycList) {
        	JSONObject policy = (JSONObject) obj;
        	PolicyModel plcyMd = new PolicyModel();
        	
        	if(((String)policy.get("rgtrHghrkInstCdNm")).equals("서울특별시")) {
        		
        		plcyMd.setPlcy_no((String)policy.get("plcyNo"));
        		plcyMd.setPlcy_nm((String)policy.get("plcyNm"));
        		plcyMd.setPlcy_expln_cn((String)policy.get("plcyExplnCn"));
        		plcyMd.setPlcy_kywd_nm((String)policy.get("plcyKywdNm"));
        		plcyMd.setLclsf_nm((String)policy.get("lclsfNm"));
        		plcyMd.setMclsf_nm((String)policy.get("mclsfNm"));
        		plcyMd.setPlcy_sprt_cn((String)policy.get("plcySprtCn"));
        		
        		pm.add(plcyMd);
        	}
        	
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
