package com.example.demo.model;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("policy")
public class PolicyModel {
	
	private String plcy_no;						// 정책 번호
	private String plcy_nm;						// 정책명
	private String plcy_expln_cn;				// 정책 설명
	private String plcy_kywd_nm;				// 정책 키워드명
	private String lclsf_nm;					// 소분류명
	private String mclsf_nm;					// 중분류명
	private String plcy_sprt_cn;				// 정책 지원 내용	
	private String biz_prd_bgng_ymd;			// 사업 시작일
	private String biz_prd_end_ymd;				// 사업 종료일
	private String plcy_aply_mthd_cn; 			// 정책 신청 방법 내용
	private String srng_mthd_cn;				// 심사 방법 내용
	private String aply_url_addr;				// 신청 URL 주소
	private String sbmsn_dcmnt_cn;				// 제출 서류 내용
	private String etc_mttr_cn;					// 기타 유의 사항 내용
	private String ref_url_addr1;				// 참고 URL 주소 1
	private String ref_url_addr2;				// 참고 URL 주소 2
	private String sprt_scl_lmt_yn;				// 지원 규모 제한 여부 (Y/N)
	private String sprt_scl_cnt;				// 지원 규모 수
	private String sprt_trgt_age_lmt_yn; 		// 지원 대상 연령 제한 여부 (Y/N)
	private String sprt_trgt_min_age;			// 지원 대상 최소 연령
	private String sprt_trgt_max_age;			// 지원 대상 최대 연령
	private String rgtr_hghrk_inst_cd_nm;		// 등록 최고 기관명
	private String rgtr_up_inst_cd_nm;			// 등록 상위 기관명
	private String rgtr_inst_cd_nm;				// 등록 기관명
	private String mrg_stts_cd;					// 혼인 상태 코드
	private String earn_cnd_se_cd;				// 소득 조건 구분 코드
	private String earn_min_amt;				// 소득 최소 금액
	private String earn_max_amt;				// 소득 최대 금액
	private String earn_etc_cn;					// 소득 기타 내용
	private String add_aply_qlfc_cnd_cn;		// 추가 신청 자격 조건 내용
	private int inq_cnt;						// 조회 수
	private String aply_ymd_strt;				// 신청 시작일
	private String aply_ymd_end;			 	// 신청 종료일
	
	private String frst_reg_dt;					// 최초 등록일
    private String last_mdfcn_dt;				// 마지막 수정일
	
    private Date reg_date;						// 마지막 insert 수행한 시간
    
    
    // 검색어 및 카테고리
    private String searchInput;
    private String mainCategory;
    
    
}
