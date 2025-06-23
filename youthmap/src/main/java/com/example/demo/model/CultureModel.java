package com.example.demo.model;

import java.util.Date;


import org.apache.ibatis.type.Alias;

import lombok.Builder;
import lombok.Data;

@Data
@Alias("culture")
//@Builder
public class CultureModel {

	
	private int con_id;						// 콘텐츠 고유번호(예: 전시회 “픽사 전시회”=1번 >> 댓글에 필요)
	private String category_name;			// 카테고리 명칭(전시/미술, 공연, 축제/행사)
	private String con_title;				// (전시/미술,공연,축제/행사) 각 컨텐츠별 이름 ex)픽사 전시회
	private String con_img;					// 대표 이미지(썸네일 &상세 페이지)
	private String con_location;			// 장소명(예: “코엑스 a홀”)
	private String con_lat;					// 경도(X좌표)
	private String con_lot;					// 위도(Y좌표)
	private String con_start_date;			// 시작 날짜(2025~)
	private String con_end_date;			// 종료 날짜(2025~)
	private String con_time;				// api 미제공. 기본 출력되게 추가함
	private String con_age;					// 관람 대상 (나이)
	private String con_cost;				// 입장료
	private String con_link;				// 행사 상세 url  >> api컬럼명은 ORG_LINK
	private Date con_regdate;				// 등록 일시(insert한 날짜 등록 됨. 나중에 api상에서 업데이트 되는 내용이랑 구분)
	private int con_readcount;
	
	// page
	private int startRow;
	private int endRow;
	
	// 검색
	private String search;
	private String keyword;
	 	
}
	 	
//	>>  DATE를 (~) 기준으로 split 해서 con_start_date  ,  con_end_date에 담고
//	con_start_date로 최신순 정렬하면 될 듯??  그럼 con_regdate 필요 없음

	
//	private int review_id2;					// 리뷰 고유번호
//	private int review_score2;				// 별점(1~5)
//	private String review_content2;			// 간단한 리뷰
//	private Date review_register2;			// 리뷰 작성일
//	private String review_file2;			// 첨부파일
//	private int user_id;					// 어떤 회원이 작성했는지
//	

//"DESCRIPTION": {
//    "CODENAME": "분류",		0
//    "ETC_DESC": "기타내용",
//    "ORG_NAME": "기관명",
//    "THEMECODE": "테마분류",
//    "END_DATE": "종료일",
//    "STRTDATE": "시작일",
//    "ORG_LINK": "홈페이지 주소",
//    "MAIN_IMG": "대표이미지",
//    "LAT": "경도(X좌표)",
//    "PLACE": "장소",
//    "PLAYER": "출연자정보",
//    "USE_FEE": "이용요금",
//    "PROGRAM": "프로그램소개",
//    "TICKET": "시민/기관",
//    "RGSTDATE": "신청일",
//    "DATE": "날짜/시간",
//    "GUNAME": "자치구",
//    "HMPG_ADDR": "문화포털상세URL",
//    "IS_FREE": "유무료",
//    "USE_TRGT": "이용대상",
//    "LOT": "위도(Y좌표)",
//    "TITLE": "공연/행사명"
//},




