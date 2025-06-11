package com.example.demo.controller;

import java.io.FileReader;
import java.io.Reader;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	public String tt() {	
		return "test";
	}
	
	@RequestMapping("/ttt")
	public String test(Model model) throws Exception{
        
		// 총 정책수   
		String jsonData = service.getYouthPolicies(1, 1);		// service 클래스에 정책 정보 요청 
        System.out.println("총 정책수 체크");
        
        // JSON 파싱
        JSONParser parser = new JSONParser();
        JSONObject jsonObject = (JSONObject) parser.parse(jsonData);
        JSONObject dataObject = (JSONObject) jsonObject.get("result");
        
        JSONObject pagging = (JSONObject)dataObject.get("pagging");
        int totCount = ((Long) pagging.get("totCount")).intValue();
        System.out.println(totCount);
        
        // 세부 데이터 파싱 후 리스트에 저장
        // db의 데이터 갯수가 0개일 때 - 리스트에 저장된 데이터 전체 DB에 저장
        // db의 데이터 갯수가 0개가 아닐때 - 리스트에 최신글만 저장
        // 최신글 기준 : "lastMdfcnDt" - 마지막 데이터 수정 시간 > DB에서 가장 마지막에 추가한 데이터 수정 시간 (compareTo() 메소드 이용)
        // 최신글이 있으면 기존에 있던 데이터 update 실행, 기존에 없던 데이터 insert 실행
        // 최신글이 없으면 return문으로 빠져나감
        
        int totDB = service.cntData();
        System.out.println("서버에 저장된 총 정책 갯수 : " + totDB);
        
        Date lastUpdateDate = service.lastUpdate();
        String dateTimeStr = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date inputDate = null;
        
        int pageSize = 20;
        int pageCount = totCount / pageSize + ((totCount % pageSize == 0) ? 0 : 1);
        
        List<PolicyModel> pm = new ArrayList<PolicyModel>();
        
        for(int pageNum=1 ; pageNum < 11 ; pageNum++) {
        	System.out.println("=====================================================");
        	System.out.println("page 번호 : " + pageNum);
        	
        	int maxRetry = 3;
        	jsonData = null;
        	
        	for (int attempt = 1; attempt <= maxRetry; attempt++) {			// 최대 3회 재시도
        	    jsonData = service.getYouthPolicies(pageNum, pageSize);		// service 클래스에 정책 정보 요청 

        	    if (jsonData != null && !jsonData.trim().isEmpty()) {
        	        break; // 정상 응답 → 루프 탈출
        	    } else {
        	        System.out.println("jsonData가 null 또는 빈값입니다. 재시도 중... (시도 " + attempt + "/" + maxRetry + ")");
        	        Thread.sleep(1000); // 1초 대기 후 재시도 (필요시 증가 가능)
        	    }
        	}
        	
        	// JSON 파싱
        	parser = new JSONParser();
        	jsonObject = (JSONObject) parser.parse(jsonData);
        	dataObject = (JSONObject) jsonObject.get("result");
        	
        	// JSON에서 정책 데이터 추출
        	JSONArray plycList = (JSONArray)dataObject.get("youthPolicyList");
        	
        	for( Object obj : plycList) {
        		JSONObject policy = (JSONObject) obj;
        		PolicyModel plcyMd = new PolicyModel();
        		
        		if(((String)policy.get("rgtrHghrkInstCdNm")).equals("서울특별시") ||
        			((String)policy.get("rgtrHghrkInstCdNm")).equals("고용노동부") ||
        			((String)policy.get("rgtrHghrkInstCdNm")).equals("교육부")) {
        			
        			dateTimeStr = (String)policy.get("lastMdfcnDt");        			
        			inputDate = sdf.parse(dateTimeStr);
        			
        			if(totDB == 0) {	// DB에 데이터가 없는 경우
        				plcyMd.setPlcy_no((String)policy.get("plcyNo"));
        				plcyMd.setPlcy_nm((String)policy.get("plcyNm"));
        				plcyMd.setPlcy_expln_cn((String)policy.get("plcyExplnCn"));
        				plcyMd.setPlcy_kywd_nm((String)policy.get("plcyKywdNm"));
        				plcyMd.setLclsf_nm((String)policy.get("lclsfNm"));
        				plcyMd.setMclsf_nm((String)policy.get("mclsfNm"));
        				plcyMd.setPlcy_sprt_cn((String)policy.get("plcySprtCn"));        			        			
        				plcyMd.setBiz_prd_bgng_ymd((String)policy.get("bizPrdBgngYmd"));
        				plcyMd.setBiz_prd_end_ymd((String)policy.get("bizPrdEndYmd"));
        				plcyMd.setPlcy_aply_mthd_cn((String)policy.get("plcyAplyMthdCn"));
        				plcyMd.setSrng_mthd_cn((String)policy.get("srngMthdCn"));
        				plcyMd.setAply_url_addr((String)policy.get("aplyUrlAddr"));
        				plcyMd.setSbmsn_dcmnt_cn((String)policy.get("sbmsnDcmntCn"));
        				plcyMd.setEtc_mttr_cn((String)policy.get("etcMttrCn"));
        				plcyMd.setRef_url_addr1((String)policy.get("refUrlAddr1"));
        				plcyMd.setRef_url_addr2((String)policy.get("refUrlAddr2"));
        				plcyMd.setSprt_scl_lmt_yn((String)policy.get("sprtSclLmtYn"));
        				plcyMd.setSprt_scl_cnt((String)policy.get("sprtSclCnt"));
        				plcyMd.setSprt_trgt_age_lmt_yn((String)policy.get("sprtTrgtAgeLmtYn"));
        				plcyMd.setSprt_trgt_min_age((String)policy.get("sprtTrgtMinAge"));
        				plcyMd.setSprt_trgt_max_age((String)policy.get("sprtTrgtMaxAge"));
        				plcyMd.setRgtr_hghrk_inst_cd_nm((String)policy.get("rgtrHghrkInstCdNm"));
        				plcyMd.setRgtr_up_inst_cd_nm((String)policy.get("rgtrUpInstCdNm"));
        				plcyMd.setRgtr_inst_cd_nm((String)policy.get("rgtrInstCdNm"));
        				plcyMd.setMrg_stts_cd((String)policy.get("mrgSttsCd"));
        				plcyMd.setEarn_cnd_se_cd((String)policy.get("earnCndSeCd"));
        				plcyMd.setEarn_min_amt((String)policy.get("earnMinAmt"));
        				plcyMd.setEarn_max_amt((String)policy.get("earnMaxAmt"));
        				plcyMd.setEarn_etc_cn((String)policy.get("earnEtcCn"));
        				plcyMd.setAdd_aply_qlfc_cnd_cn((String)policy.get("addAplyQlfcCndCn"));
        				plcyMd.setInq_cnt(Integer.parseInt((String)policy.get("inqCnt")));
        				
        				String dateRange = (String)policy.get("aplyYmd");
        				
        				// "~" 기준으로 분할하고 trim
        				String[] dates = dateRange.split("~");
        				String startDate = null;
        				String endDate = null;
        				
        				if(dates.length >= 2) {
        					startDate = dates[0].trim();
        					endDate = dates[1].trim();        			        	        	
        				}
        				
        				plcyMd.setAply_ymd_strt(startDate);
        				plcyMd.setAply_ymd_end(endDate);
        				plcyMd.setFrst_reg_dt((String)policy.get("frstRegDt"));
        				plcyMd.setLast_mdfcn_dt((String)policy.get("lastMdfcnDt"));
        				
        				pm.add(plcyMd);

        			}else {			// DB에 데이터가 있는 경우
        				if(inputDate.compareTo(lastUpdateDate) > 0) {	// DB에 업데이트된 이후에 추가 및 수정된 게시글
        					plcyMd.setPlcy_no((String)policy.get("plcyNo"));
            				plcyMd.setPlcy_nm((String)policy.get("plcyNm"));
            				plcyMd.setPlcy_expln_cn((String)policy.get("plcyExplnCn"));
            				plcyMd.setPlcy_kywd_nm((String)policy.get("plcyKywdNm"));
            				plcyMd.setLclsf_nm((String)policy.get("lclsfNm"));
            				plcyMd.setMclsf_nm((String)policy.get("mclsfNm"));
            				plcyMd.setPlcy_sprt_cn((String)policy.get("plcySprtCn"));        			        			
            				plcyMd.setBiz_prd_bgng_ymd((String)policy.get("bizPrdBgngYmd"));
            				plcyMd.setBiz_prd_end_ymd((String)policy.get("bizPrdEndYmd"));
            				plcyMd.setPlcy_aply_mthd_cn((String)policy.get("plcyAplyMthdCn"));
            				plcyMd.setSrng_mthd_cn((String)policy.get("srngMthdCn"));
            				plcyMd.setAply_url_addr((String)policy.get("aplyUrlAddr"));
            				plcyMd.setSbmsn_dcmnt_cn((String)policy.get("sbmsnDcmntCn"));
            				plcyMd.setEtc_mttr_cn((String)policy.get("etcMttrCn"));
            				plcyMd.setRef_url_addr1((String)policy.get("refUrlAddr1"));
            				plcyMd.setRef_url_addr2((String)policy.get("refUrlAddr2"));
            				plcyMd.setSprt_scl_lmt_yn((String)policy.get("sprtSclLmtYn"));
            				plcyMd.setSprt_scl_cnt((String)policy.get("sprtSclCnt"));
            				plcyMd.setSprt_trgt_age_lmt_yn((String)policy.get("sprtTrgtAgeLmtYn"));
            				plcyMd.setSprt_trgt_min_age((String)policy.get("sprtTrgtMinAge"));
            				plcyMd.setSprt_trgt_max_age((String)policy.get("sprtTrgtMaxAge"));
            				plcyMd.setRgtr_hghrk_inst_cd_nm((String)policy.get("rgtrHghrkInstCdNm"));
            				plcyMd.setRgtr_up_inst_cd_nm((String)policy.get("rgtrUpInstCdNm"));
            				plcyMd.setRgtr_inst_cd_nm((String)policy.get("rgtrInstCdNm"));
            				plcyMd.setMrg_stts_cd((String)policy.get("mrgSttsCd"));
            				plcyMd.setEarn_cnd_se_cd((String)policy.get("earnCndSeCd"));
            				plcyMd.setEarn_min_amt((String)policy.get("earnMinAmt"));
            				plcyMd.setEarn_max_amt((String)policy.get("earnMaxAmt"));
            				plcyMd.setEarn_etc_cn((String)policy.get("earnEtcCn"));
            				plcyMd.setAdd_aply_qlfc_cnd_cn((String)policy.get("addAplyQlfcCndCn"));
            				plcyMd.setInq_cnt(Integer.parseInt((String)policy.get("inqCnt")));
            				
            				String dateRange = (String)policy.get("aplyYmd");
            				
            				// "~" 기준으로 분할하고 trim
            				String[] dates = dateRange.split("~");
            				String startDate = null;
            				String endDate = null;
            				
            				if(dates.length >= 2) {
            					startDate = dates[0].trim();
            					endDate = dates[1].trim();        			        	        	
            				}
            				
            				plcyMd.setAply_ymd_strt(startDate);
            				plcyMd.setAply_ymd_end(endDate);
            				plcyMd.setFrst_reg_dt((String)policy.get("frstRegDt"));
            				plcyMd.setLast_mdfcn_dt((String)policy.get("lastMdfcnDt"));
            				
            				pm.add(plcyMd);        					
        				}       				
        			}       			
        		}
        	}
        	Thread.sleep(2000);		// 3초 일시 정지 - 정지 안하면 api에서 파일 read 도중 null값 발생할 수 있음
        }
        
        System.out.println("업데이트할 데이터 수 : " + pm.size());                
        
        int result = 0;
        
        if(totDB == 0 ) {		// db 데이터 수 : 0개 -> pm 전체 insert문 수행
        	
        	for(PolicyModel p : pm) {
        		result = service.insertPolicy(p);        	
        	}
        	
        	if(result == 1) {
        		System.out.println("insert 성공");
        	}else {
        		System.out.println("insert 실패");
        	}
        	
        }else {					// DB에 기존 데이터가 존재하는 경우
        	// pm 리스트에 추가된 모든 plcy_no 값 리스트
        	List<String> plcyNoListPM = pm.stream()
        			.map(PolicyModel::getPlcy_no)
        			.collect(Collectors.toList());
        	
        	// db에 저장된 plcy_no 값 리스트
        	List<String> plcyNoListDB = service.plcyNoList();
        	
        	// pm과 db 리스트의 교집합 - update 할 정책 번호 리스트
        	List<String> common = plcyNoListPM.stream()
        			.filter(plcyNoListDB::contains)
        			.collect(Collectors.toList());        
        	
        	// pm - db 리스트의 차집합 - insert 할 정책 번호 리스트
        	List<String> onlyInPM = plcyNoListPM.stream()
        			.filter(e -> !plcyNoListDB.contains(e))
        			.collect(Collectors.toList());
        	
        	System.out.println("신규 데이터 수 : " + plcyNoListPM.size());
        	System.out.println("기존 데이터 수 : " + plcyNoListDB.size());
        	System.out.println("Update 할 데이터 수 : " + common.size());
        	System.out.println("Insert 할 데이터 수 : " + onlyInPM.size());   	
        	
        }
        
        model.addAttribute("result", result);
        
		return "test3";
	}
	
	@RequestMapping("test2")
	public String test2(Model model) {
		
		List<PolicyModel> pm = service.plcyList();
		
		model.addAttribute("pm", pm);
		return "test2";
	}
	
}
