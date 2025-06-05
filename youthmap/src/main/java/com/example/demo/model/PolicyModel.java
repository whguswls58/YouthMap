package com.example.demo.model;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("policy")
public class PolicyModel {
	
	private String plcy_no;			// 정책 번호
	private String plcy_nm;			// 정책명
	private String plcy_expln_cn;	// 정책 설명
	private String plcy_kywd_nm;	// 정책 키워드명
	private String lclsf_nm;		// 소분류명
	private String mclsf_nm;		// 중분류명
	private String plcy_sprt_cn;	// 정책 지원 내용
	private Date biz_prd_bgng_ymd;	// 사업 시작일
	
//	biz_prd_end_ymd	DATE	사업 종료일
//	plcy_aply_mthd_cn	VARCHAR2(3000)	정책 신청 방법 내용
//	srng_mthd_cn	VARCHAR2(3000)	심사 방법 내용
//	aply_url_addr	VARCHAR2(500)	신청 URL 주소
//	sbmsn_dcmnt_cn	VARCHAR2(3000)	제출 서류 내용
//	etc_mttr_cn	VARCHAR2(3000)	기타 유의 사항 내용
//	ref_url_addr1	VARCHAR2(500)	참고 URL 주소 1
//	ref_url_addr2	VARCHAR2(500)	참고 URL 주소 2
//	sprt_scl_lmt_yn	CHAR(1)	지원 규모 제한 여부 (Y/N)
//	sprt_scl_cnt	NUMBER	지원 규모 수
//	sprt_trgt_age_lmt_yn	CHAR(1)	지원 대상 연령 제한 여부 (Y/N)
//	sprt_trgt_min_age	NUMBER	지원 대상 최소 연령
//	sprt_trgt_max_age	NUMBER	지원 대상 최대 연령
//	rgtr_hghrk_inst_cd_nm	VARCHAR2(100)	등록 최고 기관명
//	rgtr_up_inst_cd_nm	VARCHAR2(100)	등록 상위 기관명
//	rgtr_inst_cd_nm	VARCHAR2(100)	등록 기관명
//	mrg_stts_cd	VARCHAR2(10)	혼인 상태 코드
//	earn_cnd_se_cd	VARCHAR2(10)	소득 조건 구분 코드
//	earn_min_amt	NUMBER	소득 최소 금액
//	earn_max_amt	NUMBER	소득 최대 금액
//	earn_etc_cn	VARCHAR2(500)	소득 기타 내용
//	add_aply_qlfc_cnd_cn	VARCHAR2(3000)	추가 신청 자격 조건 내용
//	inq_cnt	NUMBER	조회 수
//	aply_ymd_strt	DATE	신청 시작일
//	aply_ymd_end	DATE	신청 종료일
	
}
