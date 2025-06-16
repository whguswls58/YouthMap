package com.example.demo.controller;

import java.io.FileReader;
import java.io.Reader;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.model.PolicyModel;
import com.example.demo.service.PolicyService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor // Constructor DI :생성자의 매개변수로 의존성 주입
@Controller
public class PolicyController {

//	@Autowired						// setter DI
//	private PolicyService service; 

	private final PolicyService service;

	@RequestMapping("/")
	public String tt() {
		return "policy/test";
	}

	// 정책 데이터 수동 업데이트
	@RequestMapping("/policyUpdate")
	public String policyUpdate() throws Exception {
		service.executePolicyUpdate();
		return "policy/test3";
	}

	// 정책 메인 페이지
	@RequestMapping("policyMain")
	public String policyMain(@RequestParam(value = "page", defaultValue = "1") int page,
							 @ModelAttribute PolicyModel pm,
							 Model model) {

		int limit = 6; // 한 페이지에 출력할 데이터 갯수
		int listcount = service.cntData(pm); // 총 데이터 갯수
		System.out.println("listcount : " + listcount);

		int startRow = (page - 1) * limit + 1; // 시작번호
		int endRow = page * limit; // 끝번호

		pm.setStartRow(startRow);
		pm.setEndRow(endRow);
		List<PolicyModel> pmList = service.plcyListByPage(pm); // 페이징 적용된 리스트

		// 총 페이지수
		int pagecount = listcount / limit + ((listcount % limit == 0) ? 0 : 1);
		int startpage = ((page - 1) / 6) * limit + 1;
		int endpage = startpage + 6 - 1;

		if (endpage > pagecount)
			endpage = pagecount;

		model.addAttribute("page", page);
		model.addAttribute("pmList", pmList);
		model.addAttribute("listcount", listcount);
		model.addAttribute("pagecount", pagecount);
		model.addAttribute("startpage", startpage);
		model.addAttribute("endpage", endpage);
		return "policy/policyMain";
	}

	// 정책 메인 페이지 비동기 테스트용
	@RequestMapping("policytest")
	public String policyTest(@RequestParam(value = "page", defaultValue = "1") int page,
							@ModelAttribute PolicyModel pm,
							Model model) {

		int limit = 6; // 한 페이지에 출력할 데이터 갯수
		int listcount = service.cntData(pm); // 총 데이터 갯수
		System.out.println("listcount : " + listcount);

		int startRow = (page - 1) * limit + 1; // 시작번호
		int endRow = page * limit; // 끝번호

		pm.setStartRow(startRow);
		pm.setEndRow(endRow);
		List<PolicyModel> pmList = service.plcyListByPage(pm); // 페이징 적용된 리스트

		// 총 페이지수
		int pagecount = listcount / limit + ((listcount % limit == 0) ? 0 : 1);
		int startpage = ((page - 1) / 6) * limit + 1;
		int endpage = startpage + 6 - 1;

		if (endpage > pagecount)
			endpage = pagecount;

		List<Map<String, Object>> categoryList = new ArrayList<>();

		categoryList.add(Map.of(
			"name", "일자리",
			"icon", "icon-job.png",
			"subcategories", List.of("취업", "재직자", "창업")
		));

		categoryList.add(Map.of(
			"name", "주거",
			"icon", "icon-house.png",
			"subcategories", List.of("주택 및 거주지", "기숙사", "전월세 및 주거급여 지원")
		));

		categoryList.add(Map.of(
			"name", "교육",
			"icon", "icon-aducation.png",
			"subcategories", List.of("미래역량강화", "교육비지원", "온라인교육")
		));
		
		categoryList.add(Map.of(
			"name", "복지문화",
			"icon", "icon-aducation.png",
			"subcategories", List.of("취약계층 및 금융지원", "건강", "예술인지원", "문화활동")
		));
		
		categoryList.add(Map.of(
			"name", "참여권리",
			"icon", "icon-aducation.png",
			"subcategories", List.of("청년참여", "정책인프라구축", "청년국제교류", "권익보호")
		));
		
		model.addAttribute("page", page);
		model.addAttribute("pmList", pmList);
		model.addAttribute("listcount", listcount);
		model.addAttribute("pagecount", pagecount);
		model.addAttribute("startpage", startpage);
		model.addAttribute("endpage", endpage);
		model.addAttribute("categoryList", categoryList);
		return "policy/policytest";
	}

	// 비동기용 json 반환
	@GetMapping("/policyListJson")
	@ResponseBody
	public Map<String, Object> getPolicyListJson(@RequestParam(name = "page") int page,
												 @ModelAttribute PolicyModel pm,
												 @RequestParam(name = "selectedCategories") List<String> categories) {

		System.out.println("현재 페이지 : " + page);
		System.out.println("현재 검색어 : " + pm.getSearchInput());
		System.out.println("현재 메인카테고리 : " + pm.getMainCategory());
		System.out.println("현재 선택된 카테고리 : " + categories);
		
		pm.setCategories(categories);
		
		int limit = 6;
		int listcount = service.cntData(pm);
		System.out.println("검색 된 결과 : " + listcount);
		int startRow = (page - 1) * limit + 1;
		int endRow = page * limit;
		
		pm.setStartRow(startRow);
		pm.setEndRow(endRow);
		List<PolicyModel> pmList = service.plcyListByPage(pm); // 페이징 적용된 리스트

		int pagecount = listcount / limit + ((listcount % limit == 0) ? 0 : 1);
		int startpage = ((page - 1) / 6) * limit + 1;
		int endpage = Math.min(startpage + 6 - 1, pagecount);
		
		

		Map<String, Object> map = new HashMap<>();
		map.put("pmList", pmList);
		map.put("page", page);
		map.put("pagecount", pagecount);
		map.put("startpage", startpage);
		map.put("endpage", endpage);
		map.put("listcount", listcount);
		
		return map;
	}

	// 정책 상세 페이지
	@RequestMapping("policyContent")
	public String policyContent(@RequestParam("plcy_no") String plcy_no, Model model) {

		// 상세 데이터 검색
		PolicyModel plcy = service.plcyContent(plcy_no);

		model.addAttribute("plcy", plcy);
		return "policy/contentTest";
//		return "policy/policyContent";
	}

}
