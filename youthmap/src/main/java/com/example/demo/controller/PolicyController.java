package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.model.PolicyModel;
import com.example.demo.service.PolicyService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor // Constructor DI :생성자의 매개변수로 의존성 주입
@Controller
public class PolicyController {

//	@Autowired						// setter DI
//	private PolicyService service; 

	private final PolicyService service;

	// 정책 데이터 수동 업데이트
	@RequestMapping("/policyUpdate")
	public String policyUpdate() throws Exception {
		service.executePolicyUpdate();
		// 추후 관리자 페이지에서 요청 -> 관리자 페이지로 리턴할 예정
		return "policy/test3";
	}
	  
	// 정책 메인 페이지
	@RequestMapping("/policyMain")
	public String policyMain(@RequestParam(value = "page", defaultValue = "1") int page,
							@RequestParam(value = "selectedCategory", required = false) String category,
							@ModelAttribute PolicyModel pm,
							HttpSession session,
							Model model) {

		Long memNo = (Long) session.getAttribute("memberNo");
		
		System.out.println("로그인 중 아이디 : " + memNo);
		
		System.out.println("현재 정렬방법 : " + pm.getSortOrder());
		System.out.println("카테고리 : " + category);
		
		int limit = 10; // 한 페이지에 출력할 데이터 갯수
		int listcount = service.cntData(pm); // 총 데이터 갯수
		System.out.println("listcount : " + listcount);

		int startRow = (page - 1) * limit + 1; // 시작번호
		int endRow = page * limit; // 끝번호

		pm.setStartRow(startRow);
		pm.setEndRow(endRow);
		pm.setSortOrder("views");		// 첫 페이지에서 인기순(조회수 순)으로 결과 출력
		List<PolicyModel> pmList = service.plcyListByPage(pm); // 페이징 적용된 리스트

		for(PolicyModel p : pmList) {
			p.setLclsf_nms(service.splitByComma(p.getLclsf_nm()));
			p.setPlcy_kywd_nms(service.splitByComma(p.getPlcy_kywd_nm()));
		}
		
		// 총 페이지수
		int pagecount = listcount / limit + ((listcount % limit == 0) ? 0 : 1);
		int startpage = ((page - 1) / 6) * limit + 1;
		int endpage = startpage + 6 - 1;

		if (endpage > pagecount)
			endpage = pagecount;

		// 카테고리 상세 항목
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
			"icon", "icon-culture.png",
			"subcategories", List.of("취약계층 및 금융지원", "건강", "예술인지원", "문화활동")
		));
		
		categoryList.add(Map.of(
			"name", "참여권리",
			"icon", "icon-join.png",
			"subcategories", List.of("청년참여", "정책인프라구축", "청년국제교류", "권익보호")
		));
		
		List<String> selectedCategories = null;
		
		if(category != null) {
			Optional<Map<String, Object>> selectedCategory = 
					categoryList.stream().filter(c -> category.equals(c.get("name"))).findFirst();
			
			if (selectedCategory.isPresent()) {
				Map<String, Object> result = selectedCategory.get();
				selectedCategories =(List<String>)result.get("subcategories");
				System.out.println(selectedCategories);
			}		
		}
		
		model.addAttribute("page", page);
		model.addAttribute("pmList", pmList);
		model.addAttribute("listcount", listcount);
		model.addAttribute("pagecount", pagecount);
		model.addAttribute("startpage", startpage);
		model.addAttribute("endpage", endpage);
		model.addAttribute("selectedCategories", selectedCategories);
		model.addAttribute("categoryList", categoryList);
		return "policy/policyMain";
	}

	// 비동기용 json 반환
	@GetMapping("/policyListJson")
	@ResponseBody
	public Map<String, Object> getPolicyListJson(@RequestParam("page") int page,
												 @ModelAttribute PolicyModel pm,
												 @RequestParam("selectedCategories") List<String> categories
												 ) {

		System.out.println("현재 페이지 : " + page);
		System.out.println("현재 검색어 : " + pm.getSearchInput());
		System.out.println("현재 메인카테고리 : " + pm.getMainCategory());
		System.out.println("현재 선택된 카테고리 : " + categories);
		System.out.println("현재 정렬방법 : " + pm.getSortOrder());
		
		
		pm.setCategories(categories);
		
		int limit = 6;
		int listcount = service.cntData(pm);
		System.out.println("검색 된 결과 : " + listcount);
		int startRow = (page - 1) * limit + 1;
		int endRow = page * limit;
		
		pm.setStartRow(startRow);
		pm.setEndRow(endRow);
		List<PolicyModel> pmList = service.plcyListByPage(pm); // 페이징 적용된 리스트
		
		for(PolicyModel p : pmList) {
			System.out.println(p.getLclsf_nm());
			p.setLclsf_nms(service.splitByComma(p.getLclsf_nm()));
			p.setPlcy_kywd_nms(service.splitByComma(p.getPlcy_kywd_nm()));
		}
		
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
	@RequestMapping("/policyContent")
	public String policyContent(@RequestParam("plcy_no") String plcy_no, 
								@RequestParam("page") int page,
								HttpSession session,
								Model model) {

		Long memNo = (Long) session.getAttribute("memberNo");
		
		System.out.println("로그인 중 아이디 : " + memNo);
		
		// 상세 데이터 검색
		PolicyModel plcy = service.plcyContent(plcy_no);
		
		// 검색키워드, 정책 소분류 문자열을 배열로 변환 및 중복 제거
		String[] keywords  = service.splitByComma(plcy.getPlcy_kywd_nm());
		String[] lclsf = service.splitByComma(plcy.getLclsf_nm());
		
		System.out.println(plcy.getAply_ymd_end());
		System.out.println(plcy.getAply_ymd_strt());
		
		// 각 정책코드, 학력코드, 직업코드, 특화분야코드 -> 각각 명칭으로 치환
		plcy.setPlcy_major_cd(service.convertCodes(plcy.getPlcy_major_cd(), service.plcy_major_map));
		plcy.setSchool_cd(service.convertCodes(plcy.getSchool_cd(), service.school_map));
		plcy.setJob_cd(service.convertCodes(plcy.getJob_cd(), service.job_map));
		plcy.setS_biz_cd(service.convertCodes(plcy.getS_biz_cd(), service.sbiz_map));		
	    
		// \n -> <br> 치환
		plcy.setPlcy_sprt_cn(service.convertNewlines(plcy.getPlcy_sprt_cn()));			
		plcy.setEarn_cnd_se_cd(service.convertNewlines(plcy.getEarn_cnd_se_cd()));
		plcy.setPtcp_prp_trgt_cn(service.convertNewlines(plcy.getPtcp_prp_trgt_cn()));
		plcy.setAdd_aply_qlfc_cnd_cn(service.convertNewlines(plcy.getAdd_aply_qlfc_cnd_cn()));
		plcy.setPlcy_aply_mthd_cn(service.convertNewlines(plcy.getPlcy_aply_mthd_cn()));
		plcy.setSrng_mthd_cn(service.convertNewlines(plcy.getSrng_mthd_cn()));
		plcy.setEtc_mttr_cn(service.convertNewlines(plcy.getEtc_mttr_cn()));
		

		model.addAttribute("plcy", plcy);
		model.addAttribute("keywords", keywords);
		model.addAttribute("lclsf", lclsf);
		model.addAttribute("page", page);
		
		return "policy/policyContent";
	}

}
